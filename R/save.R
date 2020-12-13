#' Save icons into a local path
#'
#' Store icons in a local directory to simplify sharing of documents containing
#' icons. Bundling icons with your document or app avoids the need for
#' collaborators or servers to have all icons from a library installed.
#'
#' @param icons A named list of icons, the names specify the icon's name in the new icon set.
#' @param path A directory to save the icons into.
#'
#' @export
#' @examples
#' if(icon_installed(fontawesome) && icon_installed(ionicons)){
#'
#' icon_save(
#'   list(arrow = fontawesome$solid$`arrow-right`, alarm = ionicons$alarm),
#'   path = "icons"
#' )
#'
#' app_icons <- icon_set("icons")
#' app_icons$arrow
#'
#' }
#'
icon_save <- function(icons, path = "."){
  stopifnot(is.list(icons))
  if(is.null(names(icons))) stop("The icon list must be named to identify the names of icons in the new set.")
  mapply(function(x, nm){
    writeLines(
      format(x),
      paste0(file.path(normalizePath(path), nm), ".svg")
    )
  }, x = icons, nm = names(icons))
  invisible(icon_set(path))
}
