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

  meta <- jsonlite::read_json("https://raw.githubusercontent.com/google/material-design-icons/master/package.json")

  install_icon_zip(
    "material_design", url, c("svg"),
    meta = list(name = "Material Design Icons", version = meta$version, licence = meta$license)
  )

  invisible(material_design)
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
