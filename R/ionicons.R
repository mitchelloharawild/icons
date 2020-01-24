#' @param version Version of the library
#' @rdname ionicons
#' @importFrom utils download.file
#' @export
download_ionicons <- function(version = "dev"){
  # Clone repo
  tmpFile <- tempfile("icon_ionicons")
  dir.create(tmpDir <- tempfile("icon_ionicons"), showWarnings = FALSE)
  on.exit(unlink(c(tmpFile, tmpDir)))

  if(version == "dev"){
    version <- glue("dev ({Sys.Date()})")
    download.file("https://github.com/ionic-team/ionicons/archive/master.zip", tmpFile)
  }
  else{
    download.file(glue("https://github.com/ionic-team/ionicons/archive/{version}.zip"), tmpFile)
  }

  # Find icons
  utils::unzip(tmpFile, exdir = tmpDir)
  path <- file.path(list.dirs(tmpDir, recursive = FALSE), "src", "svg")
  files <- list_svg(path, recursive = TRUE, full.names = TRUE)

  # Copy icons
  dest_dir <- icon_path("ionicons")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  file.copy(
    list_svg(path, recursive = TRUE, full.names = TRUE),
    file.path(dest_dir, basename(files)),
    overwrite = TRUE
  )
  saveRDS(
    list(name = "Ionicons", version = version, licence = "MIT"),
    file.path(dest_dir, "meta.rds")
  )

  # Update icon set
  update_icon("ionicons")

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
