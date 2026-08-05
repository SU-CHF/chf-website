# Website update plan — CHF Brand & Document Guidelines v1.2

Status: proposed, not yet implemented. Branch `restructure-2026`.
Source: `branding-and-templates/CHF-Brand-and-Document-Guidelines.pdf` (v1.2, July 2026)
and `SU-Brand-Manual-Reference.md` (changes 16–17).

## What changed in the guidelines

The site was built against v1.1, which said maroon and gold are *accents on a white
page, not a background wash*. v1.2 removes that. Two changes matter here:

1. **Principle 2 renamed "Restraint" → "Maroon leads."** Confident Maroon is the
   dominant colour and the Centre's default field — headers, footers, title bands,
   section blocks (SU colourway 1, primary ratio 70% maroon).
2. **New §7 Web & digital.** Previously the document scoped itself to "letters,
   reports, and slides" and said nothing about websites. §7 now specifies a
   full-width maroon header with the gold-and-white lockup and white navigation,
   a maroon footer, white content with maroon headings and gold as thin accents.

The v1.2 footnote states directly that "maroon headers and footers are off-brand"
was an editorial overstatement, not an SU rule. **The white header and white footer
currently on the site are the treatment v1.2 reverses.** Everything else — palette,
type, tables, cards, gold-as-rules-only — is already correct and should not move.

## Scope

| Change | Files |
|---|---|
| A. Maroon navbar, reversed logo, white nav | `_quarto.yml`, `custom.scss` §2 |
| B. Maroon footer band | `_quarto.yml`, `custom.scss` §8 |
| C. Search, toggler, mobile collapse on maroon | `custom.scss` §2 |
| D. Gold accents: buttons, active states | `custom.scss` §3, §7 |
| E. Optional maroon title band on the landing page | `index.qmd`, `custom.scss` |
| F. Documentation | `brand/README.md`, `custom.scss` header comment |

Out of scope: heading scale, table styling, card system, chart sequence, fonts.

---

## A. Navbar — maroon band, gold-and-white lockup

**`_quarto.yml`**

- `navbar.logo`: `images/logo/chf-horizontal-on-light.svg` → `images/logo/chf-horizontal-on-maroon.svg`.
  The reversed artwork is already in the repo, byte-identical to what SU supplied
  (fills `#fff` and `#caa258`). No recolouring needed.
- The comment above `logo:` currently explains the choice the other way round;
  rewrite it.

**`custom.scss` — defaults block**

```
$navbar-bg:       $chf-maroon;
$navbar-fg:       $chf-white;
$navbar-hl:       $chf-gold;
$navbar-brand:    $chf-white;
$navbar-brand-hl: $chf-white;
```

**`custom.scss` §2 rules**

- `.navbar { background-color: $chf-maroon; }`. Keep `border-bottom: $chf-rule-gold`
  — the gold hairline reads as the accent rule between the maroon band and the
  white content, and matches the letterhead anatomy in §5.
- `.nav-link { color: $chf-white; font-weight: 600; }` — §4 and SU 4.3.2 require
  one weight heavier when reversing type out of maroon. Current value is 500.
- Hover/focus: `color: $chf-white; border-bottom-color: $chf-gold`. Do **not**
  use `$chf-maroon-dark` for text on maroon — it measures 1.20:1.
