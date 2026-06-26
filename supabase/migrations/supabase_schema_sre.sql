-- ═══════════════════════════════════════════════════════════════════════════════
-- RECONSTRUCTION BLINDÉE - SCHEMA SUPABASE SRE
-- Tables: jalons_spirituels, visites_pastorales, membres_jalons
-- Contraintes: NOT NULL strictes, CHECK constraints, INDEX optimisés
-- ═══════════════════════════════════════════════════════════════════════════════
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FONCTION UTILITAIRE: Gestion des timestamps automatiques                    │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SECU: Roles & Permissions (Dépendances RLS)                                 │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE IF NOT EXISTS public.roles (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role_id TEXT NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, role_id)
);
-- Seed basic roles if they don't exist
-- Seed basic roles if they don't exist
INSERT INTO public.roles (name, description)
SELECT v.name,
    v.description
FROM (
        VALUES ('admin', 'Administrateur complet'),
            ('pasteur', 'Accès pastoral'),
            ('berger', 'Accès berger')
    ) AS v(name, description)
WHERE NOT EXISTS (
        SELECT 1
        FROM public.roles r
        WHERE r.name = v.name
    );
-- Enable RLS
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
-- Policies for roles/user_roles (Basic read access for auth users to check their own roles)
CREATE POLICY "Allow read roles" ON public.roles FOR
SELECT TO authenticated USING (true);
CREATE POLICY "Allow read user_roles" ON public.user_roles FOR
SELECT TO authenticated USING (user_id = auth.uid());
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: jalons_spirituels                                                    │
-- │ Description: Définit les étapes spirituelles avec contraintes strictes       │
-- └─────────────────────────────────────────────────────────────────────────────┘
DROP TABLE IF EXISTS public.membres_jalons CASCADE;
DROP TABLE IF EXISTS public.jalons_spirituels CASCADE;
CREATE TABLE public.jalons_spirituels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre VARCHAR(255) NOT NULL CHECK (char_length(titre) > 0),
    description TEXT NOT NULL DEFAULT '',
    icon_name VARCHAR(50) NOT NULL DEFAULT 'flag' CHECK (icon_name ~ '^[a-z_]+$'),
    color_hex VARCHAR(7) NOT NULL DEFAULT '#1976D2' CHECK (color_hex ~ '^#[0-9A-Fa-f]{6}$'),
    "order" INTEGER NOT NULL DEFAULT 0 CHECK ("order" >= 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Contrainte unique sur le titre pour éviter les doublons
    CONSTRAINT unique_titre UNIQUE (titre)
);
-- Index optimisés pour les requêtes fréquentes
CREATE INDEX idx_jalons_active_order ON public.jalons_spirituels(is_active, "order");
CREATE INDEX idx_jalons_color ON public.jalons_spirituels(color_hex)
WHERE is_active = true;
-- Trigger pour updated_at
CREATE TRIGGER trg_jalons_updated_at BEFORE
UPDATE ON public.jalons_spirituels FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: membres_jalons                                                       │
-- │ Description: Association membre-jalon avec validation stricte                │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE public.membres_jalons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membre_id TEXT NOT NULL,
    jalon_id UUID NOT NULL,
    date_realisation DATE NOT NULL CHECK (date_realisation <= CURRENT_DATE),
    lieu VARCHAR(255) DEFAULT '',
    temoin VARCHAR(255) DEFAULT '',
    notes TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Contrainte unique: un membre ne peut avoir qu'une fois le même jalon
    CONSTRAINT unique_membre_jalon UNIQUE (membre_id, jalon_id),
    -- Clés étrangères avec suppression en cascade
    CONSTRAINT fk_membre FOREIGN KEY (membre_id) REFERENCES public.membres(id) ON DELETE CASCADE,
    CONSTRAINT fk_jalon FOREIGN KEY (jalon_id) REFERENCES public.jalons_spirituels(id) ON DELETE CASCADE
);
-- Index pour les jointures fréquentes
CREATE INDEX idx_membres_jalons_membre ON public.membres_jalons(membre_id);
CREATE INDEX idx_membres_jalons_jalon ON public.membres_jalons(jalon_id);
CREATE INDEX idx_membres_jalons_date ON public.membres_jalons(date_realisation DESC);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: visites_pastorales                                                   │
-- │ Description: Suivi des visites avec statut contraint et validation           │
-- └─────────────────────────────────────────────────────────────────────────────┘
DROP TABLE IF EXISTS public.visites_pastorales CASCADE;
CREATE TABLE public.visites_pastorales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    membre_id TEXT NOT NULL,
    berger_id UUID NOT NULL,
    date_visite TIMESTAMPTZ NOT NULL,
    adresse VARCHAR(500) NOT NULL DEFAULT '',
    motif VARCHAR(255) NOT NULL CHECK (char_length(motif) > 0),
    notes TEXT NOT NULL DEFAULT '',
    statut VARCHAR(20) NOT NULL DEFAULT 'planifiee' CHECK (statut IN ('planifiee', 'effectuee', 'annulee')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Contrainte: date_visite ne peut pas être dans le passé pour une nouvelle visite planifiée
    CONSTRAINT chk_date_visite CHECK (date_visite >= CURRENT_DATE - INTERVAL '1 day'),
    -- Clés étrangères
    CONSTRAINT fk_visite_membre FOREIGN KEY (membre_id) REFERENCES public.membres(id) ON DELETE CASCADE,
    CONSTRAINT fk_visite_berger FOREIGN KEY (berger_id) REFERENCES auth.users(id) ON DELETE CASCADE
);
-- Index composites pour les requêtes de filtrage courantes
CREATE INDEX idx_visites_berger_statut ON public.visites_pastorales(berger_id, statut, date_visite DESC);
CREATE INDEX idx_visites_membre_date ON public.visites_pastorales(membre_id, date_visite DESC);
CREATE INDEX idx_visites_statut_date ON public.visites_pastorales(statut, date_visite)
WHERE statut = 'planifiee';
CREATE INDEX idx_visites_date_range ON public.visites_pastorales(date_visite);
-- Trigger pour updated_at
CREATE TRIGGER trg_visites_updated_at BEFORE
UPDATE ON public.visites_pastorales FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FONCTION: get_membres_a_visiter (Optimisée et sécurisée)                    │
-- │ Description: Algorithme de priorisation avec gestion des cas limites         │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE OR REPLACE FUNCTION public.get_membres_a_visiter(
        p_date_limite TIMESTAMPTZ DEFAULT (NOW() - INTERVAL '60 days')
    ) RETURNS TABLE (
        id TEXT,
        nom TEXT,
        prenom TEXT,
        derniere_visite TIMESTAMPTZ,
        raison TEXT,
        priorite VARCHAR(10),
        telephone VARCHAR,
        adresse VARCHAR,
        jours_ecoules INTEGER
    ) LANGUAGE plpgsql SECURITY DEFINER STABLE AS $$ BEGIN -- Validation du paramètre
    IF p_date_limite IS NULL THEN p_date_limite := NOW() - INTERVAL '60 days';
