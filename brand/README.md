# Brand implementation record

How the [CHF Brand & Document Guidelines v1.1](https://www.sun.ac.za) (July 2026)
are applied on this website, and why in the places where a judgement was made.

Everything here is implemented in [`../custom.scss`](../custom.scss). Nothing
else in the repository should introduce a colour or a font.

Not published — `brand/` is excluded from the render in `_quarto.yml`.

## Palette

| Role | Value | Where it is used |
|---|---|---|
| Confident Maroon | `#61223B` | Headings, links, navbar text, table header row |
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

**White header with a gold rule.** The guidelines are explicit that maroon and
gold are accents on a white page, not a background wash, and that the logo sits
top-left on a clean background. The site previously had a full-bleed maroon
navbar with a reversed logo; that is the treatment §2 reserves for dark
backgrounds.

**White footer with a gold hairline**, carrying the standard contact block from
§5 in Steel Grey. A maroon footer would be the same background wash, and would
make the page bookend-heavy against a white header. If more colour is wanted, the
sanctioned move is a `#EFE9EB` tint band, not a maroon fill.

## Outstanding: the logo

The navbar currently shows the Centre's name as a maroon wordmark rather than the
co-branded lockup.

`images/logo.png` is the **reversed** lockup — gold and white knocked out of a
solid maroon rectangle, with no transparency (verified: 80% of its pixels are
`#61223B`). On a white navbar it renders as a maroon plate, which is that variant
used outside the context §2 sanctions.

**What is needed:** `images/logo-on-light.svg` — the gold-and-maroon lockup on a
transparent background — from SU Corporate Communication. Optionally
`logo-on-maroon.svg` for any dark-background use later.

To switch once it arrives, in `_quarto.yml`:

```yaml
  navbar:
    title: false
    logo: images/logo-on-light.svg
    logo-alt: "Centre for Household Finance, Stellenbosch University"
```

Minimum size on screen is 142px wide for the horizontal lockup, 85px high for the
stacked one, with clear space of twice the cap-height of the "S" in
"Stellenbosch" (§2).

## Charts

Sequence colours maroon → gold → steel grey → 10% maroon tint. Label series
directly rather than relying on a legend, and avoid heavy gridlines. Where more
series are needed, take them from SU's secondary palette in the SU Brand Manual
(4.2.2) rather than inventing colours.
