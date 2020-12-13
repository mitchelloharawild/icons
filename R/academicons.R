#' @param version Version of the library
#' @rdname academicons
#' @export
download_academicons <- function(version = "dev"){
  path <- if(version == "dev"){
    "https://raw.githubusercontent.com/jpswalsh/academicons/master"
  }
  else{
    glue("https://raw.githubusercontent.com/jpswalsh/academicons/{version}")
  }
  url <- glue("{path}/fonts/academicons.svg")

  svg <- xml2::as_list(xml2::read_xml(url))$svg
  font <- attributes(svg$defs$font$`font-face`)
  version_url <- glue("{path}/package.json")
  meta <- jsonlite::parse_json(readLines(version_url))

  nm <- lapply(svg$defs$font, attr, "glyph-name")
  is_icon <- !vapply(nm, is.null, logical(1L))

  svg <- svg$defs$font[is_icon]
  paths <- vapply(svg, attr, character(1L), "d")

  svg <- glue(
'<svg xmlns="http://www.w3.org/2000/svg" height="{font$`units-per-em`}" width="{font$`units-per-em`}">
<path transform="scale(1,-1) translate(0,-{font$ascent})" d="{paths}"/>
</svg>')
  path <- icon_path("academicons")

  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  mapply(writeLines, text = svg, con = glue("{file.path(path, nm[is_icon])}.svg"))

  # Create meta
  saveRDS(
    list(name = "Academicons", version = meta$version, licence = meta$license),
    file.path(path, "meta.rds")
  )

  # Update icons
  update_icon("academicons", silent = FALSE)

  invisible(academicons)
}

#' Academicons icons
#'
#' @param name Name of the icon
#' @rdname academicons
#' @export
academicons <- new_icon(
  "academicons",
  function(name){
    icon_fn$get(name)
  }
)
