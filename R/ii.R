html_dependency_ionicons <- function() {
  htmltools::htmlDependency("ionicons", "2.0.1", src = icon_system_file("fonts/ionicons-2.0.1"),
                            stylesheet = "css/ionicons.min.css")
}

## Generate all functions for all icons

ion_path <- with(html_dependency_ionicons(), paste0(src$file, "/", stylesheet))
ion_cssFile <- tail(suppressWarnings(readLines(ion_path)), 1)
ion_cssRules <- strsplit(ion_cssFile, ".", fixed = TRUE)[[1]]
ion_cssIcons <- ion_cssRules[grepl("content", ion_cssRules)]
ion_iconList <- substr(ion_cssIcons, start = 5, stop = attr(regexpr("^[^:]*",
                                                                  ion_cssIcons), "match.length"))

#' @exportPattern ^ii_
for (icon in ion_iconList) {
  assign(paste0("ii_", gsub("-", "_", icon)), function(...) ii(name = icon,
                                                            ...))
}


#' Insert Icon From ionicons
#'
#' @inheritParams fa
#'
#' @evalRd paste(paste0('\\alias{ii_', gsub('-', '_', ion_iconList), '}'), collapse = '\n')
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


