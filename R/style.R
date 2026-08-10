#' Customise the style of an icon
#' @param x The icon to style.
#' @param scale Scaled size of the icon.
#' @param fill The colour for the fill.
#' @param rotate The angle to rotate the icon.
#' @param ... Other CSS rules for the icon style, for example `float = "right"`.
#'
#' @return The input `x` (an `icon` or `icon_vec`), with its style updated to
#'   reflect the requested styling.
#'
#' @export
icon_style <- function(x, scale = NULL, fill = NULL, rotate = NULL, ...){
  UseMethod("icon_style")
}

#' Compute an updated CSS style string
#'
#' Shared by the scalar (`icon`) and vector (`icon_vec`) methods of
#' [icon_style()]. `style` may be a vector, since `stringr`/`glue` operations
#' below are all vectorised already.
#'
#' @noRd
#' @importFrom stringr str_replace
icon_apply_style <- function(style, scale, fill, rotate, dots){
  if(!is.null(fill)){
    style <- str_replace(style, "fill:[^;]*;", "")
    style <- glue("{style}fill:{fill};")
  }
  if(!is.null(scale)){
    style <- str_replace(style, "height:[^;]*;", "")
    style <- glue("{style}height:{scale}em;")
  }
  if(!is.null(rotate)){
    style <- str_replace(style, "transform: rotate[^;]*;", "")
    style <- glue("{style}transform: rotate({rotate}deg);")
  }
  if(!is_empty(dots)){
    style <- Reduce(f = function(style, modify){
      style <- str_replace(style, glue("{modify[[1]]}:[^;]*;"), "")
      style <- glue("{style}{modify[[1]]}:{modify[[2]]};")
      },
      mapply(list, names(dots), dots, SIMPLIFY = FALSE),
      init = style
    )
  }
  as.character(style)
}

#' @export
icon_style.icon <- function(x, scale = NULL, fill = NULL, rotate = NULL, ...){
  style <- x$attribs$style
  x$attribs$style <- icon_apply_style(style, scale, fill, rotate, list(...))
  x
}

#' @export
icon_style.icon_vec <- function(x, scale = NULL, fill = NULL, rotate = NULL, ...){
  style <- vctrs::field(x, "style")
  style[is.na(style)] <- icon_base_style
  new_icon_vec(
    path = vctrs::field(x, "path"),
    style = icon_apply_style(style, scale, fill, rotate, list(...))
  )
}
