html_dependency_fa <- function() {
  htmltools::htmlDependency("font-awesome", "4.7.0", src = icon_system_file("fonts/font-awesome-4.7.0"),
      stylesheet = "css/font-awesome.min.css")
}

## Generate all functions for all icons

path <- with(html_dependency_fa(), paste0(src$file, "/", stylesheet))
cssFile <- tail(readLines(path), 1)
cssRules <- strsplit(cssFile, ".", fixed = TRUE)[[1]]
cssIcons <- cssRules[grepl("content", cssRules)]

#' @rdname fa
#' @export
fa_iconList <- substr(cssIcons, start = 4, stop = attr(regexpr("^[^:]*", cssIcons),
    "match.length"))

#' Font awesome alias
#'
#' @rdname fa-alias
#' @name fa-alias
#' @usage NULL
NULL

#' @evalRd paste("\\keyword{internal}", paste0('\\alias{fa_', gsub('-', '_', fa_iconList), '}'), collapse = '\n')
#' @name fa-alias
#' @rdname fa-alias
#' @exportPattern ^fa_
fa_constructor <- function(...) fa(name = name, ...)
for (icon in fa_iconList) {
  formals(fa_constructor)$name <- icon
  assign(paste0("fa_", gsub("-", "_", icon)), fa_constructor)
}
rm(fa_constructor)


#' Insert icon from font awesome v4.7.0
#'
#' @param name A string indicating the icon name.
#' @param size Size of the icon relative to font size. Options are 1, lg (33%
#' increase), 2, 3, 4, or 5.
#' @param fixed_width If TRUE, the icon is set to a fixed width
#' @param animate 'still', 'spin', or 'pulse'.
#' @param rotate Rotate degree: 0, 90, 180, or 270.
#' @param flip 'none', 'horizontal', 'vertical'.
#' @param border If TRUE, draws a border around the icon.
#' @param pull Pulls icon to either 'left' or 'right' and wraps proceeding text
#' around it.
#' @param other Character vector of other parameters directly added to the icon classes
#'
#' @details `fa_*` is equivalent to `fa(name = *)`, which utilises the auto completion.
#' @references [Font awesome](http://fontawesome.io/icons/)
#'
#' @export
#' @importFrom utils adist
fa <- function(name = "font-awesome", size = 1, fixed_width = FALSE, animate = "still",
    rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL) {
  if(!(name %in% fa_iconList)){
    stop(paste0("Icon '", name, "' not found in font awesome. Did you mean '", fa_iconList[which.min(adist(name, fa_iconList))], "'?"))
  }
  if (interactive()) {
    print(paste0("fa:", name))
  } else {
    result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
        animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
        other = other)), class = c("icon_fa", "icon"))
    out <- knitr::knit_print(result)
    class(out) <- c(class(out), "knit_icon")
    out
  }
}

