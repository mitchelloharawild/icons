#' @param version Version of the library
#' @rdname academicons
#' @export
download_academicons <- function(version = "dev"){
  if(version == "dev"){
    version <- glue("dev ({Sys.Date()})")
    url <- "https://raw.githubusercontent.com/jpswalsh/academicons/master/fonts/academicons.svg"
  }
  else{
    url <- glue("https://raw.githubusercontent.com/jpswalsh/academicons/{version}/fonts/academicons.svg")
  }

  svg <- xml2::as_list(xml2::read_xml(url))$svg$defs$font
  nm <- lapply(svg, attr, "glyph-name")
  is_icon <- !vapply(nm, is.null, logical(1L))

  svg <- svg[is_icon]
  paths <- vapply(svg, attr, character(1L), "d")

  svg <- glue('<svg xmlns="http://www.w3.org/2000/svg"><path d="{paths}"/></svg>')
  path <- icon_path("academicons")

  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  mapply(writeLines, text = svg, con = glue("{file.path(path, nm[is_icon])}.svg"))

  # Create meta
  saveRDS(
    list(name = "Academicons", version = version, licence = "SIL OFL 1.1"),
    file.path(path, "meta.rds")
  )

  # Update icons
  update_icon("academicons")

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
