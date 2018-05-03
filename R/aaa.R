#' @importFrom utils tail
get_iconList <- function(path, start = 4){
  cssFile <- suppressWarnings(tail(readLines(path), 1))
  cssRules <- strsplit(cssFile, ".", fixed = TRUE)[[1]]
  cssIcons <- cssRules[grepl("content", cssRules)]
  substr(cssIcons, start = start, stop = attr(regexpr("^[^:]*", cssIcons),
                                          "match.length"))
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}
