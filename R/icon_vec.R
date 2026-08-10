#' A vector of icons
#'
#' `icon_vec` is the vctrs-backed vector type produced by combining `icon`
#' objects with [c()] or [rep()]. It stores, for each element, only the two
#' pieces of state that fully determine an icon: the source SVG `path` and
#' the (possibly [icon_style()]-modified) `style` attribute. The full
#' `htmltools` tag is only materialized on demand when the vector is printed,
#' rendered, or converted to tags — see `_dev/vctrs.md` for the design
#' rationale.
#'
#' @param path A character vector of paths to source SVG files.
#' @param style A character vector (recycled to the length of `path`) of
#'   `style` attribute values, or `NA` to use `icon_base_style`.
#'
#' @noRd
new_icon_vec <- function(path = character(), style = character()){
  vctrs::new_rcrd(list(path = path, style = style), class = "icon_vec")
}

#' Materialize every element of an `icon_vec` into `icon` tags
#' @noRd
icon_materialize_all <- function(x){
  Map(icon_materialize, vctrs::field(x, "path"), vctrs::field(x, "style"))
}

#' Coerce a scalar `icon` (or an already-vectorised `icon_vec`) to `icon_vec`
#'
#' Used by `c.icon()`/`rep.icon()` instead of leaning on `vctrs::vec_ptype2()`
#' dispatch on raw `icon` objects directly: an `icon` is, under the hood, a
#' named 3-element `htmltools` tag list (`name`/`attribs`/`children`), and
#' `vctrs` treats a classed list's element names as candidate output names
#' when combining, which crashes when it tries to assign them onto the
#' resulting `icon_vec` record. Casting to `icon_vec` up front sidesteps that
#' entirely — `vctrs::vec_c()`/`vctrs::vec_rep()`/`vctrs::vec_slice()` then
#' only ever see proper `icon_vec` inputs.
#'
#' @noRd
icon_as_icon_vec <- function(x) UseMethod("icon_as_icon_vec")

#' @export
icon_as_icon_vec.icon <- function(x){
  new_icon_vec(path = icon_path(x), style = x$attribs$style %||% NA_character_)
}

#' @export
icon_as_icon_vec.icon_vec <- function(x) x

#' @export
icon_as_icon_vec.default <- function(x) x

#' @export
c.icon <- function(...){
  vctrs::vec_c(!!!lapply(list(...), icon_as_icon_vec))
}

#' @export
c.icon_vec <- c.icon

#' @export
rep.icon <- function(x, ...){
  x <- icon_as_icon_vec(x)
  vctrs::vec_slice(x, rep(seq_len(vctrs::vec_size(x)), ...))
}

#' @export
rep.icon_vec <- rep.icon

#' @importFrom vctrs vec_ptype2
#' @export
vec_ptype2.icon_vec.icon_vec <- function(x, y, ...) new_icon_vec()

#' @importFrom vctrs vec_cast
#' @export
vec_cast.icon_vec.icon_vec <- function(x, to, ...) x

#' @export
format.icon_vec <- function(x, ...){
  path <- vctrs::field(x, "path")
  out <- paste0("<icon:", sub("\\.svg$", "", basename(path)), ">")
  out[is.na(path)] <- NA_character_
  out
}

#' @export
icon_path.icon_vec <- function(x) vctrs::field(x, "path")

#' @exportS3Method htmltools::as.tags
as.tags.icon_vec <- function(x, ...) do.call(htmltools::tagList, icon_materialize_all(x))

#' `pillar` support for `icon_vec` columns in tibbles
#'
#' Registered dynamically in `.onLoad()` (`pillar` is a `Suggests`
#' dependency, not a hard one) rather than exported directly.
#' @noRd
pillar_shaft.icon_vec <- function(x, ...){
  if(!requireNamespace("pillar", quietly = TRUE)){
    return(format(x))
  }
  pillar::new_pillar_shaft_simple(format(x), align = "left")
}
