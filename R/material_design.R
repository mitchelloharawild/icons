#' @param version Version of the library
#' @rdname material_design
#' @export
download_material_design <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/google/material-design-icons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/google/material-design-icons/archive/{version}.zip")
  }

  if(version == "dev" || package_version(version) >= package_version("4.0.0")) {
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
    meta <- jsonlite::read_json(glue("https://raw.githubusercontent.com/google/material-design-icons/{version}/package.json"))
  }

  install_icon_zip(
    "material_design", url, svg_path = mdi_svg_paths(meta$version),
    svg_pattern = "_48px\\.svg", svg_dest = mdi_svg_dest(meta$version),
    meta = list(name = "Material Design Icons", version = meta$version, licence = meta$license)
  )

  invisible(material_design)
}

mdi_svg_paths <- function(path){
  repo_dirs <- list.dirs(list.dirs(path, recursive = FALSE),recursive = FALSE)
  svg_dirs <- Filter(function(x) "svg" %in% basename(list.dirs(x, recursive = FALSE)), repo_dirs)
  file.path(svg_dirs, "svg")
}

mdi_svg_dest <- function(svgs){
  svg_production <- basename(dirname(svgs)) == "production"
  svg_group <- basename(dirname(dirname(dirname(svgs))))
  svg_dest <- rep(NA_character_, length(svgs))
  svg_dest[svg_production] <- file.path(
    svg_group[svg_production],
    gsub("^ic_", "", gsub("_48px\\.svg$", "\\.svg", basename(svgs[svg_production]))))
  svg_dest
}

#' Material design icons
#'
#' @param name Name of the icon
#' @rdname material_design
#' @export
material_design <- new_icon(
  "material_design",
  function(name){
    icon_fn$get(name)
  }
)
