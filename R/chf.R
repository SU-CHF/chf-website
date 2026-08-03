# R/chf.R — shared rendering helpers for the CHF website.
#
# Sourced by team/index.qmd and about/governance.qmd. Each renderer writes HTML
# to stdout, so call it from a chunk with `#| output: asis`.
#
# To inspect a card without rendering the whole site:
#   source("R/chf.R"); cat(chf_person_card(yaml::read_yaml("team/_people.yml")$staff[[1]], "staff"))

suppressPackageStartupMessages({
  library(yaml)
})

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || identical(x, "")) y else x

esc <- function(x) {
  x <- as.character(x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;",  x, fixed = TRUE)
  x <- gsub(">", "&gt;",  x, fixed = TRUE)
  gsub('"', "&quot;", x, fixed = TRUE)
}

# YAML folded scalars (`>`) leave newlines behind; collapse them to one line.
tidy_text <- function(x) trimws(gsub("[[:space:]]+", " ", x %||% ""))

# Site-wide date format, matching the governance approval dates.
chf_format_date <- function(d) trimws(format(as.Date(d), "%e %B %Y"))


# ── "Last updated" stamps ─────────────────────────────────────────────────
#
# Dates come from git, per file, not from Quarto's `date-modified`. Quarto's
# only automatic source is filesystem mtime, which resets to checkout time on a
# fresh clone — so the first render on a new machine would stamp every page with
# the day it was cloned, and nobody would notice it was wrong.
#
# Paths are relative to the calling document's directory, which is where knitr
# runs each chunk. Git resolves pathspecs relative to the working directory, so
# `chf_stamp("_people.yml")` from team/index.qmd needs no qualification.

#' Date a file was last changed, as a formatted string, or NULL.
chf_last_updated <- function(path) {

  if (!file.exists(path)) return(NULL)

  git <- function(args) {
    suppressWarnings(
      system2("git", args, stdout = TRUE, stderr = FALSE)
    )
  }

  # Not a git repo, or git missing entirely — no stamp, no error.
  inside <- suppressWarnings(
    system2("git", c("rev-parse", "--is-inside-work-tree"),
            stdout = TRUE, stderr = FALSE)
  )
  if (!identical(as.character(inside)[1], "true")) return(NULL)

  # Uncommitted changes against HEAD mean the edit is happening right now: you
  # edit the data file, render, then commit. Git history does not know about it
  # yet, so today is the honest answer.
  dirty <- suppressWarnings(
    system2("git", c("diff", "--quiet", "HEAD", "--", shQuote(path)),
            stdout = FALSE, stderr = FALSE)
  )
  if (!identical(as.integer(dirty), 0L)) return(chf_format_date(Sys.Date()))

  # Author date rather than committer date: stable across rebases.
  d <- git(c("log", "-1", "--format=%as", "--", shQuote(path)))

  # No history, but the file exists and we are in a repo — it is new and
  # untracked, so `git diff` did not flag it. Today is still correct. (Returning
  # nothing here would silently drop the stamp on any newly added data file.)
  if (length(d) == 0 || !nzchar(d[1])) return(chf_format_date(Sys.Date()))

  chf_format_date(d[1])
}

#' Emit a "last updated" line. Silent when the date cannot be determined.
#'
#' @param path   file whose history dates the claim
#' @param prefix leading text, e.g. "Team last updated"
chf_stamp <- function(path, prefix) {
  when <- chf_last_updated(path)
  if (is.null(when)) return(invisible(NULL))
  cat(sprintf('<p class="chf-meta chf-stamp">%s %s</p>\n', esc(prefix), esc(when)))
  invisible(NULL)
}


# ── Icon links ────────────────────────────────────────────────────────────

chf_icon <- function(url, icon, label) {
  if (is.null(url) || !nzchar(url)) return("")
  sprintf(
    '<a href="%s" title="%s" aria-label="%s" rel="noopener"><i class="%s" aria-hidden="true"></i></a>',
    esc(url), esc(label), esc(label), icon
  )
}

chf_links <- function(links) {
  if (is.null(links)) return("")
  html <- paste0(
    chf_icon(links$website,  "fas fa-link",           "Personal website"),
    chf_icon(links$scholar,  "fas fa-graduation-cap", "Google Scholar"),
    chf_icon(links$linkedin, "fab fa-linkedin",       "LinkedIn"),
    chf_icon(links$github,   "fab fa-github",         "GitHub")
  )
  if (!nzchar(html)) "" else sprintf('<div class="chf-card-links">%s</div>', html)
}


# ── Person cards ──────────────────────────────────────────────────────────

#' Render one person card.
#'
#' Staff and student cards differ only in which three fields they surface, so
#' the layout below is shared and only the field mapping branches.
#'
#' @param p    one entry from _people.yml
#' @param kind "staff" or "student"
chf_person_card <- function(p, kind = c("staff", "student")) {

  kind <- match.arg(kind)

  if (kind == "staff") {
    role   <- p$role %||% "Researcher"
    qual   <- p$qualification %||% ""
    label  <- "Research interests"
    detail <- tidy_text(p$interests)
    extra  <- ""
  } else {
    role   <- p$degree %||% ""
    qual   <- p$year %||% ""
    label  <- "Thesis"
    detail <- tidy_text(p$thesis)
    extra  <- if (!is.null(p$supervisor)) {
      sprintf('<p class="chf-meta">Supervised by %s</p>', esc(p$supervisor))
    } else ""
  }

  photo <- p$photo %||% "/images/team/placeholder.png"

  # Cards are square but portraits are not, so the browser crops with
  # object-fit: cover. `focus:` moves the crop window up or down — a lower
  # percentage keeps more of the top of the frame, which is what a portrait with
  # the face high in it needs. Omit for square photos; the default is centred.
  focus <- if (!is.null(p$focus) && nzchar(p$focus)) {
    sprintf(' style="object-position: %s"', esc(p$focus))
  } else ""

  email_html <- if (!is.null(p$email) && nzchar(p$email)) {
    sprintf('<p class="chf-card-email"><a href="mailto:%s">%s</a></p>',
            esc(p$email), esc(p$email))
  } else ""

  qual_html <- if (nzchar(qual)) {
    sprintf('<p class="chf-card-qual">%s</p>', esc(qual))
  } else ""

  detail_html <- if (nzchar(detail)) {
    sprintf('<p class="chf-card-label">%s</p><p class="chf-card-text">%s</p>',
            esc(label), esc(detail))
  } else ""

  # Emitted flush-left and one element per line. Any leading indentation here is
  # read by Pandoc as an indented code block and the whole card is escaped into
  # a <pre>, so do not "tidy" this into a nested layout.
  paste0(
    '<div class="chf-card">\n',
    sprintf('<img src="%s" alt="%s" loading="lazy"%s>\n',
            esc(photo), esc(paste("Photograph of", p$name)), focus),
    '<div class="chf-card-body">\n',
    sprintf('<p class="chf-card-name">%s</p>\n', esc(p$name)),
    sprintf('<p class="chf-card-role">%s</p>\n', esc(role)),
    if (nzchar(qual_html))   paste0(qual_html,   "\n") else "",
    if (nzchar(detail_html)) paste0(detail_html, "\n") else "",
    if (nzchar(email_html))  paste0(email_html,  "\n") else "",
    if (nzchar(extra))       paste0(extra,       "\n") else "",
    '</div>\n',
    if (nzchar(chf_links(p$links))) paste0(chf_links(p$links), "\n") else "",
    '</div>'
  )
}

#' Emit a grid of person cards.
chf_people_grid <- function(people, kind) {
  if (length(people) == 0) {
    cat('<p class="chf-meta">No entries yet.</p>\n')
    return(invisible(NULL))
  }
  cat('<div class="chf-grid">\n')
  for (p in people) cat(chf_person_card(p, kind), "\n")
  cat('</div>\n')
  invisible(NULL)
}


# ── Board ─────────────────────────────────────────────────────────────────

#' Emit the Board table.
#'
#' Driven from _board.yml rather than a markdown table so that the "Board as at"
#' stamp tracks actual membership changes — with the table inline in the .qmd, a
#' typo fix anywhere on the page would silently re-date the Board.
#'
#' @param board entries from _board.yml, each with `name` and `position`
chf_board_table <- function(board) {

  if (length(board) == 0) {
    cat('<p class="chf-meta">No members listed.</p>\n')
    return(invisible(NULL))
  }

  # Flush-left, as elsewhere in this file — indentation would make Pandoc read
  # the block as an indented code block and escape it into a <pre>.
  cat('<table class="chf-board">\n<thead>\n<tr>\n')
  cat('<th>Member</th>\n<th>Position</th>\n')
  cat('</tr>\n</thead>\n<tbody>\n')
  for (m in board) {
    cat(sprintf('<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>\n',
                esc(m$name), esc(tidy_text(m$position))))
  }
  cat('</tbody>\n</table>\n')
  invisible(NULL)
}


# ── Governance documents ──────────────────────────────────────────────────

#' Emit the governance document list.
#'
#' File size is computed at render rather than stored, so there is one fewer
#' field to keep in sync. Two guardrails fail the build loudly rather than
#' publishing a broken download:
#'   - the PDF named in _documents.yml must exist
#'   - its filename must agree with the declared version
#'
#' @param docs entries from _documents.yml
#' @param dir  directory holding the PDFs, relative to the calling document
chf_doc_list <- function(docs, dir = "../documents") {

  if (length(docs) == 0) {
    cat('<p class="chf-meta">No documents have been published yet.</p>\n')
    return(invisible(NULL))
  }

  cat('<ul class="chf-doclist">\n')
  for (d in docs) {

    path <- file.path(dir, d$file)

    if (!file.exists(path)) {
      stop("Missing document: ", path,
           "\n  Listed in _documents.yml but not present in documents/.",
           call. = FALSE)
    }
    if (!grepl(sprintf("-v%s\\.pdf$", d$version), d$file)) {
      stop("Version mismatch: ", d$file, " is declared as version ", d$version,
           "\n  Filename and `version:` field must agree.", call. = FALSE)
    }

    size <- sprintf("%.0f kB", file.size(path) / 1024)

    # `date` is the approval date and is optional — better to publish a document
    # with no date than to guess one. Omitted dates just drop from the meta line.
    meta <- c(esc(d$doctype), paste("Version", esc(d$version)))
    if (!is.null(d$date) && nzchar(as.character(d$date))) {
      meta <- append(meta, chf_format_date(d$date), after = 2)
    }
    meta <- paste(c(meta, paste0("PDF, ", size)), collapse = " &middot; ")

    # Flush-left, as in chf_person_card — indentation would make Pandoc read
    # this as a code block.
    cat(paste0(
      '<li class="chf-doc">\n',
      sprintf('<a class="chf-doc-title" href="/documents/%s"><i class="fas fa-file-pdf" aria-hidden="true"></i>%s</a>\n',
              esc(d$file), esc(d$title)),
      sprintf('<span class="chf-doc-meta">%s</span>\n', meta),
      sprintf('<p class="chf-doc-summary">%s</p>\n', esc(tidy_text(d$summary))),
      '</li>\n'
    ))
  }
  cat('</ul>\n')
  invisible(NULL)
}
