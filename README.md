# Centre for Household Finance — website

Source for [householdfinance.org.za](https://householdfinance.org.za). Built with
[Quarto](https://quarto.org); the rendered site lives in `docs/` and is served by
GitHub Pages.

To add a person, an Insights post or a governance document, see
[CONTRIBUTING.md](CONTRIBUTING.md). For colours, type and logo usage, see
[brand/implementation-record.md](brand/implementation-record.md).

## Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) 1.10 or later
- R 4.6 or later, with the packages pinned in `renv.lock`. In a fresh clone,
  start R in the repo (`.Rprofile` activates the project library) and run:

  ```r
  renv::restore()
  ```

R is required, not optional: the Team page and the governance document list are
generated from YAML data files by `R/chf.R`, and the Research listing is built
from a Zotero export by `scripts/build-research.R`.

To add an R package, install it in the project, use it, then run
`renv::snapshot()` and commit `renv.lock`. The GitHub Actions build (see
[deployment-plan.md](deployment-plan.md)) installs exactly what the lockfile
lists, so a package missing from it fails the deploy.

## Working on the site

```bash
quarto preview     # live reload at http://localhost:4200
```

Edit `.qmd` and `.yml` files; the browser refreshes as you save.

## Publishing

> A move to rendering on GitHub Actions is under way; see
> [deployment-plan.md](deployment-plan.md). Until its cutover step is done, the
> process below still applies.

GitHub Pages serves branch `main`, path `/docs`, in "deploy from a branch" mode.
There is no GitHub Actions workflow and no build step on GitHub: Pages serves
the files in `docs/` exactly as they were rendered on someone's machine and
committed. **Nothing goes live until the rendered output in `docs/` is
committed** — pushing source changes alone redeploys the same site.

```bash
quarto render
git add -A
git commit -m "Describe the change"
git push
```

Pages redeploys automatically, usually within a minute.

**There is no staging site. Pushing to `main` is publishing.** Any branch other
than `main` is invisible to Pages, so feature branches are safe to push and
share, but the moment one is merged into `main` and pushed, it is live. Before
merging, render the branch and look at the static output, not the preview
server:

```bash
quarto render
python3 -m http.server -d docs 4201   # http://localhost:4201
```

`quarto preview` renders pages on demand, so it can hide a file that the full
render never copies into `docs/`, such as a font or PDF missing from
`resources` in `_quarto.yml`. The static server shows exactly what Pages will
serve.

To undo a bad publish, revert the commit on `main` and push; Pages redeploys
the previous `docs/`:

```bash
git revert <commit>
git push
```

The custom domain, `householdfinance.org.za` (and `www.`), is read from
`docs/CNAME`, which the render copies from the root `CNAME` because it is listed
under `resources`. Keep it there: if `docs/CNAME` disappears, Pages drops the
custom domain on the next deploy. HTTPS is enforced; the certificate is managed
by GitHub and renews on its own.

The Pages settings themselves (source branch and path, domain, HTTPS) live in
the repository settings on GitHub, not in this repo. To check them:

```bash
gh api repos/SU-CHF/chf-website/pages
```

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
| `brand/` | The brand guidelines, the SU manual reference, and how they are applied here. Not published |
| `_inbox/` | Untracked staging area for raw photos, PDFs and artwork |
| `docs/` | Build output. Generated — never edit by hand |
| `renv.lock`, `renv/`, `.Rprofile` | Pinned R packages and the project library that loads them |
| `.github/workflows/publish.yml` | Renders and deploys the site on GitHub Actions |

## Notes

- `_inbox/` is gitignored. Drop raw files there in any format; they get
  normalised into `images/` or `documents/` and committed from there.
- Files and directories starting with `_` are ignored by Quarto, which is why
  the data files and post template are named as they are.
- An empty Insights section makes `quarto render` warn that the listing matches
  no files. Harmless; it stops once the first post exists.