END IF;
RETURN QUERY WITH dernieres_visites AS (
    SELECT v.membre_id,
        MAX(v.date_visite) as last_visite_date
    FROM public.visites_pastorales v
    WHERE v.statut = 'effectuee'
    GROUP BY v.membre_id
)
SELECT m.id::TEXT,
    m.nom::TEXT,
    m.prenom::TEXT,
    dv.last_visite_date as derniere_visite,
    CASE
        WHEN dv.last_visite_date IS NULL THEN 'Jamais visité'
        ELSE 'Dernière visite il y a ' || EXTRACT(
            DAY
            FROM NOW() - dv.last_visite_date
        )::TEXT || ' jours'
    END::TEXT as raison,
    CASE
        WHEN dv.last_visite_date IS NULL THEN 'haute'
        WHEN dv.last_visite_date < NOW() - INTERVAL '120 days' THEN 'haute'
        WHEN dv.last_visite_date < NOW() - INTERVAL '90 days' THEN 'moyenne'
        ELSE 'basse'
    END::VARCHAR(10) as priorite,
    COALESCE(m.telephone, '')::VARCHAR as telephone,
    COALESCE(m.adresse, '')::VARCHAR as adresse,
    CASE
        WHEN dv.last_visite_date IS NULL THEN 9999
        ELSE EXTRACT(
            DAY
            FROM NOW() - dv.last_visite_date
        )::INTEGER
    END as jours_ecoules
FROM public.membres m
    LEFT JOIN dernieres_visites dv ON m.id::TEXT = dv.membre_id
