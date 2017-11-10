html_dependency_ionicons <- function() {
  htmltools::htmlDependency("ionicons", "2.0.1", src = icon_system_file("fonts/ionicons-2.0.1"),
                            stylesheet = "css/ionicons.min.css")
}

## Generate all functions for all icons

ion_path <- with(html_dependency_ionicons(), paste0(src$file, "/", stylesheet))
ion_cssFile <- tail(suppressWarnings(readLines(ion_path)), 1)
ion_cssRules <- strsplit(ion_cssFile, ".", fixed = TRUE)[[1]]
ion_cssIcons <- ion_cssRules[grepl("content", ion_cssRules)]

#' @rdname ii
#' @export
ii_iconList <- substr(ion_cssIcons, start = 5, stop = attr(regexpr("^[^:]*",
                                                                  ion_cssIcons), "match.length"))

#' Ionicons alias
#'
#' @rdname ii-alias
#' @name ii-alias
#' @usage NULL
NULL

#' @evalRd paste("\\keyword{internal}", paste0('\\alias{ii_', gsub('-', '_', ii_iconList), '}'), collapse = '\n')
#' @name ii-alias
#' @rdname ii-alias
#' @exportPattern ^ii_
ii_constructor <- function(...) ii(name = name, ...)
for (icon in ii_iconList) {
  formals(ii_constructor)$name <- icon
  assign(paste0("ii_", gsub("-", "_", icon)), ii_constructor)
}
rm(ii_constructor)

#' Insert icon from ionicons v2.0.1
#'
#' @inheritParams fa
#'
#' @export
#' @importFrom utils adist
ii <- function(name = "ionic", size = 1, fixed_width = FALSE, animate = "still",
               rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL) {
  if(!(name %in% ii_iconList)){
    stop(paste0("Icon '", name, "' not found in ionicons. Did you mean '", ii_iconList[which.min(adist(name, ii_iconList))], "'?"))
  }
  if (interactive()) {
    print(paste0("ion:", name))
  } else {
    result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
                                                         animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
                                                         other = other)), class = c("icon_ii", "icon"))
    out <- knitr::knit_print(result)
    class(out) <- c(class(out), "knit_icon")
    out
  }
}


