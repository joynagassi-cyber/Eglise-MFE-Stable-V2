from __future__ import annotations

import re
from pathlib import Path


PAGE_WIDTH = 595.0
PAGE_HEIGHT = 842.0
LEFT = 44.0
RIGHT = 44.0
TOP = 48.0
BOTTOM = 42.0
CONTENT_WIDTH = PAGE_WIDTH - LEFT - RIGHT


def escape_pdf_text(text: str) -> str:
    return (
        text.replace("\\", "\\\\")
        .replace("(", "\\(")
        .replace(")", "\\)")
        .replace("\r", "")
        .replace("\n", "\\n")
    )


def text_width(text: str, font_size: float) -> float:
    avg_factor = 0.52
    narrow_chars = set(" .,:;|!iIl1'`")
    wide_chars = set("MW@#%&QGO")
    width = 0.0
    for ch in text:
        factor = avg_factor
        if ch in narrow_chars:
            factor = 0.28
        elif ch in wide_chars:
            factor = 0.78
        elif ch.isupper():
            factor = 0.6
        width += font_size * factor
    return width


def wrap_text(text: str, font_size: float, max_width: float) -> list[str]:
    words = text.split()
    if not words:
        return [""]
    lines: list[str] = []
    current = words[0]
    for word in words[1:]:
        candidate = f"{current} {word}"
        if text_width(candidate, font_size) <= max_width:
            current = candidate
        else:
            lines.append(current)
            current = word
    lines.append(current)
    return lines


