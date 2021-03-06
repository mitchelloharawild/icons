#' @param version Version of the library
#' @rdname google_material
#' @export
download_google_material <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/google/material-design-icons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/google/material-design-icons/archive/{version}.zip")
  }

  if(version == "dev" || package_version(version) >= package_version("4.0.0")) {
    svg_ext <- "24px\\.svg"
    if(requireNamespace("gh")) {
      meta <- list(
        version = gh::gh("GET /repos/:owner/:repo/releases/latest", owner="google", repo="material-design-icons")$tag_name,
        license = gh::gh("GET /repos/:owner/:repo", owner="google", repo="material-design-icons")$license$name
      )
    } else {
      rlang::warn("Obtaining the most recent version and license automatically requires the {gh} package installed.
Using last known license, which may not be current.")
      meta <- list(
        version = version,
        license = "Apache License 2.0"
      )
    }
  } else {
    svg_ext <- "_48px\\.svg"
    meta <- jsonlite::read_json(glue("https://raw.githubusercontent.com/google/material-design-icons/{version}/package.json"))
  }

  install_icon_zip(
    "google_material", url, svg_path = mdi_svg_paths(meta$version),
    svg_pattern = svg_ext, svg_dest = mdi_svg_dest(meta$version),
    meta = list(name = "Material Design Icons", version = meta$version, licence = meta$license)
  )

  invisible(google_material)
}

mdi_svg_paths <- function(version) {
  if(package_version(version) >= package_version("4.0.0")) {
    function(path) {
      src_dir <- file.path(list.dirs(path, recursive = FALSE), "src")
      src_dir
    }
  } else {
    function(path){
      repo_dirs <- list.dirs(list.dirs(path, recursive = FALSE),recursive = FALSE)
      svg_dirs <- Filter(function(x) "svg" %in% basename(list.dirs(x, recursive = FALSE)), repo_dirs)
      file.path(svg_dirs, "svg")
    }
  }
}

mdi_svg_dest <- function(version) {
  if(package_version(version) >= package_version("4.0.0")) {
    function(svgs) {
      style <- factor(
        basename(dirname(svgs)),
        levels = c("materialicons", "materialiconsoutlined", "materialiconsround",
                   "materialiconssharp", "materialiconstwotone"),
        labels = c("filled", "outlined", "round", "sharp", "twotone")
      )
      name <- basename(dirname(dirname(svgs)))
      group <- basename(dirname(dirname(dirname(svgs))))
      file.path(style, group, paste0(name, ".svg"))
    }
  } else {
    function(svgs){
      svg_production <- basename(dirname(svgs)) == "production"
      svg_group <- basename(dirname(dirname(dirname(svgs))))
      svg_dest <- rep(NA_character_, length(svgs))
      svg_dest[svg_production] <- file.path(
        svg_group[svg_production],
        gsub("^ic_", "", gsub("_48px\\.svg$", "\\.svg", basename(svgs[svg_production]))))
      svg_dest
    }
  }
}

#' Google's Material design icons
#'
#' @param name Name of the icon
#' @param category The icon's category, either "action", "alert", "av",
#'   "communication", "content", "device", "editor", "file", "hardware", "home",
#'   "image", "maps", "navigation", "notification", "places", "social", or
#'   "toggle"
#' @param theme The style variant for the icon, requires v4.0.0 or greater.
#'   Available themes vary by icon, but can be either "filled", "outlined",
#'   "round", "sharp", or "twotone". If NULL, it will default to the
#'   first available variant in this order.
#'
#' @seealso https://material.io/resources/icons/
#'
#' @rdname google_material
#' @export
google_material <- new_icon_set(
  "google_material",
  function(name, category = NULL, theme = NULL){
    if(is.null(category)){
      x <- icon_find(name, "google_material")
      if(is.null(theme)) {
        x[[1]]
      } else {
        if(length(pos <- which(grepl(theme, names(x), fixed = TRUE))) != 1) {
          abort("Could not find this specific icon from google_material.")
        }
        x[[pos]]
      }
    } else {
      icon_fn$get(c(theme, category, name))
    }
  }
)
