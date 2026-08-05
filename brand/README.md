# Brand implementation record

How the [CHF Brand & Document Guidelines v1.2](CHF-Brand-and-Document-Guidelines-v1.2.pdf)
(July 2026) are applied on this website, and why in the places where a judgement
was made. Where the guidelines are silent, the Stellenbosch University
[Brand Manual](https://www.su.ac.za/en/about/brand-identity) (Corporate
Communication and Marketing, November 2025) governs; clause numbers below in the
form "SU 4.1.5" are its.

Everything here is implemented in [`../custom.scss`](../custom.scss). Nothing
else in the repository should introduce a colour or a font.

Not published — `brand/` is excluded from the render in `_quarto.yml`.

## What is in this folder

| File | What it is |
|---|---|
| `README.md` | This file. The implementation record |
| `CHF-Brand-and-Document-Guidelines-v1.2.pdf` | The governing document. Version in the filename because v1.1 and v1.2 disagree about maroon, and it matters which one a claim rests on |
| `SU-Brand-Manual-Reference.md` | Working reference: the SU manual clauses that bear on CHF documents, plus the v1.0 → v1.1 → v1.2 change log |
| `website-update-plan-v1.2.md` | The plan this site's v1.2 update followed |
| `founding-record.md` | The 2025 founding announcements, kept from the old landing page |
| `fonts/` | The 18 desktop TTFs, for authoring Word and PDF documents |

The guidelines PDF is the authority for anything cited as "§" below; the SU
manual is the authority for anything cited as "SU". Both were previously
external to the repository, which meant this file cited documents nobody reading
it could open.

## Palette

| Role | Value | Where it is used |
|---|---|---|
| Confident Maroon | `#61223B` | Navbar band, footer band, headings, links, table header row |
| Brilliant Gold | `#CAA258` | Thin rules only — navbar underline, heading rules, card top border |
| SU Black | `#2C2A29` | Body text |
| Steel Grey | `#4D5356` | Captions, footer, metadata |
| 10% maroon | `#EFE9EB` | Table stripes, callout and disclaimer fills |
| 20% maroon | `#DFD3D8` | Hairline borders |

The tints are the stated percentage of maroon mixed into white. The 10% value is
exactly the `#EFE9EB` printed in §3 of the guidelines, which is what confirms the
derivation; the 20% follows from it. Only 10/20/40/60% are sanctioned.

They are written as hex literals rather than Sass `mix()` calls because Dart Sass
emits fractional `rgb(239.2, 232.9, 235.4)` — which browsers round correctly, but
which makes the compiled CSS impossible to check against the guidelines by eye.

### Gold is never used for text

This is an accessibility requirement, not only a brand preference. Measured
contrast ratios against white:

| Foreground | Ratio | WCAG |
|---|---|---|
| Confident Maroon | 11.67:1 | AAA |
| SU Black | 14.28:1 | AAA |
| Steel Grey | 7.81:1 | AAA |
| **Brilliant Gold** | **2.38:1** | **fails everything** |

Gold appears only as rules, borders and the disclaimer's left edge.

§7 does sanction "links and buttons: maroon or gold", so gold link text is not a
brand violation. It is an accessibility one on a white page, and §4 still lists
"set body text in maroon, gold, or light grey" among the DON'Ts, so the rule
above stands unchanged: gold is a rule colour here, never a text colour.

Reversed out of the maroon bands, the same measurements are:

| Foreground on `#61223B` | Ratio | WCAG |
|---|---|---|
| White | 11.67:1 | AAA |
| Brilliant Gold | 4.90:1 | AA normal, AAA large |
| Steel Grey | 1.49:1 | fails everything |
| `$chf-maroon-dark` | 1.20:1 | fails everything |

Which is why the navbar and footer carry white type, why Steel Grey cannot
appear on either band, and why neither hover state restates the text colour —
the gold underline and the extra weight carry them instead.

## Typography

SU Raleway throughout, falling back to Trebuchet MS as the guidelines specify.
Ligatures are disabled (`font-variant-ligatures: none` plus explicit
`font-feature-settings`), per §4.

Six weights are served as WOFF2 from `/fonts`: Regular, Italic, Medium, SemiBold,
Bold and BoldItalic. The 18 desktop TTFs in `fonts/` are for authoring Word and
PDF documents — see [`fonts/README.md`](fonts/README.md), which also records why
there was no font migration to do.

### The heading scale is an interpretation

The guidelines specify print points: 24–28pt document title, 15pt section
heading, 12.5pt sub-section, 10.5pt body. Transcribed literally that gives about
14px body text, which is too small to read comfortably on screen.

The **ratios, weights and colours are preserved** against a web-native 16px base:

| Guideline role | Print | Web | Weight |
|---|---|---|---|
| Document title | 24–28pt | 2rem | Bold |
| Section heading (H2) | 15pt | 1.5rem | Bold, gold rule |
| Sub-section (H3) | 12.5pt | 1.2rem | SemiBold, gold rule |
| Body | 10.5pt | 1rem | Regular |
| Captions, footer | 7.5–8.5pt | 0.8125rem | Regular, Steel Grey |

**This awaits brand-owner sign-off.**

## Layout decisions