class PDFBuilder:
    def __init__(self) -> None:
        self.commands: list[str] = []
        self.current_y = PAGE_HEIGHT - TOP

    def move_down(self, amount: float) -> None:
        self.current_y -= amount

    def draw_line(self, x1: float, y1: float, x2: float, y2: float, width: float = 1.0) -> None:
        self.commands.append(f"{width:.2f} w {x1:.2f} {y1:.2f} m {x2:.2f} {y2:.2f} l S")

    def draw_text(self, x: float, y: float, text: str, font: str = "F1", size: float = 10.0) -> None:
        safe = escape_pdf_text(text)
        self.commands.append(f"BT /{font} {size:.2f} Tf {x:.2f} {y:.2f} Td ({safe}) Tj ET")

    def paragraph(
        self,
        text: str,
        font: str = "F1",
        size: float = 10.0,
        leading: float = 13.0,
        x: float = LEFT,
        max_width: float = CONTENT_WIDTH,
        gap_after: float = 4.0,
    ) -> None:
        for line in wrap_text(text, size, max_width):
            self.draw_text(x, self.current_y, line, font=font, size=size)
            self.move_down(leading)
        self.move_down(gap_after)

    def bullet(
        self,
        text: str,
        size: float = 9.6,
        leading: float = 11.8,
        x: float = LEFT + 10.0,
        bullet_x: float = LEFT,
    ) -> None:
        lines = wrap_text(text, size, CONTENT_WIDTH - 12.0)
        self.draw_text(bullet_x, self.current_y, "-", font="F1", size=size)
        self.draw_text(x, self.current_y, lines[0], font="F1", size=size)
        self.move_down(leading)
        for line in lines[1:]:
            self.draw_text(x, self.current_y, line, font="F1", size=size)
            self.move_down(leading)
        self.move_down(1.5)

    def heading(self, text: str) -> None:
        self.draw_text(LEFT, self.current_y, text, font="F2", size=11.3)
        self.move_down(14.0)

    def small(self, text: str) -> None:
        self.paragraph(text, font="F1", size=8.7, leading=10.4, gap_after=0.0)

    def title(self, text: str, subtitle: str) -> None:
        self.draw_text(LEFT, self.current_y, text, font="F2", size=18.0)
        self.move_down(20.0)
        self.draw_text(LEFT, self.current_y, subtitle, font="F1", size=9.2)
        self.move_down(8.0)
        self.draw_line(LEFT, self.current_y, PAGE_WIDTH - RIGHT, self.current_y, width=0.9)
        self.move_down(16.0)

    def build(self) -> bytes:
        content = "\n".join(self.commands).encode("cp1252", errors="replace")

        objects: list[bytes] = []

        def add(obj: str | bytes) -> None:
            if isinstance(obj, str):
                obj = obj.encode("latin-1")
            objects.append(obj)

        add("<< /Type /Catalog /Pages 2 0 R >>")
        add("<< /Type /Pages /Count 1 /Kids [3 0 R] >>")
        add(
            f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {PAGE_WIDTH:.0f} {PAGE_HEIGHT:.0f}] "
            "/Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> /Contents 4 0 R >>"
        )
        add(b"<< /Length " + str(len(content)).encode("ascii") + b" >>\nstream\n" + content + b"\nendstream")
        add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>")
        add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>")

        out = bytearray(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
        offsets = [0]
        for idx, obj in enumerate(objects, start=1):
            offsets.append(len(out))
            out.extend(f"{idx} 0 obj\n".encode("ascii"))
            out.extend(obj)
            out.extend(b"\nendobj\n")

        xref_pos = len(out)
        out.extend(f"xref\n0 {len(objects) + 1}\n".encode("ascii"))
        out.extend(b"0000000000 65535 f \n")
        for off in offsets[1:]:
            out.extend(f"{off:010d} 00000 n \n".encode("ascii"))
        out.extend(
            (
                f"trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\n"
                f"startxref\n{xref_pos}\n%%EOF\n"
            ).encode("ascii")
        )
        return bytes(out)


def main() -> None:
    repo = Path(__file__).resolve().parents[1]
    out_dir = repo / "output" / "pdf"
    tmp_dir = repo / "tmp" / "pdfs"
    out_dir.mkdir(parents=True, exist_ok=True)
    tmp_dir.mkdir(parents=True, exist_ok=True)

    pdf = PDFBuilder()
    pdf.title(
        "Résumé de l’application",
        "Lumina / Lumina - synthèse repo au 27 mars 2026",
    )

    pdf.heading("Ce que c’est")
    pdf.paragraph(
        "Application Flutter de gestion d’église reliée à Supabase, conçue pour centraliser les opérations communautaires, administratives et financières.",
        size=9.7,
        leading=11.9,
        gap_after=1.5,
    )
    pdf.paragraph(
        "Le dépôt montre une approche offline-first avec stockage local Isar, synchronisation différée et modules métier multiples.",
        size=9.7,
        leading=11.9,
        gap_after=7.0,
    )

    pdf.heading("Pour qui")
    pdf.paragraph(
        "Persona principal: responsables d’église et équipes d’administration (admins, superadmins, responsables de groupe, trésoriers), avec parcours séparés pour membres.",
        size=9.7,
        leading=11.9,
        gap_after=7.0,
    )

    pdf.heading("Ce que l’app fait")
    for item in [
        "Gère les membres, profils, recherche, statistiques et présence.",
        "Suit les finances: transactions, budgets, approbations, comptes et rapports.",
        "Planifie événements, célébrations et calendrier communautaire.",
        "Propose messagerie interne, annonces, notifications et fonctions sociales.",
        "Supporte plusieurs églises, rôles granulaires et administration RBAC.",
        "Fonctionne hors ligne via Isar avec file de synchro puis envoi vers Supabase.",
    ]:
        pdf.bullet(item)
    pdf.move_down(4.0)

    pdf.heading("Comment ça marche")
    for item in [
        "Client Flutter: `lib/main.dart` initialise Firebase, logger, `.env`, Supabase, Isar, Riverpod puis lance `MaterialApp.router` avec GoRouter.",
        "Navigation: routes publiques, onboarding et shell principal via `core/router/app_router.dart`.",
        "Modules métier: `lib/features/*` couvre auth, membres, finances, événements, groupes, messagerie, rapports, dons, Bible, notifications et admin.",
        "Local/offline: `core/data/local/isar_service.dart` stocke membres, transactions, rôles, messages, événements et file `syncItemModels`.",
        "Sync: `core/services/offline_sync_manager.dart` observe la connectivité, empile les mutations locales puis les pousse vers Supabase avec retry, backoff et DLQ.",
        "Backend: dossiers `supabase/migrations` et `supabase/functions/*` montrent un backend Supabase avec schéma SQL, RLS et Edge Functions d’auth, invitations, upload et scellement.",
    ]:
        pdf.bullet(item, size=8.9, leading=10.7)
    pdf.move_down(2.0)

    pdf.heading("Démarrage minimal")
    for item in [
        "Aller dans `feu_evangile_flutter/`, lancer `flutter pub get`, puis `flutter pub run build_runner build --delete-conflicting-outputs`.",
        "Créer `.env` manuellement avec `SUPABASE_URL` et `SUPABASE_ANON_KEY`; `.env.example` : Not found in repo.",
        "Lancer l’app avec `flutter run --dart-define-from-file=.env` ou `make run` depuis la racine.",
        "Si vous voulez le backend local complet: la doc mentionne `supabase db push`, mais la config locale `supabase/config.toml` : Not found in repo.",
    ]:
        pdf.bullet(item, size=8.9, leading=10.5)

    pdf.move_down(1.0)
    footer = "Sources repo: feu_evangile_flutter/README.md, docs/README.md, docs/developer/setup.md, lib/main.dart, core/router/app_router.dart, core/data/local/isar_service.dart, core/services/offline_sync_manager.dart, supabase/functions, supabase/migrations."
    pdf.small(footer)

    if pdf.current_y < BOTTOM:
        raise SystemExit(f"Content overflowed single page by {BOTTOM - pdf.current_y:.1f}pt")

    output_path = out_dir / "resume-app-lumina-une-page-fr.pdf"
    output_path.write_bytes(pdf.build())

    size = output_path.stat().st_size
    print(f"PDF generated: {output_path}")
    print(f"File size: {size} bytes")
    print(f"Remaining vertical space: {pdf.current_y - BOTTOM:.1f}pt")
    raw = output_path.read_bytes()
    pages = len(re.findall(rb"/Type /Page\b", raw))
    print(f"Page objects: {pages}")


if __name__ == "__main__":
    main()
