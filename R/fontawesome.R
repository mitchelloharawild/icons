#' @param version Version of the library
#' @rdname fontawesome
#' @importFrom utils download.file
#' @export
download_fontawesome <- function(version = "dev"){
  # Clone repo
  tmpFile <- tempfile("icon_fontawesome")
  dir.create(tmpDir <- tempfile("icon_fontawesome"), showWarnings = FALSE)
  on.exit(unlink(c(tmpFile, tmpDir)))
  if(version == "dev"){
    version <- glue("dev ({Sys.Date()})")
    download.file("https://github.com/FortAwesome/Font-Awesome/archive/master.zip", tmpFile)
  }
  else{
    download.file(glue("https://github.com/FortAwesome/Font-Awesome/archive/{version}.zip"), tmpFile)
    version <- package_version(version)
  }

  # Find icons
  utils::unzip(tmpFile, exdir = tmpDir)

  if(grepl("dev", version) || version >= package_version("5.6.0")){
    path <- file.path(list.dirs(tmpDir, recursive = FALSE), "svgs")
  }
  else{
    path <- file.path(list.dirs(tmpDir, recursive = FALSE), "advanced-options", "raw-svg")
  }

  # Copy icons
  dest_dir <- icon_path("fontawesome")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  file.copy(list.dirs(path), dest_dir, recursive = TRUE)

  saveRDS(
    list(name = "Font Awesome", version = version, licence = "CC BY 4.0"),
    file.path(dest_dir, "meta.rds")
  )

  # Update icon set
  get_env(fontawesome)[["icon_fn"]][["update"]](icon_path("fontawesome"), meta = icon_meta("fontawesome"))

  invisible(fontawesome)
}

#' Font Awesome icons
#'
#' @param name Name of the icon
#' @param style Style of the icon. If NULL, a default style will be chosen for the specified icon.
#' @rdname fontawesome
#' @export
fontawesome <- new_icon(
  function(name, style = NULL){
    icon_fn$get(c(style, name))
  }
)
