-- ═══════════════════════════════════════════════════════════════════════════════
-- OPERATION WAKE UP - SCHEMA SUPABASE
-- Tables: jalons_spirituels, visites_pastorales, membres_jalons
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: jalons_spirituels                                                    │
-- │ Description: Définit les étapes spirituelles possibles (Baptême, etc.)       │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE TABLE IF NOT EXISTS public.jalons_spirituels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    icon_name VARCHAR(50) DEFAULT 'flag',
    color_hex VARCHAR(7) DEFAULT '#1976D2',
    "order" INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour le tri
CREATE INDEX IF NOT EXISTS idx_jalons_order ON public.jalons_spirituels("order");
CREATE INDEX IF NOT EXISTS idx_jalons_active ON public.jalons_spirituels(is_active);

-- Trigger pour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_jalons_updated_at
    BEFORE UPDATE ON public.jalons_spirituels
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: membres_jalons                                                       │
-- │ Description: Association membre <-> jalon (réalisations)                     │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE TABLE IF NOT EXISTS public.membres_jalons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membre_id UUID NOT NULL REFERENCES public.membres(id) ON DELETE CASCADE,
    jalon_id UUID NOT NULL REFERENCES public.jalons_spirituels(id) ON DELETE CASCADE,
    date_realisation DATE NOT NULL,
    lieu VARCHAR(255),
    temoin VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(membre_id, jalon_id)
);

CREATE INDEX IF NOT EXISTS idx_membres_jalons_membre ON public.membres_jalons(membre_id);
CREATE INDEX IF NOT EXISTS idx_membres_jalons_jalon ON public.membres_jalons(jalon_id);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: visites_pastorales                                                   │
-- │ Description: Suivi des visites pastorales effectuées par les bergers         │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE TABLE IF NOT EXISTS public.visites_pastorales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membre_id UUID NOT NULL REFERENCES public.membres(id) ON DELETE CASCADE,
    berger_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    date_visite TIMESTAMPTZ NOT NULL,
    adresse VARCHAR(500),
    motif VARCHAR(255) NOT NULL,
    notes TEXT,
    statut VARCHAR(20) DEFAULT 'planifiee' CHECK (statut IN ('planifiee', 'effectuee', 'annulee')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_visites_membre ON public.visites_pastorales(membre_id);
CREATE INDEX IF NOT EXISTS idx_visites_berger ON public.visites_pastorales(berger_id);
CREATE INDEX IF NOT EXISTS idx_visites_date ON public.visites_pastorales(date_visite);
CREATE INDEX IF NOT EXISTS idx_visites_statut ON public.visites_pastorales(statut);

CREATE TRIGGER update_visites_updated_at
    BEFORE UPDATE ON public.visites_pastorales
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FONCTION: get_membres_a_visiter                                             │
-- │ Description: Retourne les membres n'ayant pas été visités depuis X jours     │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE OR REPLACE FUNCTION public.get_membres_a_visiter(date_limite TIMESTAMPTZ)
RETURNS TABLE (
    id UUID,
    nom TEXT,
    derniere_visite TIMESTAMPTZ,
    raison TEXT,
    priorite TEXT,
    telephone VARCHAR,
    adresse VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id,
        (m.prenom || ' ' || m.nom)::TEXT as nom,
        MAX(v.date_visite) as derniere_visite,
        CASE 
            WHEN MAX(v.date_visite) IS NULL THEN 'Jamais visité'
            ELSE 'Dernière visite il y a ' || EXTRACT(DAY FROM NOW() - MAX(v.date_visite)) || ' jours'
        END::TEXT as raison,
        CASE 
            WHEN MAX(v.date_visite) IS NULL THEN 'haute'
            WHEN MAX(v.date_visite) < NOW() - INTERVAL '120 days' THEN 'haute'
            WHEN MAX(v.date_visite) < NOW() - INTERVAL '90 days' THEN 'moyenne'
            ELSE 'basse'
        END::TEXT as priorite,
        m.telephone,
        m.adresse
    FROM public.membres m
    LEFT JOIN public.visites_pastorales v 
        ON m.id = v.membre_id 
        AND v.statut = 'effectuee'
    WHERE m.statut = 'actif'
    GROUP BY m.id, m.prenom, m.nom, m.telephone, m.adresse
    HAVING MAX(v.date_visite) IS NULL OR MAX(v.date_visite) < date_limite
    ORDER BY 
        CASE 
            WHEN MAX(v.date_visite) IS NULL THEN 1
            WHEN MAX(v.date_visite) < NOW() - INTERVAL '120 days' THEN 2
            WHEN MAX(v.date_visite) < NOW() - INTERVAL '90 days' THEN 3
            ELSE 4
        END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ROW LEVEL SECURITY (RLS) POLICIES                                           │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Activer RLS sur toutes les tables
ALTER TABLE public.jalons_spirituels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.membres_jalons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.visites_pastorales ENABLE ROW LEVEL SECURITY;

-- Politiques pour jalons_spirituels (lecture publique, écriture admin)
CREATE POLICY "Jalons visibles par tous les utilisateurs authentifiés"
    ON public.jalons_spirituels
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Jalons modifiables par les admins"
    ON public.jalons_spirituels
    FOR ALL
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur')
        )
    );

-- Politiques pour membres_jalons
CREATE POLICY "MembresJalons visibles par utilisateurs authentifiés"
    ON public.membres_jalons
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "MembresJalons créables par bergers"
    ON public.membres_jalons
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
        )
    );

-- Politiques pour visites_pastorales
CREATE POLICY "Visites visibles par utilisateurs authentifiés"
    ON public.visites_pastorales
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Visites créables par bergers"
    ON public.visites_pastorales
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur', 'berger')
        )
    );

CREATE POLICY "Visites modifiables par le berger assigné ou admin"
    ON public.visites_pastorales
    FOR UPDATE
    TO authenticated
    USING (
        berger_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur')
        )
    );

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ DONNÉES INITIALES (Seed)                                                    │
-- └─────────────────────────────────────────────────────────────────────────────┘

INSERT INTO public.jalons_spirituels (titre, description, icon_name, color_hex, "order")
VALUES 
    ('Baptême d''Eau', 'Baptême par immersion dans l''eau', 'water', '#2196F3', 1),
    ('Baptême du Saint-Esprit', 'Recevoir le Saint-Esprit avec les signes qui suivent', 'local_fire_department', '#FF9800', 2),
    ('Consécration', 'Dédication totale à Dieu et à son service', 'church', '#9C27B0', 3),
    ('Mariage Chrétien', 'Union sanctifiée devant Dieu', 'favorite', '#E91E63', 4),
    ('Service Actif', 'Engagement dans un ministère ou service', 'handshake', '#4CAF50', 5)
ON CONFLICT DO NOTHING;
