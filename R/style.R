#' Customise the style of an icon
#'
#' @param scale Scaled size of the icon.
#' @param fill The colour for the fill.
#'
#' @export
style <- function(x, scale = NULL, fill = NULL){
  style <- x$attribs$style
  if(!is.null(fill)){
    style <- gsub("fill:[^;]*;", "", style)
    style <- paste0(style, "fill:", fill, ";")
  }
  if(!is.null(scale)){
    style <- gsub("height:[^;]*;", "", style)
    style <- paste0(style, "height:", scale, "em;")
  }
  x$attribs$style <- style
  x
}
