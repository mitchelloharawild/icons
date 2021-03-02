#' Migration tools
#'
#' The icon package has been overhauled to be more efficient and extensible.
#' Unfortunately this has led to several necessary interface changes. To
#' minimise impact, please use the `migrate_icon()` function to update your files
#' to use the new interface.
#'
#' @param path A directory or file to migrate
#' @param ext File extensions to update
#' @param ... Unused.
#'
#' @rdname migration
#' @export
fa <- function(...){
  msg(glue(crayon::red(cli::symbol$warning), "  Updates to the icon package have introduced breaking changes."))
  msg(glue(crayon::blue(cli::symbol$info), "  Refer to the NEWS (https://pkg.mitchelloharawild.com/icons/news/) to read the changes."))
  msg(glue(crayon::green(cli::symbol$star), "  You can use the migration tool `migrate_icon()` to update your documents to this new version."))
  abort("Update to the new interface for the icon package.")
}

#' @rdname migration
#' @export
ii <- fa

#' @rdname migration
#' @export
ai <- fa

#' @rdname migration
#' @export
migrate_icon <- function(path, ext = c(".Rmd", ".R")){
  abort("Not yet implemented.")
}