WHERE m.statut::TEXT = 'actif'
    AND m.deleted_at IS NULL
    AND (
        dv.last_visite_date IS NULL
        OR dv.last_visite_date < p_date_limite
    )
ORDER BY CASE
        WHEN dv.last_visite_date IS NULL THEN 1
        WHEN dv.last_visite_date < NOW() - INTERVAL '120 days' THEN 2
        WHEN dv.last_visite_date < NOW() - INTERVAL '90 days' THEN 3
        ELSE 4
    END,
    m.nom,
    m.prenom;
END;
$$;
-- Commentaire sur la fonction pour documentation
COMMENT ON FUNCTION public.get_membres_a_visiter IS 'Retourne les membres prioritaires pour une visite pastorale.
Paramètres:
  - p_date_limite: Date limite pour considérer une visite comme obsolète (défaut: 60 jours)
Retourne:
  - Liste des membres avec priorité (haute/moyenne/basse) et jours écoulés';
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ROW LEVEL SECURITY (RLS) - Politiques strictes                              │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Activer RLS sur toutes les tables
ALTER TABLE public.jalons_spirituels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.membres_jalons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.visites_pastorales ENABLE ROW LEVEL SECURITY;
-- Supprimer les anciennes politiques si elles existent
DROP POLICY IF EXISTS "jalons_select_all" ON public.jalons_spirituels;
DROP POLICY IF EXISTS "jalons_admin_all" ON public.jalons_spirituels;
DROP POLICY IF EXISTS "membres_jalons_select_all" ON public.membres_jalons;
DROP POLICY IF EXISTS "membres_jalons_insert_berger" ON public.membres_jalons;
DROP POLICY IF EXISTS "visites_select_all" ON public.visites_pastorales;
DROP POLICY IF EXISTS "visites_insert_berger" ON public.visites_pastorales;
DROP POLICY IF EXISTS "visites_update_owner" ON public.visites_pastorales;
-- Politiques pour jalons_spirituels
CREATE POLICY "jalons_select_all" ON public.jalons_spirituels FOR
SELECT TO authenticated USING (is_active = true);
CREATE POLICY "jalons_admin_all" ON public.jalons_spirituels FOR ALL TO authenticated USING (
    EXISTS (
        SELECT 1
        FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.name IN ('admin', 'pasteur')
            AND ur.is_active = true
    )
);
-- Politiques pour membres_jalons
CREATE POLICY "membres_jalons_select_all" ON public.membres_jalons FOR
SELECT TO authenticated USING (true);
CREATE POLICY "membres_jalons_insert_berger" ON public.membres_jalons FOR
INSERT TO authenticated WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.name IN ('admin', 'pasteur', 'berger')
                AND ur.is_active = true
        )
    );
CREATE POLICY "membres_jalons_update_berger" ON public.membres_jalons FOR
UPDATE TO authenticated USING (
        EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.name IN ('admin', 'pasteur', 'berger')
                AND ur.is_active = true
        )
    );
-- Politiques pour visites_pastorales
CREATE POLICY "visites_select_all" ON public.visites_pastorales FOR
SELECT TO authenticated USING (true);
CREATE POLICY "visites_insert_berger" ON public.visites_pastorales FOR
INSERT TO authenticated WITH CHECK (
        berger_id = auth.uid()
        OR EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.nom IN ('admin', 'pasteur')
                AND ur.is_active = true
        )
    );
CREATE POLICY "visites_update_owner" ON public.visites_pastorales FOR
UPDATE TO authenticated USING (
        berger_id = auth.uid()
        OR EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.nom IN ('admin', 'pasteur')
                AND ur.is_active = true
        )
    );
CREATE POLICY "visites_delete_owner" ON public.visites_pastorales FOR DELETE TO authenticated USING (
    berger_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.user_roles ur
            JOIN public.roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
            AND r.nom IN ('admin', 'pasteur')
            AND ur.is_active = true
    )
);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ DONNÉES INITIALES (Seed) - Jalons spirituels standards                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
INSERT INTO public.jalons_spirituels (
        titre,
        description,
        icon_name,
        color_hex,
        "order"
    )
