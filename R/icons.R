#' A vector of icons
#'
#' `icons` is the vctrs-backed vector type returned by every icon accessor,
#' including a single icon (a length-1 `icons` vector). It stores, for each
#' element, only the two pieces of state that fully determine an icon: the
#' source SVG `path` and the (possibly [icon_style()]-modified) `style`
#' attribute. The full
#' `htmltools` tag is only materialized on demand when the vector is printed,
#' rendered, or converted to tags — see `_dev/vctrs.md` for the design
#' rationale.
#'
#' @param path A character vector of paths to source SVG files.
#' @param style A character vector (recycled to the length of `path`) of
#'   `style` attribute values, or `NA` to use `icon_base_style`. Defaults to
#'   `NA`, so callers that only have paths (such as [icon_find()]) can build
#'   an `icons` vector directly, without a separate recycling step.
#'
#' @noRd
new_icons <- function(path = character(), style = character()){
  if(is_empty(style)) style <- NA_character_
  vctrs::new_rcrd(
    list(path = path, style = vctrs::vec_recycle(style, length(path))),
    class = "icons"
  )
}

#' Materialize every element of an `icons` vector into `icon` tags
#' @noRd
icon_materialize_all <- function(x){
  Map(icon_materialize, vctrs::field(x, "path"), vctrs::field(x, "style"))
}

#' @export
c.icons <- function(...){
  # `icons` (a vctrs rcrd) can't carry element `names()` (see
  # `icon_label()` for how identity is recovered instead), so any argument
  # names in `...` - e.g. from `c(fontawesome$rocket, mine = my_icon)` -
  # are dropped here rather than left for `vctrs::vec_c()` to trip over (it
  # errors trying to assign them onto the result: "Can't assign names to a
  # <vctrs_rcrd>").
  vctrs::vec_c(!!!unname(list(...)))
}

#' @export
rep.icons <- function(x, ...){
  vctrs::vec_slice(x, rep(seq_len(vctrs::vec_size(x)), ...))
}

#' @importFrom vctrs vec_ptype2
#' @export
vec_ptype2.icons.icons <- function(x, y, ...) new_icons()

#' @importFrom vctrs vec_cast
#' @export
vec_cast.icons.icons <- function(x, to, ...) x

#' @export
format.icons <- function(x, ...){
  path <- vctrs::field(x, "path")
  out <- paste0("<icon:", sub("\\.svg$", "", basename(path)), ">")
  out[is.na(path)] <- NA_character_
  out
}

#' @export
icon_path.icons <- function(x) vctrs::field(x, "path")

#' @export
icon_label.icons <- function(x) icon_label_path(icon_path(x))

#' @export
icon_uri.icons <- function(x){
  vapply(icon_materialize_all(x), function(icon) icon_svg_uri(format(icon)), character(1))
}

#' @export
as.character.icons <- function(x, ...){
  # Delegates to icon_label() rather than materializing SVG markup: this is
  # the generic, always-safe text representation used by paste(), error
  # messages, and anything that coerces a column to character without
  # knowing it holds icons - notably gt::gt(), which calls as.character()
  # on every body column before any text_transform() runs, and previously
  # errored on an icons column (no vec_cast.character.* was defined, so
  # it fell through to vctrs:::as.character.vctrs_vctr()).
  #
  # This does not collide with as.tags.icons below: is.character() is a
  # primitive type check on storage mode, unaffected by registering this
  # method, and as.tags() dispatches on class directly, so htmltools never
  # consults as.character() to decide how to render an icons vector - it
  # always finds and uses as.tags.icons(). Confirmed empirically (see
  # _dev/vctrs.md): identical tagList() output with and without this method
  # defined.
  #
  # Consumers that want materialized, styled SVG for richer output formats
  # (rather than the plain label) already have a purpose-built,
  # context-aware path of their own - knit_print.icons() for knitr,
  # as.tags.icons() for htmltools/Shiny, and icon_path() fed to
  # gt::text_transform() + gt::local_image() for gt (which already picks
  # the right embedding per output context on its own). Materializing
  # inside as.character() itself isn't a good substitute for those: it has
  # no output-context to branch on, is called from many places that expect
  # cheap plain text (print(), paste(), vec_cast()), and parsing SVG on
  # every implicit coercion would be needless work for callers that never
  # wanted markup in the first place.
  icon_label(x)
}

#' @exportS3Method htmltools::as.tags
as.tags.icons <- function(x, ...) do.call(htmltools::tagList, icon_materialize_all(x))

#' @export
as.list.icons <- function(x, ...){
  # `lapply()`/`vapply()` (used by e.g. Shiny's `isTagLike()`/`isTagList()`
  # to sniff an `icon =` argument) call `as.list()` on any list-typed
  # object before iterating. The default `as.list.vctrs_rcrd()` returns one
  # length-1 `icons` vector per element - still list-typed - so that
  # recurses forever. Returning plain, `html`-marked labels instead bottoms
  # it out: `isTagLike()`'s `isTRUE(attr(x, "html"))` check then reports
  # each element as tag-like without needing to recurse into it. The
  # original, untouched `icons` vector is what actually gets rendered
  # afterwards (via `as.tags.icons()`), so this only affects code that
  # iterates an `icons` vector with `as.list()`/`lapply()`/`vapply()`
  # directly.
  lapply(format(x), structure, html = TRUE)
}

#' `pillar` support for `icons` columns in tibbles
#'
#' Registered dynamically in `.onLoad()` (`pillar` is a `Suggests`
#' dependency, not a hard one) rather than exported directly.
#' @noRd
pillar_shaft.icons <- function(x, ...){
  if(!requireNamespace("pillar", quietly = TRUE)){
    return(format(x))
  }
  pillar::new_pillar_shaft_simple(format(x), align = "left")
}
