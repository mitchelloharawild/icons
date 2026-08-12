format_version <- function(x) {
  version <- as.character(unclass(x)[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- cli::col_red(as.character(version[
      4:length(version)
    ]))
  }
  paste0(version, collapse = ".")
}

# rlang::is_interactive() detects most non-interactive sessions (rmd/qmd/...)
# DEVTOOLS_LOAD detects pkgload::load_all() which also covers document()/test()
icon_attach_quiet <- function() {
  isTRUE(getOption("icon.quiet")) ||
    !rlang::is_interactive() ||
    nzchar(Sys.getenv("DEVTOOLS_LOAD"))
}

icon_attach <- function() {
  if (icon_attach_quiet()) {
    return(invisible())
  }

  packageStartupMessage(
    cli::rule(
      left = cli::style_bold("Installed icons"),
      right = paste0("icon ", format_version(utils::packageVersion("icons")))
    )
  )

  versions <- vapply(
    icon_table,
    function(x) {
      if (!is.null(x$table$meta$version)) {
        tryCatch(
          format_version(package_version(x$table$meta$version)),
          error = function(e) x$table$meta$version
        )
      } else {
        ""
      }
    },
    character(1)
  )
  available <- vapply(
    icon_table,
    function(x) dir.exists(x$table$path),
    logical(1L)
  )

  icons <- paste0(
    ifelse(
      available,
      cli::col_green(cli::symbol$tick),
      cli::col_red(cli::symbol$cross)
    ),
    " ",
    cli::ansi_align(
      cli::col_blue(names(icon_table)),
      max(cli::ansi_nchar(names(icon_table)))
    ),
    " ",
    cli::ansi_align(versions, max(cli::ansi_nchar(versions)))
  )

  if (length(icons) %% 2 == 1) {
    icons <- append(icons, "")
  }
  col1 <- seq_len(length(icons) / 2)
  info <- paste0(icons[col1], "     ", icons[-col1])

  packageStartupMessage(paste(info, collapse = "\n"))

  if (!any(available)) {
    packageStartupMessage(
      cli::format_inline(
        "{cli::col_yellow(cli::symbol$warning)} No icons are currently available, start by downloading icons with {.fn download_*}."
      )
    )
  }
  invisible()
}
