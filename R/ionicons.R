#' @param version Version of the library
#' @rdname ionicons
#' @importFrom utils download.file
#' @export
download_ionicons <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/ionic-team/ionicons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/ionic-team/ionicons/archive/{version}.zip")
  }

  meta <- jsonlite::read_json("https://raw.githubusercontent.com/ionic-team/ionicons/master/package.json")

  install_icon_zip(
    "ionicons", url, c("src", "svg"),
    meta = list(name = "Ionicons", version = meta$version, licence = meta$license)
  )

  invisible(ionicons)
}

#' Ionicons icons
#'
#' @param name Name of the icon
#'
#' @return `download_ionicons()` invisibly returns the `ionicons` icon set
#'   after downloading and installing its SVG files locally.
#'
#'   `ionicons(name)` returns an `icon` object (an SVG tag) for the
#'   requested icon.
#'
#' @rdname ionicons
#' @export
ionicons <- new_icon_set(
  "ionicons",
  function(name){
    icon_fn$get(name)
  }
)
