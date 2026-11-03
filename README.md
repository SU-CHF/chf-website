# Centre for Household Finance — website

Source for [householdfinance.org.za](https://householdfinance.org.za). Built with
[Quarto](https://quarto.org), rendered by GitHub Actions and served by GitHub
Pages.

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
`renv::snapshot()` and commit `renv.lock`. The GitHub Actions build installs
exactly what the lockfile lists, so a package missing from it fails the deploy.

## Working on the site

```bash
quarto preview     # live reload at http://localhost:4200
```

Edit `.qmd` and `.yml` files; the browser refreshes as you save.

## Publishing

**Pushing to `main` is publishing.** Every push to `main` runs
`.github/workflows/publish.yml`, which checks out the repo with its full
history, installs the Quarto and R versions the site was built with and the R
packages in `renv.lock`, runs `quarto render`, and deploys the result to GitHub
Pages. A deploy takes about two minutes; follow it under the repository's
Actions tab. To redeploy without a new commit, use Actions → Publish site → Run
workflow.

The rendered site is never committed: `docs/` is local build output and is
gitignored. Commit source files only.

There is no staging site. Any branch other than `main` is invisible to Pages,
so feature branches are safe to push and share, but the moment one is merged
into `main` it is live. Before merging, render the branch and look at the
static output, not the preview server:

```bash
quarto render
python3 -m http.server -d docs 4201   # http://localhost:4201
```

`quarto preview` renders pages on demand, so it can hide a file that the full
render never copies into `docs/`, such as a font or PDF missing from
`resources` in `_quarto.yml`. The static server shows exactly what the deploy
will serve.

If the build fails, nothing is deployed and the live site stays as it was. The
usual causes are an R package missing from `renv.lock` and a governance PDF
that `_documents.yml` lists but `documents/` lacks; the failed run's log names
the step.

To undo a bad publish, revert the commit on `main` and push; the workflow
redeploys the previous state:

```bash
git revert <commit>
git push
```

The Pages settings (source "GitHub Actions", the custom domain
`householdfinance.org.za`, HTTPS enforced) live in the repository settings on
GitHub, not in this repo. An Actions deployment ignores the root `CNAME` file,
so the domain is kept only in those settings; the certificate is managed by
GitHub and renews on its own. To check them:

```bash
gh api repos/SU-CHF/chf-website/pages
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
| `docs/` | Local build output. Gitignored; the deploy renders its own |
| `renv.lock`, `renv/`, `.Rprofile` | Pinned R packages and the project library that loads them |
| `.github/workflows/publish.yml` | Renders and deploys the site on GitHub Actions |

## Notes

- `_inbox/` is gitignored. Drop raw files there in any format; they get
  normalised into `images/` or `documents/` and committed from there.
- Files and directories starting with `_` are ignored by Quarto, which is why
  the data files and post template are named as they are.
- An empty Insights section makes `quarto render` warn that the listing matches
  no files. Harmless; it stops once the first post exists.
