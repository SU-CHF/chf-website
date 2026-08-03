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
    sprintf('<img src="%s" alt="%s" loading="lazy">\n',
            esc(photo), esc(paste("Photograph of", p$name))),
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
    when <- trimws(format(as.Date(d$date), "%e %B %Y"))

    # Flush-left, as in chf_person_card — indentation would make Pandoc read
    # this as a code block.
    cat(paste0(
      '<li class="chf-doc">\n',
      sprintf('<a class="chf-doc-title" href="/documents/%s"><i class="fas fa-file-pdf" aria-hidden="true"></i>%s</a>\n',
              esc(d$file), esc(d$title)),
      sprintf('<span class="chf-doc-meta">%s &middot; Version %s &middot; %s &middot; PDF, %s</span>\n',
              esc(d$doctype), esc(d$version), when, size),
      sprintf('<p class="chf-doc-summary">%s</p>\n', esc(tidy_text(d$summary))),
      '</li>\n'
    ))
  }
  cat('</ul>\n')
  invisible(NULL)
}