**Maroon header and footer (v1.2 §7).** The header is a full-width Confident
Maroon band carrying the reversed gold-and-white lockup top-left, with the
navigation in white; the footer is a second maroon band carrying the standard
contact block. This is SU colourway 1 — "Brilliant Gold and white on a Confident
Maroon background" (SU 4.1.5) — and it expresses the primary ratio's 70%
Confident Maroon (SU 4.2.4). SU's own properties, su.ac.za and centre sites such
as resep.sun.ac.za, are built the same way.

**A gold hairline separates each band from the white content.** Note that this
is a web-specific reading, not a transcription: §5's letterhead anatomy puts a
gold rule under the header but a *maroon* hairline above the footer contact
block, which would be invisible against a maroon band. Gold is the only value
that does the job on both edges.

**Content stays white** with SU Black body text, maroon headings and gold as
thin accents, per §7. The bands are the only large maroon fields on the site.

### This reverses what v1.1 said, and what this file used to say

Until August 2026 the two paragraphs above read the other way round. They argued
for a white header and a white footer on the grounds that "the guidelines are
explicit that maroon and gold are accents on a white page, not a background
wash", and that a maroon footer would be "the same background wash".

That reasoning was wrong, and the wording it rested on has been withdrawn.
Nothing in the SU Brand Manual restricts maroon to accents: colourway 1 places
gold-and-white *on* maroon, and the primary ratio makes maroon dominant. v1.2
renamed the principle from "Restraint" to "Maroon leads", removed the
white-page framing, and added §7 Web & digital; its own footnote records that
"maroon headers and footers are off-brand" was an editorial overstatement rather
than an SU rule. The correction is logged as changes 16–17 in
[`SU-Brand-Manual-Reference.md`](SU-Brand-Manual-Reference.md).

The history is worth keeping because the site has now been built both ways, and
the argument for the white version was made in this file in good faith.

## The logo

The official co-branded lockups, exactly as supplied by SU Corporate
Communication (RGB SVG), live in `images/logo/`:

| File | Use |
|---|---|
| `chf-horizontal-on-maroon.svg` | **In use** — the maroon navbar band |
| `chf-stacked-on-maroon.svg` | Reversed, narrow or square |
| `chf-horizontal-on-light.svg` | Gold-and-maroon, for white or light backgrounds |
| `chf-stacked-on-light.svg` | Narrow or square spaces on light backgrounds |

They are the supplied artwork — no recolouring, no reformatting, no added
attributes. Each is paths in two fills on a transparent ground: the `-on-light`
pair `#61223B` and `#CAA258`, the `-on-maroon` pair `#FFF` and `#CAA258`. So the
navbar swap is a file swap, not a restyle; SU supplied the reversed colourway
ready to use.

([`SU-Brand-Manual-Reference.md`](SU-Brand-Manual-Reference.md) records that SU's own delivery named the
reversed horizontal file `CHF_logo_maroon_gold_horizontal_RGB.svg` although it
holds the white-and-gold artwork. The files here are named for what they
contain.)

The earlier `images/logo.png` has been deleted. It was the **reversed** lockup
flattened onto a solid maroon rectangle with no transparency (80% of its pixels
were `#61223B`). Even now that the band behind it is maroon, a flattened plate
would be the wrong asset: it cannot inherit the band's exact colour, and SU
supplies the reversed artwork on a transparent ground precisely so it does.

### Sizing gotcha

The supplied SVGs declare a `viewBox` but no `width`/`height`, so they have **no
intrinsic size**. Quarto's default `.navbar-logo { max-height: 24px; width: auto }`
collapses such an image to zero width — the logo silently disappears. `custom.scss`
therefore sets an explicit `height` *and* `max-height: none`; both are needed,
since the 24px cap would otherwise clamp the height back down.

Current sizing is 84px tall (290px wide) on desktop and 44px (154px) on mobile.
The §2 and §7 on-screen minimum is 142px wide for the horizontal lockup and 85px
high for the stacked one, with clear space of twice the cap-height of the "S" in
"Stellenbosch" (SU 4.1.4).

### The second sizing gotcha: padding eats the height

`.navbar-logo` used to carry `padding: 4px 0`. Under `box-sizing: border-box`,
which Bootstrap applies to everything, padding comes *out of* the declared
height rather than adding to it — so the artwork rendered at 76px, not 84px, and
the lockup at 259px rather than 290px. On mobile that took a nominal 44px logo
down to 36px of artwork and **122px wide, under the 142px minimum**. The padding
has been removed; both breakpoints now clear the minimum, measured in the
browser at 290px and 154px.

### Clear space is already inside the artwork

Measured on the supplied SVG by rasterising it and reading the ink extents: the
transparent margin above the artwork is 25.5% of the file's height and the one
below is 24.4%, against a capital "S" in "Stellenbosch" that is 12.6%. Twice the
cap-height is therefore 25.2% — so the file arrives with essentially the whole
clear-space requirement built into its own canvas.

On top of that the navbar contributes 1rem of padding and the brand container
0.3rem, which measures 22px above the lockup and 22px below it to the gold rule,
against a 9.6px cap-height at the desktop size. The requirement is met roughly
four times over, and **no navbar padding needed adding** to satisfy it. Worth
knowing before anyone "fixes" the clear space by growing the band: at these
sizes the constraint is not binding.

## Charts

Sequence colours maroon → gold → steel grey → 10% maroon tint. Label series
directly rather than relying on a legend, and avoid heavy gridlines. Where more
series are needed, take them from SU's secondary palette in the SU Brand Manual
(4.2.2) rather than inventing colours.
