#' Customise the style of an icon
#' @param x The icon to style.
#' @param scale Scaled size of the icon.
#' @param fill The colour for the fill.
#' @param ... Other CSS rules for the icon style.
#'
#' @importFrom stringr str_replace
#' @export
icon_style <- function(x, scale = NULL, fill = NULL, ...){
  style <- x$attribs$style
  if(!is.null(fill)){
    style <- str_replace(style, "fill:[^;]*;", "")
    style <- glue("{style}fill:{fill};")
  }
  if(!is.null(scale)){
    style <- str_replace(style, "height:[^;]*;", "")
    style <- glue("{style}height:{scale}em;")
  }
  dots <- list(...)
  if(!is_empty(dots)){
    style <- Reduce(f = function(style, modify){
      style <- str_replace(style, glue("{modify[[1]]}:[^;]*;"), "")
      style <- glue("{style}{modify[[1]]}:{modify[[2]]};")
      },
      mapply(list, names(dots), dots, SIMPLIFY = FALSE),
      init = style
    )
  }
  x$attribs$style <- style
  x
}
