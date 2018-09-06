#' @importFrom knitr knit_print
#' @export
knit_print.icon <- function(x, ...) {
  if (knitOutputType() %in% c("pdf_document", "beamer", "pdf_document2")) {
    if (length(x$name) > 1) {
      stop("Icons for PDF formats are currently not supported", call = FALSE)
    }
    # knitr::asis_output(paste0("\\includesvg{", x$name, "}"), meta = list(rmarkdown::latex_dependency("svg")))
  } else if (knitOutputType() == "word_document") {
    stop("Icons for word document formats are currently not supported", call = FALSE)
  } else {
    knitr::asis_output(htmltools::htmlPreserve(gsub('"', "'", format(x))))
  }
}

#' @import rappdirs
download_fa <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # List of releases: https://api.github.com/repos/FortAwesome/Font-Awesome/tags
}

#' @import rappdirs
download_ii <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # icon dir: https://github.com/ionic-team/ionicons/tree/master/src/svg
}

#' @import rappdirs
download_ai <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # icon set: https://github.com/jpswalsh/academicons/blob/master/fonts/academicons.svg
}

#' @import rappdirs
download_mdi <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # icon dir: https://github.com/Templarian/MaterialDesign/tree/master/icons/svg
}

#' @import rappdirs
download_feather <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # icon dir: https://github.com/feathericons/feather/tree/master/icons
}

#' @import rappdirs
download_si <- function(x, version = "latest", ...){
  stop("Not yet supported")
  # icon dir: https://github.com/simple-icons/simple-icons/tree/develop/icons
}



#' @importFrom xml2 read_xml
#' @importFrom htmltools tagAppendAttributes
#' @export
read_icon <- function(x, ...){
  xml <- xml2::as_list(read_xml(x, ...))
  icon <- xml_tagList(xml)[["svg"]]
  icon <- tagAppendAttributes(icon, style = "height:1em;position:relative;display: inline-block;")
  add_class(icon, "icon")
}

