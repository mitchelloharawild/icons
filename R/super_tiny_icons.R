#' @param version Version of the library
#' @rdname super_tiny_icons
#' @export
download_super_tiny_icons <- function(version = "dev"){
  if(version == "dev"){
    version <- "master"
  }
  url <- glue("https://github.com/edent/SuperTinyIcons/archive/{version}.zip")

  meta <- jsonlite::read_json(
    glue("https://raw.githubusercontent.com/edent/SuperTinyIcons/{version}/package.json")
  )

  install_icon_zip(
    "super_tiny_icons", url, c("images", "svg"),
    meta = list(name = "Super Tiny Icons", version = meta$version, licence = meta$license)
  )

  invisible(super_tiny_icons)
}

#' Super Tiny Icons
#'
#' @description Super Tiny Icons are miniscule SVG versions of popular website
#'   and app logos, each under 1KB in size.
#'
#' @param name Name of the icon
#'
#' @seealso <https://github.com/edent/SuperTinyIcons>
#'
#' @section License:
#' The project's own icons are dual-licensed by the author under the
#' [MIT License](https://github.com/edent/SuperTinyIcons/blob/master/LICENSE)
#' and [CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/).
#' Many icons are adapted from third-party logos that carry their own
#' licenses (and some depict trademarks), so check the source noted for an
#' icon before reusing it - see the project's
#' [licenses list](https://github.com/edent/SuperTinyIcons#licenses) for details.
#'
#' @return `download_super_tiny_icons()` invisibly returns the
#'   `super_tiny_icons` icon set after downloading and installing its SVG
#'   files locally.
#'
#'   `super_tiny_icons(name)` returns an `icons` vector (an SVG tag) for the
#'   requested icon.
#'
#' @rdname super_tiny_icons
#' @export
super_tiny_icons <- new_icon_set(
  "super_tiny_icons",
  function(name){
    icon_fn$get(name)
  }
)
