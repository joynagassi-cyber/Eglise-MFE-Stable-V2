-- Migration: General App Settings
-- Date: 2026-02-10
CREATE TABLE IF NOT EXISTS app_settings (
    key TEXT PRIMARY KEY,
    data JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Enable RLS
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "SuperAdmins can manage app settings" ON app_settings FOR ALL USING (auth.jwt()->>'role' = 'super_admin');
CREATE POLICY "Everyone can read app settings" ON app_settings FOR
SELECT USING (true);
-- Initialize default 
INSERT INTO app_settings (key, data)
VALUES (
        'financial_settings',
        '{"anomalySigmaThreshold": 2.0, "eliminateInternalTransfers": true, "currencyCode": "XOF"}'
    ) ON CONFLICT (key) DO NOTHING;