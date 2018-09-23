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


#' Read an individual icon
#'
#' @param x Path to the icon
#'
#' @importFrom xml2 read_xml
#' @importFrom htmltools tagAppendAttributes
#' @export
read_icon <- function(x){
  xml <- xml2::as_list(read_xml(x))
  icon <- xml_tagList(xml)[["svg"]]
  icon <- tagAppendAttributes(icon, style = "height:1em;position:relative;display: inline-block;")
  add_class(icon, "icon")
}

