html_dependency_fa <- function() {
  htmltools::htmlDependency("font-awesome", "4.7.0", src = icon_system_file("fonts/font-awesome-4.7.0"),
      stylesheet = "css/font-awesome.min.css")
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}

## Generate all functions for all icons

path <- with(html_dependency_fa(), paste0(src$file, "/", stylesheet))
cssFile <- tail(readLines(path), 1)
cssRules <- strsplit(cssFile, ".", fixed = TRUE)[[1]]
cssIcons <- cssRules[grepl("content", cssRules)]
iconList <- substr(cssIcons, start = 4, stop = attr(regexpr("^[^:]*", cssIcons),
    "match.length"))

#' Font awesome alias
#'
#' @rdname fa-alias
#' @name fa-alias
#' @usage NULL
NULL

#' @evalRd paste("\\keyword{internal}", paste0('\\alias{fa_', gsub('-', '_', iconList), '}'), collapse = '\n')
#' @name fa-alias
#' @rdname fa-alias
#' @exportPattern ^fa_
for (icon in iconList) {
  assign(paste0("fa_", gsub("-", "_", icon)), function(...) fa(name = icon,
      ...))
}


#' Insert Icon From Font Awesome
#'
#' Inserts the icon with given name into R Markdown
#'
#' @param name The name of the icon
#' @param size Size of the icon relative to font size. Options are 1, lg (33%
#' increase), 2, 3, 4, or 5.
#' @param fixed_width If true, icons are set to a fixed width
#' @param animate Options are 'still', 'spin', or 'pulse'.
#' @param rotate Options are 0, 90, 180, or 270.
#' @param flip Options are 'none', 'horizontal', 'vertical'.
#' @param border If true, draws a border around the icon.
#' @param pull Pulls icon to either 'left' or 'right' and wraps proceeding text
#' around it.
#' @param other Character vector of other parameters directly added to the icon classes
#'
#' @rdname fa
#'
#'
#' @export
fa <- function(name = "rocket", size = 1, fixed_width = FALSE, animate = "still",
    rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL) {

  result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
      animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
      other = other)), class = c("icon_fa", "icon"))
  out <- knitr::knit_print(result)
  class(out) <- c(class(out), "knit_icon")
  out
}

