-- ═══════════════════════════════════════════════════════════════════════════════
-- Migration: Secure Messaging Infrastructure
-- Date: 2026-02-26
-- Purpose: E2EE key storage, presence tracking, chat_messages encryption support
-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. User Encryption Keys (for E2EE key exchange)
CREATE TABLE IF NOT EXISTS public.user_encryption_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    public_key TEXT NOT NULL,
    key_algorithm TEXT NOT NULL DEFAULT 'x25519',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id)
);
ALTER TABLE public.user_encryption_keys ENABLE ROW LEVEL SECURITY;
-- Everyone can read public keys (needed for encryption)
CREATE POLICY "Public keys are readable by authenticated users" ON public.user_encryption_keys FOR
SELECT TO authenticated USING (true);
-- Users can only manage their own keys
CREATE POLICY "Users manage their own keys" ON public.user_encryption_keys FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
-- 2. Add encrypted_content column to chat_messages
ALTER TABLE public.chat_messages
ADD COLUMN IF NOT EXISTS encrypted_content TEXT,
    ADD COLUMN IF NOT EXISTS encryption_iv TEXT,
    ADD COLUMN IF NOT EXISTS is_encrypted BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS attachment_url TEXT,
    ADD COLUMN IF NOT EXISTS attachment_type TEXT,
    ADD COLUMN IF NOT EXISTS attachment_size INTEGER;
-- 3. Add pinned and last_seen columns to conversations
ALTER TABLE public.conversations
ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ;
-- 4. User Presence table (lightweight, for offline tracking)
CREATE TABLE IF NOT EXISTS public.user_presence (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'offline' CHECK (status IN ('online', 'away', 'offline')),
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE public.user_presence ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Presence is readable by authenticated users" ON public.user_presence FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Users update their own presence" ON public.user_presence FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
-- 5. Function to update presence on heartbeat
CREATE OR REPLACE FUNCTION public.update_user_presence(p_status TEXT DEFAULT 'online') RETURNS VOID AS $$ BEGIN
INSERT INTO public.user_presence (user_id, status, last_seen_at, updated_at)
VALUES (auth.uid(), p_status, NOW(), NOW()) ON CONFLICT (user_id) DO
UPDATE
SET status = p_status,
    last_seen_at = NOW(),
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- 6. Performance indexes
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_created ON public.chat_messages(conversation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_presence_status ON public.user_presence(status)
WHERE status = 'online';
CREATE INDEX IF NOT EXISTS idx_user_encryption_keys_user ON public.user_encryption_keys(user_id);