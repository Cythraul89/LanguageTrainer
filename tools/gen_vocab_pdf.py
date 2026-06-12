#!/usr/bin/env python3
"""Generate a vocabulary-reference PDF from the Dart data source files.

Usage:
    python tools/gen_vocab_pdf.py [output.pdf]

Requires:
    pip install fpdf2
"""

import re
import sys
from pathlib import Path

from fpdf import FPDF, XPos, YPos

# ── Paths ─────────────────────────────────────────────────────────────────────

ROOT = Path(__file__).parent.parent
NOUNS_FILE  = ROOT / "src/lib/data/nouns.dart"
VERBS_FILE  = ROOT / "src/lib/data/verbs.dart"
ADJ_FILE    = ROOT / "src/lib/data/adjectives.dart"
PREPS_FILE  = ROOT / "src/lib/data/prepositions.dart"
OUT_FILE   = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "vocabulary.pdf"

LEVELS = ["a1", "a2", "b1", "b2", "c1"]

# ── Parsers ───────────────────────────────────────────────────────────────────

def _str(m):
    return m.strip("'\"")

def parse_nouns(path):
    """Returns {level: [(article, word, plural, english), ...]}"""
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"NounEntry\s*\("
        r".*?word:\s*'([^']+)'"
        r".*?article:\s*Article\.(\w+)"
        r".*?plural:\s*'([^']+)'"
        r".*?english:\s*'([^']+)'"
        r".*?level:\s*CefrLevel\.(\w+)",
        re.DOTALL,
    )
    result = {lv: [] for lv in LEVELS}
    for m in pattern.finditer(text):
        word, article, plural, english, level = m.group(1,2,3,4,5)
        if level in result:
            result[level].append((article, word, plural, english))
    return result

def parse_verbs(path):
    """Returns {level: [(infinitive, english, auxiliary, partizip2), ...]}"""
    text = path.read_text(encoding="utf-8")
    # Each VerbEntry spans multiple lines; split on VerbEntry( blocks
    blocks = re.split(r"VerbEntry\s*\(", text)[1:]
    result = {lv: [] for lv in LEVELS}
    for block in blocks:
        inf   = re.search(r"infinitive:\s*'([^']+)'", block)
        eng   = re.search(r"english:\s*'([^']+)'", block)
        aux   = re.search(r"auxiliary:\s*Auxiliary\.(\w+)", block)
        p2    = re.search(r"partizip2:\s*'([^']+)'", block)
        level = re.search(r"level:\s*CefrLevel\.(\w+)", block)
        if inf and eng and aux and p2 and level and level.group(1) in result:
            result[level.group(1)].append((
                inf.group(1), eng.group(1), aux.group(1), p2.group(1)
            ))
    return result

def parse_adjectives(path):
    """Returns {level: [(word, english, comparative, superlative), ...]}"""
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"AdjectiveEntry\s*\("
        r".*?word:\s*'([^']+)'"
        r".*?english:\s*'([^']+)'"
        r".*?comparative:\s*'([^']+)'"
        r".*?superlative:\s*'([^']+)'"
        r".*?level:\s*CefrLevel\.(\w+)",
        re.DOTALL,
    )
    result = {lv: [] for lv in LEVELS}
    for m in pattern.finditer(text):
        word, english, comp, sup, level = m.group(1,2,3,4,5)
        if level in result:
            result[level].append((word, english, comp, sup))
    return result

def parse_prepositions(path):
    """Returns {level: [(word, english, cases_display), ...]}"""
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"PrepositionEntry\s*\("
        r".*?word:\s*'([^']+)'"
        r".*?english:\s*'([^']+)'"
        r".*?cases:\s*\[([^\]]+)\]"
        r".*?level:\s*CefrLevel\.(\w+)",
        re.DOTALL,
    )
    result = {lv: [] for lv in LEVELS}
    for m in pattern.finditer(text):
        word, english, cases_raw, level = m.group(1, 2, 3, 4)
        if level not in result:
            continue
        cases = [c.strip().strip("'\"") for c in cases_raw.split(',') if c.strip()]
        result[level].append((word, english, ' / '.join(cases)))
    return result

# ── PDF helpers ───────────────────────────────────────────────────────────────

INDIGO   = (63, 81, 181)
DARK_ROW = (232, 234, 246)
WHITE    = (255, 255, 255)
HEADER_TXT = (255, 255, 255)
BODY_TXT = (30, 30, 30)

LEVEL_LABELS = {
    "a1": "A1", "a2": "A2", "b1": "B1", "b2": "B2", "c1": "C1",
}