VALUES (
        'Baptême d''Eau',
        'Baptême par immersion dans l''eau. Acte d''obéissance et de foi.',
        'water_drop',
        '#2196F3',
        1
    ),
    (
        'Baptême du Saint-Esprit',
        'Recevoir la puissance du Saint-Esprit avec les signes qui suivent.',
        'local_fire_department',
        '#FF9800',
        2
    ),
    (
        'Consécration',
        'Dédication totale de sa vie à Dieu et à son service.',
        'church',
        '#9C27B0',
        3
    ),
    (
        'Mariage Chrétien',
        'Union sanctifiée entre deux croyants devant Dieu et l''Église.',
        'favorite',
        '#E91E63',
        4
    ),
    (
        'Service Actif',
        'Engagement régulier dans un ministère ou un service à l''Église.',
        'handshake',
        '#4CAF50',
        5
    ) ON CONFLICT (titre) DO
UPDATE
SET description = EXCLUDED.description,
    icon_name = EXCLUDED.icon_name,
    color_hex = EXCLUDED.color_hex,
    "order" = EXCLUDED."order",
    is_active = true,
    updated_at = NOW();
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ VUES POUR STATISTIQUES (Performance)                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE OR REPLACE VIEW public.stats_jalons AS
SELECT j.id,
    j.titre,
    j.color_hex,
    COUNT(mj.membre_id) as nombre_membres,
    MAX(mj.date_realisation) as derniere_realisation
FROM public.jalons_spirituels j
    LEFT JOIN public.membres_jalons mj ON j.id = mj.jalon_id
WHERE j.is_active = true
GROUP BY j.id,
    j.titre,
    j.color_hex
ORDER BY j."order";
CREATE OR REPLACE VIEW public.stats_visites AS
SELECT statut,
    COUNT(*) as total,
    COUNT(*) FILTER (
        WHERE date_visite >= CURRENT_DATE
    ) as a_venir,
    COUNT(*) FILTER (
        WHERE date_visite < CURRENT_DATE
            AND statut = 'planifiee'
    ) as en_retard
FROM public.visites_pastorales
WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY statut;
-- Commentaires sur les tables
COMMENT ON TABLE public.jalons_spirituels IS 'Définition des étapes spirituelles (jalons) possibles pour les membres';
COMMENT ON TABLE public.membres_jalons IS 'Association entre membres et jalons réalisés';
COMMENT ON TABLE public.visites_pastorales IS 'Suivi des visites pastorales effectuées par les bergers';
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: member_photos                                                        │
-- │ Description: Stockage des métadonnées des photos (Cloudflare R2 + Supabase)   │
-- └─────────────────────────────────────────────────────────────────────────────┘
DROP TABLE IF EXISTS public.member_photo_logs CASCADE;
DROP TABLE IF EXISTS public.member_photos CASCADE;
CREATE TABLE public.member_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id TEXT NOT NULL,
    file_id TEXT NOT NULL,
    -- Cloudflare R2 object key
    file_url TEXT NOT NULL,
    -- Cloudflare R2 public URL
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT true,
    checksum VARCHAR(64) NOT NULL,
    -- SHA-256 checksum
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Clé étrangère vers membres
    CONSTRAINT fk_photo_membre FOREIGN KEY (member_id) REFERENCES public.membres(id) ON DELETE CASCADE,
    -- Contrainte: un seul fichier_id unique (pas de doublons R2)
    CONSTRAINT unique_file_id UNIQUE (file_id)
);
-- Index optimisés pour les requêtes fréquentes
CREATE INDEX idx_member_photos_member_id ON public.member_photos(member_id);
CREATE INDEX idx_member_photos_active ON public.member_photos(member_id, is_active)
WHERE is_active = true;
CREATE INDEX idx_member_photos_uploaded_at ON public.member_photos(uploaded_at DESC);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TABLE: member_photo_logs                                                    │
-- │ Description: Audit trail des actions sur les photos (trigger logs)           │
-- └─────────────────────────────────────────────────────────────────────────────┘
CREATE TABLE public.member_photo_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id TEXT NOT NULL,
    file_id TEXT NOT NULL,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    action VARCHAR(20) NOT NULL CHECK (
        action IN ('insert', 'activate', 'deactivate', 'error')
    ),
    triggered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    triggered_by TEXT DEFAULT 'system_trigger',
    -- Clé étrangère vers membres
    CONSTRAINT fk_log_membre FOREIGN KEY (member_id) REFERENCES public.membres(id) ON DELETE CASCADE
);
-- Index pour les requêtes par membre et date
CREATE INDEX idx_member_photo_logs_member_id ON public.member_photo_logs(member_id);
CREATE INDEX idx_member_photo_logs_triggered_at ON public.member_photo_logs(triggered_at DESC);
CREATE INDEX idx_member_photo_logs_action ON public.member_photo_logs(action);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ TRIGGERS: Gestion automatique des photos actives                            │
-- │ Description: Un seule photo active par membre, logs automatiques             │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Fonction trigger pour INSERT
CREATE OR REPLACE FUNCTION handle_member_photo_insert() RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public AS $$
DECLARE deactivated_count INTEGER;
BEGIN -- Validation de base
IF NEW.member_id IS NULL
OR NEW.file_id IS NULL
OR NEW.uploaded_at IS NULL THEN RAISE EXCEPTION 'member_id, file_id, and uploaded_at are required';
END IF;
-- Si la photo insérée est active, désactiver les autres photos du même membre
IF NEW.is_active = TRUE THEN
UPDATE member_photos
SET is_active = FALSE
WHERE member_id = NEW.member_id
    AND id != NEW.id
    AND is_active = TRUE;
