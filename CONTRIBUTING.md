# Editing the site

Setup and the publishing cycle are in [README.md](README.md). This file covers
the four things you will actually do.

Preview your change with `quarto preview` before committing.

---

## Add or update a person

Edit `team/_people.yml`. Staff go under `staff:`, students under `students:`.

```yaml
  - name: Full Name
    degree: PhD (Economics)          # students; staff use `role:` and `qualification:`
    year: "Expected graduation: 2029"
    email: name@sun.ac.za
    photo: /images/team/full-name.jpg
    focus: center 40%                # optional; portraits only, moves the crop
    thesis: >
      Working Title of the Thesis
    supervisor: Jesse Naidoo
    links:
      website:  https://...
      linkedin: https://...
```

Quote any value containing a colon — `"Expected graduation: 2029"` — or YAML
reads it as a nested key and the render fails. Same rule as the Board below.
`year:` is free text, so `2nd year` works equally well.

Staff carry `role`, `qualification` and `interests`; students carry `degree`,
`year`, `thesis` and `supervisor`. Everything except `name` is optional — a
person with no photo gets a placeholder, and one with no email simply omits that
line. So you can add someone before all their details are to hand.

`links:` accepts any of `website`, `scholar`, `linkedin`, `github`.

**Thesis titles** are titles, not descriptions: title case, with articles,
short prepositions and conjunctions in lower case unless they come first, and
no full stop at the end. For example, "Marginal Borrowers in the Market for
Home Loans".

**Photos.** Square, ideally 600×600 or larger. Drop any crop into `_inbox/` and
it can be normalised into `images/team/` from there.

**Before publishing a student**, confirm they are happy for their name, email
and thesis topic to appear on a public page.

---

## Write an Insights post

```bash
cp -r insights/_template insights/my-post-slug
```

Edit `insights/my-post-slug/index.qmd`, replace or delete the `image:` line, and
delete `draft: true` when it is ready. Directories are slug-named with no date
prefix, so the URL stays stable and quotable; the `date:` field drives ordering
on the listing.

`description:` is what appears on the listing and in the RSS feed — write it to
stand alone.

**First post only.** Insights is left out of the navbar while it has no posts.
When you publish the first one, uncomment the Insights entry in `_quarto.yml`
and add it back to the list of links in `404.qmd`.

The template itself is never rendered or published: Quarto ignores directories
whose names begin with an underscore, which is why it is `_template`.

Every post ends with the Research Charter §7.2 disclaimer:

```markdown
{{< include ../_disclaimer.md >}}
```

Keep it. Insights posts are author-attributed work on live policy questions,
which is exactly what §7.2 covers.

To cite papers, keep the `bibliography:` and `csl:` lines in the front matter and
use `@citekey` against the Centre's Zotero collection. Delete both lines if the
post cites nothing — citeproc fails the render if it loads a style for a document
with no bibliography.

---

## Change the Board

Edit `about/_board.yml`. One entry per member, in the order they should appear:

```yaml
- name: Full Name
  position: Their role, and the institution it is at
```

Quote any position containing a colon — `"Head: Channel Sales, Capitec Bank"` —
or YAML will read it as a nested key.

---

## Publish a governance document

1. Name the PDF to the convention in the brand guidelines:
   `CHF-[DocType]-[ShortTitle]-vX.Y.pdf`, for example
   `CHF-Charter-Research-v1.1.pdf`.
2. Put it in `documents/`.
3. Add an entry to `about/_documents.yml`:

```yaml
- title: "Research Charter"
  doctype: Charter
  version: "1.1"
  date: 2026-07-15
  file: CHF-Charter-Research-v1.1.pdf
  summary: >
    One or two sentences on what the document governs.
```

File size is read off the PDF at render, so there is no field to keep in sync.

Two checks fail the build rather than publishing a broken download: the file must
exist in `documents/`, and its filename must end in `-v<version>.pdf` matching the
`version:` field. So add the entry only once the PDF is in place.

To supersede a document, add the new version as its own entry and delete the old
one — the version number lives in the filename, so both can coexist while you
switch over.

