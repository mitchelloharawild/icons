font_style <- function(x){
  out <- NULL
  if(!is.null(x$options$colour)){
    out <- paste0(out, "color:", x$options$colour,";")
  }
  out
}