class VocabPDF(FPDF):
    def header(self):
        self.set_font("Helvetica", "B", 9)
        self.set_text_color(*BODY_TXT)
        self.cell(0, 6, "LanguageTrainer - Vocabulary Reference", align="C",
                  new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.ln(1)

    def footer(self):
        self.set_y(-12)
        self.set_font("Helvetica", "", 8)
        self.set_text_color(130, 130, 130)
        self.cell(0, 6, f"Page {self.page_no()}", align="C")

    def section_title(self, text):
        self.set_font("Helvetica", "B", 13)
        self.set_fill_color(*INDIGO)
        self.set_text_color(*HEADER_TXT)
        self.cell(0, 8, text, fill=True, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.ln(2)
        self.set_text_color(*BODY_TXT)

    def table_header(self, cols):
        """cols: list of (label, width)"""
        self.set_font("Helvetica", "B", 8)
        self.set_fill_color(*INDIGO)
        self.set_text_color(*HEADER_TXT)
        for label, w in cols:
            self.cell(w, 6, label, border=0, fill=True, align="L")
        self.ln()
        self.set_text_color(*BODY_TXT)

    def table_row(self, cells, odd):
        self.set_font("Helvetica", "", 8)
        self.set_fill_color(*(DARK_ROW if odd else WHITE))
        for text, w in cells:
            self.cell(w, 5, text, border=0, fill=True, align="L")
        self.ln()

# ── Section renderers ─────────────────────────────────────────────────────────

def render_nouns(pdf, nouns_by_level):
    pdf.add_page()
    pdf.section_title("Nouns")
    cols = [("Art.", 12), ("Word", 38), ("Plural", 38), ("English", 102)]
    for lv in LEVELS:
        rows = nouns_by_level.get(lv, [])
        if not rows:
            continue
        pdf.set_font("Helvetica", "B", 9)
        pdf.set_text_color(*INDIGO)
        pdf.cell(0, 6, LEVEL_LABELS[lv], new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        pdf.set_text_color(*BODY_TXT)
        pdf.table_header(cols)
        for i, (article, word, plural, english) in enumerate(rows):
            plural_disp = "-" if plural == "-" else plural
            pdf.table_row([
                (article, 12), (word, 38), (plural_disp, 38), (english, 102),
            ], odd=(i % 2 == 0))
        pdf.ln(3)

def render_verbs(pdf, verbs_by_level):
    pdf.add_page()
    pdf.section_title("Verbs")
    cols = [("Infinitive", 36), ("English", 60), ("Aux", 14), ("Partizip II", 80)]
    for lv in LEVELS:
        rows = verbs_by_level.get(lv, [])
        if not rows:
            continue
        pdf.set_font("Helvetica", "B", 9)
        pdf.set_text_color(*INDIGO)
        pdf.cell(0, 6, LEVEL_LABELS[lv], new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        pdf.set_text_color(*BODY_TXT)
        pdf.table_header(cols)
        for i, (inf, english, aux, p2) in enumerate(rows):
            pdf.table_row([
                (inf, 36), (english, 60), (aux, 14), (p2, 80),
            ], odd=(i % 2 == 0))
        pdf.ln(3)

def render_adjectives(pdf, adj_by_level):
    pdf.add_page()
    pdf.section_title("Adjectives")
    cols = [("Word", 34), ("English", 50), ("Comparative", 40), ("Superlative", 66)]
    for lv in LEVELS:
        rows = adj_by_level.get(lv, [])
        if not rows:
            continue
        pdf.set_font("Helvetica", "B", 9)
        pdf.set_text_color(*INDIGO)
        pdf.cell(0, 6, LEVEL_LABELS[lv], new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        pdf.set_text_color(*BODY_TXT)
        pdf.table_header(cols)
        for i, (word, english, comp, sup) in enumerate(rows):
            pdf.table_row([
                (word, 34), (english, 50), (comp, 40), (sup, 66),
            ], odd=(i % 2 == 0))
        pdf.ln(3)

def render_prepositions(pdf, preps_by_level):
    pdf.add_page()
    pdf.section_title("Prepositions")
    cols = [("Preposition", 40), ("English", 80), ("Case(s)", 70)]
    for lv in LEVELS:
        rows = preps_by_level.get(lv, [])
        if not rows:
            continue
        pdf.set_font("Helvetica", "B", 9)
        pdf.set_text_color(*INDIGO)
        pdf.cell(0, 6, LEVEL_LABELS[lv], new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        pdf.set_text_color(*BODY_TXT)
        pdf.table_header(cols)
        for i, (word, english, cases) in enumerate(rows):
            pdf.table_row([
                (word, 40), (english, 80), (cases, 70),
            ], odd=(i % 2 == 0))
        pdf.ln(3)

# ── Title page ────────────────────────────────────────────────────────────────

def render_title(pdf, noun_count, verb_count, adj_count, prep_count):
    pdf.add_page()
    pdf.ln(40)
    pdf.set_font("Helvetica", "B", 28)
    pdf.set_text_color(*INDIGO)
    pdf.cell(0, 12, "LanguageTrainer", align="C",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.set_font("Helvetica", "", 16)
    pdf.set_text_color(*BODY_TXT)
    pdf.cell(0, 8, "Vocabulary Reference", align="C",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.ln(12)
    pdf.set_font("Helvetica", "", 11)
    pdf.set_text_color(80, 80, 80)
    for line in [
        f"{noun_count} nouns  -  {verb_count} verbs  -  {adj_count} adjectives  -  {prep_count} prepositions",
        "Levels: A1 - B2",
    ]:
        pdf.cell(0, 7, line, align="C", new_x=XPos.LMARGIN, new_y=YPos.NEXT)

# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    nouns = parse_nouns(NOUNS_FILE)
    verbs = parse_verbs(VERBS_FILE)
    adjs  = parse_adjectives(ADJ_FILE)
    preps = parse_prepositions(PREPS_FILE)

    noun_count = sum(len(v) for v in nouns.values())
    verb_count = sum(len(v) for v in verbs.values())
    adj_count  = sum(len(v) for v in adjs.values())
    prep_count = sum(len(v) for v in preps.values())

    pdf = VocabPDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=14)
    pdf.set_margins(left=14, top=14, right=14)

    render_title(pdf, noun_count, verb_count, adj_count, prep_count)
    render_nouns(pdf, nouns)
    render_verbs(pdf, verbs)
    render_adjectives(pdf, adjs)
    render_prepositions(pdf, preps)

    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    pdf.output(str(OUT_FILE))
    print(f"Written {OUT_FILE}  ({noun_count} nouns, {verb_count} verbs, {adj_count} adjectives, {prep_count} prepositions)")


if __name__ == "__main__":
    main()
