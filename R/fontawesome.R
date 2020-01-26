#' @param version Version of the library
#' @rdname fontawesome
#' @importFrom utils download.file
#' @export
download_fontawesome <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/FortAwesome/Font-Awesome/archive/master.zip"
    version <- jsonlite::read_json("https://api.github.com/repos/FortAwesome/Font-Awesome/releases/latest")$tag_name
  }
  else{
    url <- glue("https://github.com/FortAwesome/Font-Awesome/archive/{version}.zip")
    version <- package_version(version)
  }

  if(version >= package_version("5.6.0")){
    path <- "svgs"
  }
  else{
    path <- c("advanced-options", "raw-svg")
  }

  install_icon_zip(
    "fontawesome", url, path,
    meta = list(name = "Font Awesome", version = version, licence = "CC BY 4.0")
  )

  invisible(fontawesome)
}

#' Font Awesome icons
#'
#' @param name Name of the icon
#' @param style Style of the icon. If NULL, a default style will be chosen for the specified icon.
#' @rdname fontawesome
#' @export
fontawesome <- new_icon(
  "fontawesome",
  function(name, style = NULL){
    if(is.null(style)){
      icon_find(name, "fontawesome")[[1]]
    } else {
      icon_fn$get(c(style, name))
    }
  }
)
