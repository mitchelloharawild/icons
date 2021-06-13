#' @param version Version of the library
#' @rdname octicons
#' @export
download_octicons <- function(version = "dev"){
  if(version == "dev"){
    version <- "main"
  }
  url <- glue("https://github.com/primer/octicons/archive/refs/heads/{version}.zip")
  meta <- jsonlite::read_json(
    glue("https://raw.githubusercontent.com/primer/octicons/{version}/package.json")
  )

  install_icon_zip(
    "octicons", url, c("icons"),
    svg_pattern = "-16\\.svg$",svg_dest = octicon_svg_dest,
    meta = list(name = "Octicons", version = meta$version, licence = meta$license)
  )

  invisible(octicons)
}

octicon_svg_dest <- function(svgs){
  file <- basename(svgs)
  gsub("-", "_", gsub("-16\\.svg$", "\\.svg", file))
}

#' GitHub's Octicons
#'
#' @param name Name of the icon
#' @rdname octicons
#'
#' @seealso https://primer.style/octicons/
#'
#' @export
octicons <- new_icon_set(
  "octicons",
  function(name){
    icon_fn$get(name)
  }
)
