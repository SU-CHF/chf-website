# SU Raleway — desktop fonts

These 18 TrueType files are SU Raleway, as distributed by Stellenbosch University
Corporate Communication. They are **not used by the website** — install them locally for
authoring Word and PDF documents to the naming convention in the CHF Brand & Document
Guidelines (`CHF-[DocType]-[ShortTitle]-vX.Y.docx`).

The website serves the same typeface from `/fonts` as six WOFF2 faces. See
[`../README.md`](../README.md) for the brand implementation record.

## Provenance

Verified August 2026 by parsing the font tables directly.

SU Raleway is **Raleway v3.000g** by Matt McInerney, Pablo Impallari and Rodrigo
Fuenzalida, licensed under the SIL Open Font License 1.1. The files SU distributes under
`SU-raleway-*` names and the `Raleway-*` files that shipped with this repository are the
same font: the `glyf` (outlines), `hmtx` (metrics), `cmap`, `GPOS` (kerning) and `GSUB`
tables are byte-identical. Only `name`, `OS/2`, `head` and `post` metadata differ.

Two practical consequences:

- **There is nothing to convert or migrate.** An earlier investigation concluded these
  were different fonts; that was wrong. It used `strings` on the binaries, which cannot
  see TrueType `name` records because they are encoded UTF-16BE.
- **Do not "upgrade" to the current Google Fonts Raleway.** That is v4.x, a variable
  font with different metrics and glyph coverage. Pinning v3.000g is what keeps the
  website and Word documents visually identical. The guidelines' instruction not to
  substitute Google Fonts Raleway for SU Raleway is satisfied by self-hosting these
  files.

## Installing on macOS

Select all `.ttf` files, right-click, Open, then Install Font. Word and PowerPoint pick
them up as "Raleway" — the family name inside the files is `Raleway`, not `SU Raleway`,
which is expected.
