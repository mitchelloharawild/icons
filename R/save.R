#' Save icons into a local path
#'
#' Store icons in a local directory to simplify sharing of documents containing
#' icons. Bundling icons with your document or app avoids the need for
#' collaborators or servers to have all icons from a library installed.
#'
#' @param icons A named list of icons, the names specify the icon's name in the new icon set.
#' @param path A directory to save the icons into.
#'
#' @return Invisibly, the `icon_set` created from the newly saved SVG files
#'   at `path`.
#'
#' @export
#' @examples
#' if(icon_installed(fontawesome) && icon_installed(ionicons)){
#'
#' path <- tempfile()
#' dir.create(path)
#' icon_save(
#'   list(arrow = fontawesome$solid$`arrow-right`, alarm = ionicons$alarm),
#'   path = path
#' )
#'
#' app_icons <- icon_set(path)
#' app_icons$arrow
#'
#' }
#'
icon_save <- function(icons, path = "."){
  if(!is.list(icons)){
    cli::cli_abort("{.arg icons} must be a list.", call = NULL)
  }
  if(is.null(names(icons))){
    cli::cli_abort(
      c(
        "x" = "{.arg icons} must be named.",
        "i" = "Names are used to identify the icons in the new set."
      ),
      call = NULL
    )
  }
  mapply(function(x, nm){
    writeLines(
      format(icon_materialize_all(x)[[1]]),
      paste0(file.path(normalizePath(path), nm), ".svg")
    )
  }, x = icons, nm = names(icons))
  invisible(icon_set(path))
}
