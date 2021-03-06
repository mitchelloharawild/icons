#' @param version Version of the library
#' @rdname academicons
#' @export
download_academicons <- function(version = "dev"){
  if(version == "dev"){
    url <- "https://github.com/jpswalsh/academicons/archive/master.zip"
  }
  else{
    url <- glue("https://github.com/jpswalsh/academicons/archive/{version}.zip")
  }

  install_icon_zip(
    "academicons", url, "svg",
    meta = "package.json"
  )
  icons <- list.files(icon_table$academicons$table$path,
                      pattern = "svg$", full.names = TRUE)
  lapply(icons, function(path) {
    x <- xml2::as_list(xml2::read_xml(path))
    x$svg <- structure(x$svg[names(x$svg) == "g"], viewBox = attr(x$svg, "viewBox"), xmlns="http://www.w3.org/2000/svg")
    xml2::write_xml(xml2::as_xml_document(x), path)
  })

  invisible(academicons)
}

#' Academicons icons
#'
#' Academicons is a specialist icon font for academics. It contains icons for
#' websites and organisations related to academia that are often missing from
#' mainstream font packages. It can be used by itself, but its primary purpose
#' is to be used as a supplementary package alongside a larger icon set.
#'
#' @param name Name of the icon
#' @rdname academicons
#' @export
academicons <- new_icon_set(
  "academicons",
  function(name){
    icon_fn$get(name)
  }
)
