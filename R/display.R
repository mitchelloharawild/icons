msg <- function(..., startup = FALSE) {
  if (startup) {
    if (!isTRUE(getOption("icon.quiet"))) {
      packageStartupMessage(text_col(...))
    }
  } else {
    message(text_col(...))
  }
}

text_col <- function(x) {
  # If RStudio not available, messages already printed in black
  if (!rstudioapi::isAvailable()) {
    return(x)
  }

  if (!rstudioapi::hasFun("getThemeInfo")) {
    return(x)
  }

  theme <- rstudioapi::getThemeInfo()

  if (isTRUE(theme$dark)) crayon::white(x) else crayon::black(x)
}

format_version <- function(x) {
  version <- as.character(unclass(x)[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- crayon::red(as.character(version[4:length(version)]))
  }
  paste0(version, collapse = ".")
}

icon_attach <- function() {
  msg(
    cli::rule(
      left = crayon::bold("Installed icons"),
      right = paste0("icon ", format_version(utils::packageVersion("icons")))
    ),
    startup = TRUE
  )

  versions <- vapply(
    icon_table,
    function(x){
      if(!is.null(x$table$meta$version)){
        format_version(package_version(x$table$meta$version))
      } else ""
    },
    character(1)
  )
  available <- vapply(icon_table, function(x) dir.exists(x$table$path), logical(1L))

  icons <- paste0(
    ifelse(available, crayon::green(cli::symbol$tick), crayon::red(cli::symbol$cross)),
    " ", crayon::col_align(crayon::blue(names(icon_table)), max(crayon::col_nchar(names(icon_table)))), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  if (length(icons) %% 2 == 1) {
    icons <- append(icons, "")
  }
  col1 <- seq_len(length(icons) / 2)
  info <- paste0(icons[col1], "     ", icons[-col1])

  msg(paste(info, collapse = "\n"), startup = TRUE)

  # suppressPackageStartupMessages(
  #   lapply(to_load, same_library)
  # )

  invisible()
}
