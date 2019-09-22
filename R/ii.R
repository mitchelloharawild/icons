#' @param version Version of the library
#' @rdname ii
#' @importFrom utils download.file
#' @export
download_ii <- function(x, version = "dev", ...){
  # Clone repo
  tmpFile <- tempfile("icon_ii")
  dir.create(tmpDir <- tempfile("icon_ii"), showWarnings = FALSE)
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
  dest_dir <- icon_path("ii")
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
  get_env(ii)[["icon_fn"]][["update"]](icon_path("ii"), meta = icon_meta("ii"))

  invisible(ii)
}

#' Ionicons icons
#'
#' @param name Name of the icon
#' @rdname ii
#' @export
ii <- NULL
