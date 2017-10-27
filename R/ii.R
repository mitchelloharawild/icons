html_dependency_ionicons <- function() {
  htmltools::htmlDependency("ionicons", "2.0.1", src = icon_system_file("fonts/ionicons-2.0.1"),
                            stylesheet = "css/ionicons.min.css")
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}


## Generate all functions for all icons

#' @exportPattern ^ii_
ii_path <- with(html_dependency_ionicons(), paste0(src$file, "/", stylesheet))
ii_cssFile <- tail(suppressWarnings(readLines(ii_path)), 1)
ii_cssRules <- strsplit(ii_cssFile, ".", fixed = TRUE)[[1]]
ii_cssIcons <- ii_cssRules[grepl("content", ii_cssRules)]
ii_iconList <- substr(ii_cssIcons, start = 5, stop = attr(regexpr("^[^:]*",
                                                                  ii_cssIcons), "match.length"))
for (icon in ii_iconList) {
  assign(paste0("ii_", gsub("-", "_", icon)), function(...) ii(name = icon,
                                                            ...))
}


#' Insert Icon From ionicons
#'
#' @inheritParams fa
#'
#' @evalRd paste(paste0('\\alias{ii_', gsub('-', '_', ii_iconList), '}'), collapse = '\n')
#'
#' @export
ii <- function(name = "ionic", size = 1, fixed_width = FALSE, animate = "still",
               rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL) {

  result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
                                                       animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
                                                       other = other)), class = c("icon_ii", "icon"))
  out <- knitr::knit_print(result)
  class(out) <- c(class(out), "knit_icon")
  out
}