---

## Add a paper or dataset

**Do not edit `research/papers.yml` or `research/datasets.yml`.** They are
generated, and your changes will be overwritten on the next render.

Zotero is the single source of truth. To publish an output, add it to the Zotero
collection **CHF Outputs** and tag it:

| Tag | Effect |
|---|---|
| `chf:public` | **Required.** Only tagged items reach the website |
| `project:Financial information and advice` | Assigns it to a research theme; becomes a filter chip |
| `status:working-paper` | Shows a "working paper" badge |
| `status:published` | Shows a "published" badge |

Name a `project:` tag after the theme's heading on the Research page, so the
chip and the paragraph describing it match. No commas: the export joins tags with
commas, so a comma splits one tag into two.

The `chf:public` gate means Zotero can hold work in progress without it leaking
onto the site.

Items of type `dataset` render under **Data**; everything else under **Papers**.
Titles and abstracts are plain text. Each version of the paper gets its own
labelled link beneath the abstract, read from the item's DOI and URL fields:

| Status tag | Links shown | Also shown |
|---|---|---|
| `status:working-paper` | **Working paper**: the URL, or the DOI if there is no URL | — |
| `status:published` | **Published version**: the DOI; **Preprint**: the URL | Journal, volume, issue, year and pages |

So when a working paper is published, update the same Zotero item: change its
type to Journal Article, add the journal details and the journal DOI, swap the
tag to `status:published`, and leave the URL pointing at the preprint. Zotero
often fills the URL with the publisher's page when it imports an article;
replace that with the preprint link, or clear it, or it will be labelled
"preprint".

To host a preprint here, put the PDF in `research/papers/`, named
`Author-Author-Year-Short-Title.pdf`, and set the item's URL to
`https://householdfinance.org.za/research/papers/<file>.pdf`. The build turns
that into a site-relative link, so it also works in a local preview. PDFs open
in a new tab.

### One-time Zotero setup

Both exports need the [Better BibTeX](https://retorque.re/zotero-better-bibtex/)
plugin, and both must have **Keep updated** ticked so Zotero rewrites them
whenever an item changes.

1. Copy tags into the JSON export. Better CSL JSON leaves Zotero tags out by
   default, and without them no item carries `chf:public`, so the Research
   listing comes out empty. In Zotero → Settings → Better BibTeX → Export →
   Postscript, paste:

   ```js
   if (Translator.BetterCSLJSON) {
     csl.keyword = zotero.tags.map(t => t.tag).join(', ')
   }
   ```

2. Right-click the **CHF Outputs** collection → Export Collection →
   **Better CSL JSON** → save as `research/zotero-outputs.json`
3. Repeat with **Better BibTeX** → save as `research/chf-outputs.bib`
   (this one is for citations inside Insights posts)

`scripts/build-research.R` reads the JSON before every render. If the export is
missing it prints a note and leaves the existing listing alone, so a fresh clone
still builds.

---

## "Last updated" stamps

Three places carry one, and all three are automatic — there is no date to edit:

| Stamp | Comes from |
|---|---|
| "Team last updated …" | `team/_people.yml` |
| "Board as at …" | `about/_board.yml` |
| "Register last updated …" | `about/_documents.yml` |

Each is the date that **file** last changed, read from git at render time. So a
stamp moves when you edit the data behind it, and stays put when you edit the
prose around it. That is why the Board lives in a YAML file rather than as a
markdown table in the page.

Two consequences worth knowing:

- The stamps are deliberately limited to claims a reader cannot otherwise date.
  Insights posts already show a published date, so they carry no "updated" stamp;
  a revision worth announcing gets a sentence in the body, where you can say what
  changed and why. Evergreen pages — the landing page, About, Contact — carry
  none either, since a stamp there would make correctly-unchanged text look
  neglected.
- Stamps need git history, so they only appear when rendering in a real clone. If
  the deployment ever moves to GitHub Actions, `actions/checkout` defaults to
  `fetch-depth: 1`, which returns nothing from `git log` and would make every
  stamp silently vanish. Set `fetch-depth: 0` if that day comes.
