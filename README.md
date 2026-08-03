# Centre for Household Finance — website

Source for [householdfinance.org.za](https://householdfinance.org.za). Built with
[Quarto](https://quarto.org); the rendered site lives in `docs/` and is served by
GitHub Pages.

To add a person, an Insights post or a governance document, see
[CONTRIBUTING.md](CONTRIBUTING.md). For colours, type and logo usage, see
[brand/README.md](brand/README.md).

## Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) 1.4 or later
- R, with four packages:

  ```r
  install.packages(c("yaml", "jsonlite", "knitr", "htmltools"))
  ```

R is required, not optional: the Team page and the governance document list are
generated from YAML data files by `R/chf.R`, and the Research listing is built
from a Zotero export by `scripts/build-research.R`.

## Working on the site

```bash
quarto preview     # live reload at http://localhost:4200
```

Edit `.qmd` and `.yml` files; the browser refreshes as you save.

## Publishing

GitHub Pages serves branch `main`, path `/docs`. **Nothing goes live until the
rendered output in `docs/` is committed** — pushing source changes alone
redeploys the same site.

```bash
quarto render
git add -A
git commit -m "Describe the change"
git push
```

Pages redeploys automatically, usually within a minute.

Any branch other than `main` is invisible to Pages, so feature branches are safe
to push and share.

## Editing alongside other people

`docs/` is generated, and two people rendering the same site will produce
conflicting output. `.gitattributes` hides it from pull request diffs, but the
working rule matters more:

> **Content editors change source files only. Whoever merges re-renders `docs/`
> on `main`, as a separate commit.**

If a `docs/` conflict happens anyway, never resolve it by hand — throw the
directory away and rebuild:

```bash
git rm -r --cached docs && rm -rf docs && quarto render && git add docs
```

## Layout

| Path | What it is |
|---|---|
| `index.qmd` | Landing page |
| `team/` | Team page and `_people.yml`, the staff and student register |
| `research/` | Research listing; `papers.yml` and `datasets.yml` are generated |
| `insights/` | Insights posts, one directory each, plus the post template |
| `about/` | About, Contact, Governance, and `_documents.yml` |
| `documents/` | Published governance PDFs |
| `R/chf.R` | Shared renderers for people cards and the document list |
| `scripts/build-research.R` | Zotero export → Research listing, run before each render |
| `custom.scss` | The entire stylesheet, including the brand implementation |
| `fonts/` | SU Raleway web fonts, six weights |
| `brand/` | Internal reference material. Not published |
| `_inbox/` | Untracked staging area for raw photos, PDFs and artwork |
| `docs/` | Build output. Generated — never edit by hand |

## Notes

- `_inbox/` is gitignored. Drop raw files there in any format; they get
  normalised into `images/` or `documents/` and committed from there.
- Files and directories starting with `_` are ignored by Quarto, which is why
  the data files and post template are named as they are.
- An empty Insights section makes `quarto render` warn that the listing matches
  no files. Harmless; it stops once the first post exists.
