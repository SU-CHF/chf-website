# Plan: render and deploy the site on GitHub Actions

Status: in progress. Retire this file once step 5 is done, after folding anything
still useful into README.md.

## Why

GitHub Pages currently serves the `docs/` folder from `main`, exactly as someone
rendered and committed it. Nothing checks that `docs/` matches the source, and
in October 2026 it had fallen several commits behind: edits to the board, the
team and the copy had been committed, but not their rendered output, and the
Research Charter PDF linked from the Governance page was missing from `docs/`.
Committed build output also produces merge conflicts whenever two people render.

## What replaces it

`.github/workflows/publish.yml` renders the site on every push to `main` (or on
demand from the Actions tab) and deploys the result to Pages directly. Nobody
commits `docs/` any more. The workflow:

- checks out the full git history (`fetch-depth: 0`), because the "last updated"
  stamps on the Team and Governance pages read each data file's date from
  `git log`, and a shallow clone would make them silently disappear;
- installs Quarto 1.10.18 and R 4.6.1, the versions the site was built with;
- installs the R packages pinned in `renv.lock`;
- runs `quarto render`, which also runs `scripts/build-research.R` against the
  committed Zotero export, and uploads `docs/` as the Pages artifact.

## Steps

1. **Pin R packages.** Done 1 November 2026: `renv::init()` wrote `renv.lock`,
   `.Rprofile` and `renv/`.
2. **Commit and merge.** Commit the lockfile, the workflow and this plan, and
   merge to `main`. The workflow runs on the merge and its deploy job fails,
   because Pages is still in branch mode. That is expected and harmless: Pages
   keeps serving the committed `docs/`, which the merge has just updated.
3. **Switch Pages to Actions** (needs admin rights on `SU-CHF/chf-website`, and
   Actions allowed for the organisation). In Settings → Pages, set Source to
   "GitHub Actions". Confirm `householdfinance.org.za` still shows as the custom
   domain with HTTPS enforced: an Actions deployment ignores the `CNAME` file,
   so the domain lives only in these settings. Then Actions → Publish site →
   Run workflow.
4. **Check the live site.** Every page loads; the "Team last updated", "Board as
   at" and "Register last updated" stamps appear; the governance PDFs download;
   the Raleway web fonts load (check that headings are not in a fallback font).
5. **Clean up**, after a deploy or two have gone through cleanly:
   - `git rm -r --cached docs` and add `docs/` to `.gitignore`;
   - remove the `docs/` lines from `.gitattributes`;
   - rewrite README's Publishing and "Editing alongside other people" sections:
     pushing to `main` publishes, and there is no `docs/` to render or commit;
   - delete this file.

## Rolling back

Until step 5, switching Settings → Pages → Source back to "Deploy from a branch"
(`main`, `/docs`) restores the old arrangement. Once Actions is live nobody
updates `docs/`, so render and commit it before switching back, or Pages will
serve a stale site.
