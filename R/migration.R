#' Migration tools
#'
#' The icon package has been overhauled to be more efficient and extensible.
#' Unfortunately this has led to several necessary interface changes. To
#' minimise impact, please use the `migrate_icon()` function to update your files
#' to use the new interface.
#'
#' @param ... Unused.
#'
#' @return These functions do not return; they always signal an error
#'   directing you to the new interface.
#'
#' @rdname migration
#' @export
fa <- function(...){
  cli::cli_abort(
    c(
      "x" = "A rewrite of the icons package has introduced breaking changes.",
      "i" = "Update to the new interface for the icons package.",
      "i" = "Refer to the {.url https://pkg.mitchelloharawild.com/icons/news/} to read the changes."
    ),
    call = NULL
  )
}

#' @rdname migration
#' @export
ii <- fa

#' @rdname migration
#' @export
ai <- fa