GET DIAGNOSTICS deactivated_count = ROW_COUNT;
-- Log des photos désactivées
IF deactivated_count > 0 THEN
INSERT INTO member_photo_logs (
        member_id,
        file_id,
        uploaded_at,
        action,
        triggered_by
    )
VALUES (
        NEW.member_id,
        NEW.file_id,
        NOW(),
        'deactivate',
        'system_trigger'
    );
END IF;
END IF;
-- Log de la nouvelle photo
INSERT INTO member_photo_logs (
        member_id,
        file_id,
        uploaded_at,
        action,
        triggered_by
    )
VALUES (
        NEW.member_id,
        NEW.file_id,
        NOW(),
        CASE
            WHEN NEW.is_active = TRUE THEN 'activate'
            ELSE 'insert'
        END,
        'system_trigger'
    );
RETURN NEW;
EXCEPTION
WHEN OTHERS THEN -- Log de l'erreur
INSERT INTO member_photo_logs (
        member_id,
        file_id,
        uploaded_at,
        action,
        triggered_by
    )
VALUES (
        NEW.member_id,
        COALESCE(NEW.file_id, 'unknown'),
        NOW(),
        'error',
        'system_trigger'
    );
RAISE;
END;
$$;
-- Fonction trigger pour UPDATE
CREATE OR REPLACE FUNCTION handle_member_photo_update() RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public AS $$ BEGIN -- Si is_active passe de FALSE à TRUE, désactiver les autres
    IF OLD.is_active = FALSE
    AND NEW.is_active = TRUE THEN
UPDATE member_photos
SET is_active = FALSE
WHERE member_id = NEW.member_id
    AND id != NEW.id
    AND is_active = TRUE;
-- Log de l'activation
INSERT INTO member_photo_logs (
        member_id,
        file_id,
        uploaded_at,
        action,
        triggered_by
    )
VALUES (
        NEW.member_id,
        NEW.file_id,
        NOW(),
        'activate',
        'system_trigger'
    );
END IF;
-- Si is_active passe de TRUE à FALSE, vérifier qu'il reste au moins une photo active
IF OLD.is_active = TRUE
AND NEW.is_active = FALSE THEN
DECLARE active_count INTEGER;
BEGIN
SELECT COUNT(*) INTO active_count
FROM member_photos
WHERE member_id = NEW.member_id
    AND is_active = TRUE
    AND id != NEW.id;
-- S'il n'y a plus de photo active, réactiver la dernière photo
IF active_count = 0 THEN
UPDATE member_photos
SET is_active = TRUE
WHERE member_photos.id = (
        SELECT id
        FROM member_photos
        WHERE member_id = NEW.member_id
        ORDER BY uploaded_at DESC
        LIMIT 1
    );
END IF;
END;
END IF;
RETURN NEW;
EXCEPTION
WHEN OTHERS THEN
INSERT INTO member_photo_logs (
        member_id,
        file_id,
        uploaded_at,
        action,
        triggered_by
    )
VALUES (
        NEW.member_id,
        NEW.file_id,
        NOW(),
        'error',
        'system_trigger'
    );
