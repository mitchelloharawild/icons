#' @export
style <- function(x, height = NULL, fill = NULL){
  style <- x$attribs$style
  if(!is.null(fill)){
    style <- gsub("fill:[^;]*;", "", style)
    style <- paste0(style, "fill:", fill, ";")
  }
  if(!is.null(height)){
    style <- gsub("height:[^;]*;", "", style)
    style <- paste0(style, "height:", height, "em;")
  }
  x$attribs$style <- style
  x
}
