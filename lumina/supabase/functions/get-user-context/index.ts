import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Logging helper
function log(level: 'info' | 'warn' | 'error', message: string, data?: any) {
    const timestamp = new Date().toISOString()
    console.log(JSON.stringify({ timestamp, level, message, data }))
}

Deno.serve(async (req) => {
    const startTime = Date.now()

    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        log('info', 'get-user-context called')
        // 1. Get User from Auth Header
        const authHeader = req.headers.get('Authorization')
        if (!authHeader) {
            throw new Error('No authorization header')
        }

        // Client to get the user (verifies JWT)
        const supabaseClient = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_ANON_KEY') ?? '',
            { global: { headers: { Authorization: authHeader } } }
        )

        const {
            data: { user },
            error: userError,
        } = await supabaseClient.auth.getUser()

        if (userError || !user) {
            throw new Error('Invalid token')
        }

        // 2. Admin Client for Database Queries (RBAC Tables)
        const adminClient = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        )

        // 3. Get Active Session (Role & Group)
        const { data: sessionData, error: sessionError } = await adminClient
            .from('user_sessions')
            .select('active_role_id, active_group_id')
            .eq('user_id', user.id)
            .single()

        let roleId = sessionData?.active_role_id
        let groupId = sessionData?.active_group_id

        // Fallback: If no ACTIVE session, find the highest priority role (lowest priority_level)
        if (!roleId) {
            const { data: roles } = await adminClient
                .from('user_roles')
                .select('role_id, group_id, roles(priority_level)')
                .eq('user_id', user.id)

            if (roles && roles.length > 0) {
                // Sort by priority_level ascending
                // @ts-ignore
                const sorted = roles.sort((a, b) => (a.roles?.priority_level ?? 100) - (b.roles?.priority_level ?? 100))
                const bestRole = sorted[0]

                roleId = bestRole.role_id
                groupId = bestRole.group_id

                // Auto-create persistent session for next time
                await adminClient.from('user_sessions').upsert({
                    user_id: user.id,
                    active_role_id: roleId,
                    active_group_id: groupId,
                    last_switch: new Date().toISOString()
                })
            }
        }

        if (!roleId) {
            // Un nouvel utilisateur n'a pas encore de rôle assigné.
            // On renvoie un contexte léger "invité" avec needs_onboarding à true
            // pour que le flux d'authentification frontend puisse continuer de manière déterministe.
            const responseData = {
                user: {
                    id: user.id,
                    email: user.email,
                    member_id: null,
                    name: user.user_metadata?.full_name ?? user.user_metadata?.name ?? '',
                },
                role: {
                    code: 'guest',
                    label: 'Invité',
                    is_super: false,
                    level: 'membre',   // champ requis par UserContext.fromJson()
                },
                group: null,
                permissions: {},
                meta: {
                    generated_at: new Date().toISOString(),
                    needs_onboarding: true,
                    church_id: null,
                }
            }
            return new Response(JSON.stringify(responseData), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 200,
            })
        }

        // 4. Fetch Role Details (is_super, jsonb permissions)
        const { data: roleData } = await adminClient
            .from('roles')
            .select('code, label, permissions, is_super')
            .eq('id', roleId)
            .single()

        // 5. Fetch Group Details (if any)
        let groupData = null
        if (groupId) {
            const { data: g } = await adminClient
                .from('groups')
                .select('code, label')
                .eq('id', groupId)
                .single()
            groupData = g
        }

        // 6. Fetch Mapped Permissions (role_permissions JOIN permissions)
        // Note: We need to cast types or use any for the join result if TypeScript complains, 
        // but in plain JS/Deno it's fine.
        const { data: mappedPerms } = await adminClient
            .from('role_permissions')
            .select('scope_constraint, permissions(resource, action)')
            .eq('role_id', roleId)

        // 7. Consolidate Permissions
        // Structure: { "resource": { "action": "scope" } }
        const finalPermissions: Record<string, Record<string, string>> = {}

        // A) Start with JSONB from roles table (if any)
        if (roleData?.permissions) {
            for (const [res, actions] of Object.entries(roleData.permissions)) {
                // actions is like { "read": "all", "write": "group" }
                if (typeof actions === 'object' && actions !== null) {
                    finalPermissions[res] = { ...(actions as Record<string, string>) }
                }
            }
        }

        // B) Overlay mapped permissions from role_permissions table
        if (mappedPerms) {
            for (const item of mappedPerms) {
                // item.permissions is the joined object
                // @ts-ignore: Supabase join typing
                const p = item.permissions
                if (p) {
                    const res = p.resource
                    const act = p.action
                    const scope = item.scope_constraint || 'none'

                    if (!finalPermissions[res]) {
                        finalPermissions[res] = {}
                    }

                    // Logic: "all" overwrites everything. otherwise take the new one.
                    // If existing is "all", keep "all".
                    const current = finalPermissions[res][act]
                    if (current !== 'all') {
                        finalPermissions[res][act] = scope
                    }
                }
            }
        }

        // 8. Fetch Member ID + Profile (needs_onboarding) + Church ID in parallel
        // NOTE: profiles table does NOT have a church_id column.
        // church_id is stored in user_churches table.
        const [memberResult, profileResult, churchResult] = await Promise.all([
            adminClient
                .from('members')
                .select('id')
                .eq('email', user.email)
                .maybeSingle(),
            adminClient
                .from('profiles')
                .select('needs_onboarding')
                .eq('id', user.id)
                .maybeSingle(),
            adminClient
                .from('user_churches')
                .select('church_id')
                .eq('user_id', user.id)
                .eq('is_active', true)
                .maybeSingle()
        ])
        const memberData = memberResult.data
        const profileData = profileResult.data
        const churchData = churchResult.data

        // 9. Construct specific User Context Object
        const responseData = {
            user: {
                id: user.id,
                email: user.email,
                member_id: memberData?.id,
                name: user.user_metadata?.full_name ?? user.user_metadata?.name ?? '',
            },
            role: {
                code: roleData?.code,
                label: roleData?.label,
                is_super: roleData?.is_super ?? false,
                level: roleData?.code ?? 'membre',   // champ toujours présent
            },
            group: groupData ? {
                code: groupData.code,
                label: groupData.label
            } : null,
            permissions: finalPermissions,
            meta: {
                generated_at: new Date().toISOString(),
                needs_onboarding: profileData?.needs_onboarding ?? true,
                church_id: churchData?.church_id ?? null,
            }
        }

        const duration = Date.now() - startTime
        log('info', 'get-user-context success', {
            userId: user.id,
            roleCode: roleData?.code,
            duration
        })

        return new Response(JSON.stringify(responseData), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
        })

    } catch (error) {
        const duration = Date.now() - startTime
        log('error', 'get-user-context failed', {
            error: error.message,
            stack: error.stack,
            duration
        })

        return new Response(JSON.stringify({
            error: error.message,
            timestamp: new Date().toISOString()
        }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
        })
    } finally {
        const duration = Date.now() - startTime
        log('info', 'get-user-context completed', { duration })
    }
})