RAISE;
END;
$$;
-- Créer les triggers
DROP TRIGGER IF EXISTS member_photo_insert_trigger ON member_photos;
CREATE TRIGGER member_photo_insert_trigger
AFTER
INSERT ON member_photos FOR EACH ROW EXECUTE FUNCTION handle_member_photo_insert();
DROP TRIGGER IF EXISTS member_photo_update_trigger ON member_photos;
CREATE TRIGGER member_photo_update_trigger
AFTER
UPDATE OF is_active ON member_photos FOR EACH ROW
    WHEN (
        OLD.is_active IS DISTINCT
        FROM NEW.is_active
    ) EXECUTE FUNCTION handle_member_photo_update();
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ RLS: Row Level Security pour photos                                         │
-- └─────────────────────────────────────────────────────────────────────────────┘
ALTER TABLE public.member_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.member_photo_logs ENABLE ROW LEVEL SECURITY;
-- Politiques pour member_photos
CREATE POLICY "member_photos_select_all" ON public.member_photos FOR
SELECT TO authenticated USING (true);
CREATE POLICY "member_photos_insert_admin" ON public.member_photos FOR
INSERT TO authenticated WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.name IN ('admin', 'pasteur', 'berger')
                AND ur.is_active = true
        )
    );
CREATE POLICY "member_photos_update_admin" ON public.member_photos FOR
UPDATE TO authenticated USING (
        EXISTS (
            SELECT 1
            FROM public.user_roles ur
                JOIN public.roles r ON ur.role_id = r.id
            WHERE ur.user_id = auth.uid()
                AND r.name IN ('admin', 'pasteur', 'berger')
                AND ur.is_active = true
        )
    );
-- Politiques pour member_photo_logs (lecture seule pour audit)
CREATE POLICY "member_photo_logs_select_all" ON public.member_photo_logs FOR
SELECT TO authenticated USING (true);
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FONCTIONS UTILITAIRES pour photos                                           │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- FONCTIONS UTILITAIRES pour photos
DROP FUNCTION IF EXISTS get_trigger_status();
-- Fonction pour vérifier l'état des triggers
CREATE OR REPLACE FUNCTION get_trigger_status() RETURNS TABLE (
        trigger_name TEXT,
        table_name TEXT,
        function_name TEXT,
        is_enabled BOOLEAN
    ) AS $$ BEGIN RETURN QUERY
SELECT tg.tgname::TEXT as trigger_name,
    relname::TEXT as table_name,
    proname::TEXT as function_name,
    tg.tgenabled = 'O' as is_enabled
FROM pg_trigger tg
    JOIN pg_class cls ON tg.tgrelid = cls.oid
    JOIN pg_proc proc ON tg.tgfoid = proc.oid
WHERE tg.tgname IN (
        'member_photo_insert_trigger',
        'member_photo_update_trigger'
    )
ORDER BY tg.tgname;
END;
$$ LANGUAGE plpgsql;
-- Vue pour monitoring des actions trigger
DROP VIEW IF EXISTS member_photo_activity;
CREATE OR REPLACE VIEW member_photo_activity AS
SELECT mpl.member_id::TEXT,
    mpl.file_id,
    mpl.action,
    mpl.triggered_at,
    mp.uploaded_at as photo_uploaded_at,
    mp.is_active,
    CASE
        WHEN mpl.action = 'activate' THEN 'Photo activée'
        WHEN mpl.action = 'deactivate' THEN 'Photo désactivée'
        WHEN mpl.action = 'insert' THEN 'Nouvelle photo'
        WHEN mpl.action = 'error' THEN 'Erreur trigger'
        ELSE mpl.action
    END as action_description
FROM member_photo_logs mpl
    LEFT JOIN member_photos mp ON mpl.file_id = mp.file_id
ORDER BY mpl.triggered_at DESC;
-- Commentaires
COMMENT ON TABLE public.member_photos IS 'Métadonnées des photos des membres stockées sur Cloudflare R2';
COMMENT ON TABLE public.member_photo_logs IS 'Audit trail des actions trigger sur les photos de membres';
COMMENT ON FUNCTION handle_member_photo_insert() IS 'Trigger: désactive les anciennes photos et active la nouvelle';
COMMENT ON FUNCTION handle_member_photo_update() IS 'Trigger: maintient la cohérence des états actifs';