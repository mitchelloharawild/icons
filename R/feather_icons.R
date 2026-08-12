#' @param version Version of the library
#' @rdname feather_icons
#' @export
download_feather_icons <- function(version = "dev"){
  if(version == "dev"){
    version <- "master"
  }
  url <- glue("https://github.com/feathericons/feather/archive/{version}.zip")

  meta <- jsonlite::read_json(
    glue("https://raw.githubusercontent.com/feathericons/feather/{version}/package.json")
  )

  if(requireNamespace("gh")) {
    meta <- list(
      version = gh::gh("GET /repos/:owner/:repo/releases/latest", owner="feathericons", repo="feather")$tag_name,
      license = gh::gh("GET /repos/:owner/:repo", owner="feathericons", repo="feather")$license$name
    )
  } else {
    cli::cli_warn(
      c(
        "!" = "Obtaining the most recent version and license automatically requires the {.pkg gh} package.",
        "i" = "Using last known license, which may not be current."
      )
    )
    meta <- list(
      version = version,
      license = "MIT"
    )
  }

  install_icon_zip(
    "feather_icons", url, c("icons"),
    meta = list(name = "Feather Icons", version = meta$version, licence = meta$license)
  )

  invisible(simple_icons)
}

#' Feather Icons
#'
#' @param name Name of the icon
#'
#' @section License:
#' Feather Icons are distributed under the [MIT License](https://github.com/feathericons/feather/blob/main/LICENSE).
#'
#' @return `download_feather_icons()` invisibly returns the `feather_icons`
#'   icon set after downloading and installing its SVG files locally.
#'
#'   `feather_icons(name)` returns an `icon` object (an SVG tag) for the
#'   requested icon.
#'
#' @rdname feather_icons
#' @export
feather_icons <- new_icon_set(
  "feather_icons",
  function(name){
    icon_fn$get(name)
  }
)
