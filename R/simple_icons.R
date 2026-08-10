#' @param version Version of the library
#' @rdname simple_icons
#' @export
download_simple_icons <- function(version = "dev"){
  if(version == "dev"){
    version <- "master"
  }
  url <- glue("https://github.com/simple-icons/simple-icons/archive/{version}.zip")

  meta <- jsonlite::read_json(
    glue("https://raw.githubusercontent.com/simple-icons/simple-icons/{version}/package.json")
  )

  install_icon_zip(
    "simple_icons", url, c("icons"),
    meta = list(name = "Simple Icons", version = meta$version, licence = meta$license)
  )

  invisible(simple_icons)
}

#' Simple Icons
#'
#' @param name Name of the icon
#'
#' @return `download_simple_icons()` invisibly returns the `simple_icons`
#'   icon set after downloading and installing its SVG files locally.
#'
#'   `simple_icons(name)` returns an `icon` object (an SVG tag) for the
#'   requested icon.
#'
#' @rdname simple_icons
#' @export
simple_icons <- new_icon_set(
  "simple_icons",
  function(name){
    icon_fn$get(name)
  }
)