- Active: `color: $chf-white; font-weight: 700; border-bottom-color: $chf-gold`.
  Weight and the gold underline both carry the state, so it does not rely on
  colour alone (§4 DON'T list).
- `.navbar-title`: white, weight 600 (unused today — `title: false` — but keep
  it consistent).
- Dropdown: white panel with `border-top: $chf-rule-gold` is fine as-is; it sits
  below the band on white. Verify the maroon items still read against it.
- **Logo sizing is load-bearing — do not touch.** `height: 84px; max-height: none`
  stays. Height is what keeps the descriptor line legible and it is well over the
  §7 minimum of 142 px wide (84 px tall ≈ 286 px wide; mobile 44 px ≈ 150 px).
- Clear space: the band needs vertical padding so nothing intrudes on 2× the
  cap-height of the "S" in "Stellenbosch" (SU 4.1.4). At 84 px the lockup's "S"
  is roughly 9 px, so ~18 px of clear space; current `padding: 4px 0` on the logo
  is under that. Add padding on `.navbar` rather than growing the logo.

Contrast on `#61223B`: white 11.67:1 (AAA), gold 4.90:1 (AA for normal text,
AAA for large). Gold stays a rule colour — do not promote it to nav-link text.

## B. Footer — maroon band

**`_quarto.yml`**

- Keep `page-footer.border: "#CAA258"` — the gold hairline now separates white
  content from the maroon footer, which is exactly §5's letterhead anatomy.
- The contact block text is unchanged. The `[Contact]` / `[Governance]` links and
  the `**Centre for Household Finance**` lead-in inherit new colours from CSS.

**`custom.scss` §8**

- `.nav-footer { background-color: $chf-maroon; color: $chf-white; }`.
- Links: `$chf-white`, underline on hover; hover colour `$chf-gold` (4.90:1) or
  stay white with an underline. Prefer the underline — it does not rely on colour.
- `strong { color: $chf-gold; }` (currently maroon-on-white; maroon on maroon
  is invisible). Gold on maroon at bold caption weight is acceptable for a
  one-line lead-in; if 4.90:1 feels thin at 13 px, keep it white and let the
  weight carry it.
- Steel Grey must go from the footer entirely — 1.49:1 on maroon.
- **Structural fix.** `.nav-footer` currently carries `max-width: 1320px; margin:
  0 auto`. With a background colour that stops the band short of the viewport
  edges and produces a floating maroon rectangle. Move the constraint to an inner
  wrapper: keep the background and padding on `.nav-footer`, and constrain the
  flex row (`.nav-footer > .nav-footer-left/-center/-right` inside a
  `max-width: 1320px; margin: 0 auto` container, or set `padding-inline:
  max($chf-gap, calc((100% - 1320px) / 2))`). Same fix applies to `.navbar`,
  which already uses `.navbar-container` for this and is fine.
- Retain the `.nav-footer-center { min-height: 0 }` fix and the mobile stacking
  rules — both were bug fixes, not brand decisions.

## C. Chrome that only shows up on maroon

These are invisible on a white navbar and will break silently:

- **Search.** `search: true` puts Quarto's search control in the navbar. Its
  input, icon, placeholder, and the `aria` affordances inherit dark-on-light
  defaults. Style `.aa-Autocomplete`, `.aa-DetachedSearchButton` /
  `#quarto-search .aa-Autocomplete .aa-Input` for white-on-maroon, with a
  `rgba(255,255,255,0.12)` field and a white icon. The results panel is an
  overlay on white — leave it.
- **Hamburger toggler** (`< 992px`). Bootstrap's default icon is a dark SVG data
  URI; set `.navbar-toggler-icon` to the white variant and
  `.navbar-toggler { border-color: rgba(255,255,255,0.35) }`.
- **Collapsed menu.** When the mobile menu opens, links render inside the maroon
  band — confirm they stay white and the dropdown submenu is readable.
- **Skip-link / focus rings.** Default focus outline is `$primary` (maroon) and
  will vanish on the band. Set a white or gold outline within `.navbar`.

## D. Gold accents in content

§7 adds "gold as a thin accent (rules, buttons, active states)" and "links and
buttons: maroon or gold." Content areas stay white, so no change is required —
but two small ones align the site with §7:

- `.btn-primary` (unstyled today, inherits flatly): maroon fill, white text,
  gold border on hover.
- `.quarto-listing-category .category.active` already uses a gold underline. Keep.

Do not introduce gold text anywhere. The accessibility note in `brand/README.md`
stands: gold on white is 2.38:1 and fails every WCAG threshold. v1.2 does not
change that — it only sanctions maroon *fields*, and §4 still says body text is
never gold.

## E. Optional — maroon title band on the landing page

§7 sanctions "title bands" and "section blocks." The landing page currently opens
with an H1 and a gold rule under a white header; against a maroon navbar that
reads thin. A full-width maroon band carrying the page title, with
`images/banner_001.jpg` beneath, would follow the slide-deck convention in §6
(maroon title field, white content).

Treat this as a second, separable commit. The A–D changes are corrections to a
stated brand error; this one is a design change and should be reviewed on its
own.

## F. Documentation

`brand/README.md` is the brand implementation record and it currently argues
*against* this change, in the section "Layout decisions":

> **White header with a gold rule.** The guidelines are explicit that maroon and
> gold are accents on a white page, not a background wash…
> **White footer with a gold hairline** … A maroon footer would be the same
> background wash…

Both paragraphs must be replaced, not amended — the reasoning in them is the
v1.1 error. Rewrite as "Maroon header and footer (v1.2 §7)", cite SU 4.1.5
colourway 1 and 4.2.4, and record the reversal so the history is legible.

Also update:

- The palette table row for Confident Maroon: add "navbar band, footer band."
- The logo table: `chf-horizontal-on-maroon.svg` becomes **in use**;
  `chf-horizontal-on-light.svg` becomes the light-background variant.
- Add reversed-type contrast figures (white 11.67:1, gold 4.90:1 on maroon).
- The header comment in `custom.scss` cites "v1.1 (July 2026), §3" — bump to v1.2
  and add §7.
- The `$footer-bg` comment ("A full-bleed maroon footer would be exactly the
  'background wash' the guidelines rule out") is now wrong. Delete it.

## Verification

1. `quarto render` and check every page type: landing, Research listing, Insights
   listing, a post, Team cards, About, governance (R-generated Board table), 404.
2. Contrast-check every foreground/background pair introduced, including the
   search field and focus rings. Target AA minimum; the palette comfortably
   reaches AAA for text.
3. Check the mobile breakpoints (768 px, 992 px): collapsed menu, logo at 44 px,
   stacked footer columns, and that the maroon bands run full-bleed at every
   width.
4. Confirm the footer band is genuinely full-width — the `max-width` fix in B is
   the most likely thing to be got wrong.
5. Re-run the §8 checklist in the guidelines against a rendered page: correct
   colourway for the background, logo ≥ 142 px, clear space, ligatures off,
   contact block present, no invented colours.
6. Diff the compiled `docs/site_libs/bootstrap/bootstrap-*.min.css` for any hex
   that is not in the palette.

## Sequencing

1. Commit 1 — A + B + C (header and footer band, reversed logo, chrome).
2. Commit 2 — F (documentation), same PR.
3. Commit 3 — D (button/accent polish), optional.
4. Commit 4 — E (landing-page title band), separate review.

Open question for the brand owner: the heading scale interpretation flagged in
`brand/README.md` is still awaiting sign-off, and v1.2 did not address it. Worth
raising in the same round.
