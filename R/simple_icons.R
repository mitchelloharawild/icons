#' @param version Version of the library
#' @rdname simple_icons
#' @export
download_simple_icons <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/simple-icons/simple-icons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/simple-icons/simple-icons/archive/{version}.zip")
  }

  meta <- jsonlite::read_json("https://raw.githubusercontent.com/simple-icons/simple-icons/master/package.json")

  install_icon_zip(
    "simple_icons", url, c("icons"),
    meta = list(name = "Simple Icons", version = meta$version, licence = meta$license)
  )

  invisible(simple_icons)
}

#' Simple Icons
#'
#' @param name Name of the icon
#' @rdname simple_icons
#' @export
simple_icons <- new_icon(
  "simple_icons",
  function(name){
    icon_fn$get(name)
  }
)
