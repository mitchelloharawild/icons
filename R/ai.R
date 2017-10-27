html_dependency_academicons <- function() {
  htmltools::htmlDependency("academicons", "1.8.0", src = icon_system_file("fonts/academicons-1.8.0"),
      stylesheet = "css/academicons.min.css")
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}


## Generate all functions for all icons

ac_path <- with(html_dependency_academicons(), paste0(src$file, "/", stylesheet))
ac_cssFile <- tail(suppressWarnings(readLines(ac_path)), 1)
ac_cssRules <- strsplit(ac_cssFile, ".", fixed = TRUE)[[1]]
ac_cssIcons <- ac_cssRules[grepl("content", ac_cssRules)]
ac_iconList <- substr(ac_cssIcons, start = 4, stop = attr(regexpr("^[^:]*",
    ac_cssIcons), "match.length"))

#' @evalRd paste("\\keyword{internal}", paste0('\\alias{ai_', gsub('-', '_', ac_iconList), '}'), collapse = '\n')
#' @exportPattern ^ai_
for (icon in ac_iconList) {
  assign(paste0("ai_", gsub("-", "_", icon)), function(...) ai(name = icon,
      ...))
}


#' Insert Icon From Academicons
#'
#' @inheritParams fa
#'
#' @references [Academicons](http://jpswalsh.github.io/academicons/)
#' @export
ai <- function(name = "open-access", size = 1, fixed_width = FALSE, animate = "still",
  rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL) {

  result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
      animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
      other = other)), class = c("icon_ai", "icon"))
  out <- knitr::knit_print(result)
  class(out) <- c(class(out), "knit_icon")
  out
}


