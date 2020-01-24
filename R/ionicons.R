#' @param version Version of the library
#' @rdname ionicons
#' @importFrom utils download.file
#' @export
download_ionicons <- function(version = "dev"){
  if(version == "dev"){
    version <- glue("dev ({Sys.Date()})")
    url <- "https://github.com/ionic-team/ionicons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/ionic-team/ionicons/archive/{version}.zip")
  }

  install_icon_zip(
    "ionicons", url, c("src", "svg"),
    meta = list(name = "Ionicons", version = version, licence = "MIT")
  )

  invisible(ionicons)
}

#' Ionicons icons
#'
#' @param name Name of the icon
#' @rdname ionicons
#' @export
ionicons <- new_icon(
  "ionicons",
  function(name){
    icon_fn$get(name)
  }
)
