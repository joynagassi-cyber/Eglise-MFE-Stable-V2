begin;

-- IMPORTANT:
-- Make sure the public schema is exposed in Supabase Dashboard > Data API settings.
-- The GRANTs below only restore SQL privileges; they do not replace the dashboard setting.

create table if not exists public.admin_group_subscriptions (
  user_id uuid not null references auth.users(id) on delete cascade,
  group_id uuid not null references public.groups(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, group_id)
);

create index if not exists admin_group_subscriptions_group_id_idx
  on public.admin_group_subscriptions (group_id);

alter table public.admin_group_subscriptions enable row level security;

drop policy if exists admin_group_subscriptions_self_manage on public.admin_group_subscriptions;
create policy admin_group_subscriptions_self_manage
  on public.admin_group_subscriptions
  for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant usage on schema public to authenticated;
grant select on public.groups to authenticated;
grant select on public.members to authenticated;
grant select on public.profiles to authenticated;
grant select on public.role_secret_codes to authenticated;
grant select, insert, delete on public.admin_group_subscriptions to authenticated;

insert into public.role_secret_codes (role_code, raw_code)
values
  ('administrateur_systeme', 'ADMINISTRATEUR-SYSTEME-C653-2026'),
  ('administrateur_systeme_adjoint', 'ADMINISTRATEUR-SYSTEME-ADJOINT-C495-2026'),
  ('auditeur', 'AUDITEUR-F2CA-2026'),
  ('auditeur_interne', 'AUDITEUR-INTERNE-F559-2026'),
  ('auditeur_interne_adjoint', 'AUDITEUR-INTERNE-ADJOINT-D1CC-2026'),
  ('benevole', 'BENEVOLE-784B-2026'),
  ('chef_chorale', 'CHEF-CHORALE-048C-2026'),
  ('chef_intercession', 'CHEF-INTERCESSION-022E-2026'),
  ('commissaire_aux_comptes', 'COMMISSAIRE-AUX-COMPTES-643F-2026'),
  ('commissaire_aux_comptes_adjoint', 'COMMISSAIRE-AUX-COMPTES-ADJOINT-F5EC-2026'),
  ('commissaire_compte', 'COMMISSAIRE-COMPTE-82FB-2026'),
  ('comptable', 'COMPTABLE-084D-2026'),
  ('comptable_adjoint', 'COMPTABLE-ADJOINT-5FB3-2026'),
  ('conseiller', 'CONSEILLER-151B-2026'),
  ('conseiller_adjoint', 'CONSEILLER-ADJOINT-6E6E-2026'),
  ('conseiller_principal', 'CONSEILLER-PRINCIPAL-82EC-2026'),
  ('coordinateur_formation', 'COORDINATEUR-FORMATION-CD3B-2026'),
  ('donateur', 'DONATEUR-8A53-2026'),
  ('gestionnaire_budget_event', 'GESTIONNAIRE-BUDGET-EVENT-1B26-2026'),
  ('gestionnaire_documents', 'GESTIONNAIRE-DOCUMENTS-450D-2026'),
  ('maitre_chorale', 'MAITRE-CHORALE-306D-2026'),
  ('moniteur_enfants', 'MONITEUR-ENFANTS-13E2-2026'),
  ('organisateur_evenement', 'ORGANISATEUR-EVENEMENT-1BCE-2026'),
  ('pasteur', 'PASTEUR-0081-2026'),
  ('pasteur_adjoint', 'PASTEUR-ADJOINT-B2A0-2026'),
  ('pasteur_principal', 'PASTEUR-PRINCIPAL-6D1A-2026'),
  ('president', 'PRESIDENT-E723-2026'),
  ('president_hommes', 'PRESIDENT-HOMMES-EF7C-2026'),
  ('president_hommes_adjoint', 'PRESIDENT-HOMMES-ADJOINT-26FA-2026'),
  ('president_jeunesse', 'PRESIDENT-JEUNESSE-4B2F-2026'),
  ('president_jeunesse_adjoint', 'PRESIDENT-JEUNESSE-ADJOINT-3B2B-2026'),
  ('presidente_femmes', 'PRESIDENTE-FEMMES-65D7-2026'),
  ('presidente_femmes_adjointe', 'PRESIDENTE-FEMMES-ADJOINTE-C513-2026'),
  ('responsable_archives', 'RESPONSABLE-ARCHIVES-78EE-2026'),
  ('responsable_enfants', 'RESPONSABLE-ENFANTS-2FBC-2026'),
  ('responsable_groupe', 'RESPONSABLE-GROUPE-469E-2026'),
  ('responsable_mission', 'RESPONSABLE-MISSION-A0D3-2026'),
  ('secretaire_adjoint', 'SECRETAIRE-ADJOINT-50FE-2026'),
  ('secretaire_general', 'SECRETAIRE-GENERAL-53D4-2026'),
  ('secretaire_general_adjoint', 'SECRETAIRE-GENERAL-ADJOINT-283B-2026'),
  ('super_admin', 'SUPER-ADMIN-5FA1-2026'),
  ('tresorier', 'TRESORIER-5E47-2026'),
  ('tresorier_adjoint', 'TRESORIER-ADJOINT-54B7-2026'),
  ('validateur_transaction', 'VALIDATEUR-TRANSACTION-6737-2026'),
  ('vice_president', 'VICE-PRESIDENT-0AF7-2026'),
  ('visiteur_temporaire', 'VISITEUR-TEMPORAIRE-8289-2026'),
  ('webmaster', 'WEBMASTER-8B65-2026')
on conflict (role_code) do update
set raw_code = excluded.raw_code;

insert into public.groups (
  church_id,
  label,
  code,
  description,
  is_active,
  created_at,
  updated_at
)
select
  c.id,
  g.label,
  g.code,
  g.description,
  true,
  now(),
  now()
from public.churches c
cross join (
  values
    ('chorale', 'Chorale', 'Groupe de louange et de chant'),
    ('hommes', 'Hommes', 'Ministere des hommes'),
    ('femmes', 'Femmes', 'Ministere des femmes'),
    ('jeunesse', 'Jeunesse', 'Ministere des jeunes'),
    ('enfants', 'Enfants', 'Ministere des enfants'),
    ('intercession', 'Intercession', 'Groupe de priere et d''intercession')
) as g(code, label, description)
where not exists (
  select 1
  from public.groups existing
  where existing.church_id = c.id
    and existing.code = g.code
);

commit;
