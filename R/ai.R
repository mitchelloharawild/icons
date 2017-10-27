html_dependency_academicons <- function() {
  htmltools::htmlDependency("academicons", "1.8.0",
    src = icon_system_file("fonts/academicons-1.8.0"),
    stylesheet = "css/academicons.min.css"
  )
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}


## Generate all functions for all icons

#' @exportPattern ^ai_
ai_path <- with(html_dependency_academicons(), paste0(src$file, "/", stylesheet))
ai_cssFile <- tail(suppressWarnings(readLines(ai_path)),1)
ai_cssRules <- strsplit(ai_cssFile, ".", fixed=TRUE)[[1]]
ai_cssIcons <- ai_cssRules[grepl("content", ai_cssRules)]
ai_iconList <- substr(ai_cssIcons, start = 4, stop = attr(regexpr("^[^:]*", ai_cssIcons), "match.length"))
for(icon in ai_iconList){
  assign(paste0("ai_", gsub("-", "_", icon)), function(...) ai(name = icon, ...))
}


#' Insert Icon From Academicons
#'
#' @inheritParams fa
#'
#' @evalRd paste(paste0("\\alias{ai_", gsub("-", "_", ai_iconList), "}"), collapse = "\n")
#'
#' @export
ai <- function(name = "open-access", size = 1, fixed_width = FALSE, animate = "still",
							 rotate = 0, flip = "none", border = FALSE, pull = NULL) {

	result <- structure(list(
    name = name,
    options = list(size = size,
			fixed_width = fixed_width,
      animate = animate,
      rotate = rotate,
      flip = flip,
      border = border,
      pull = pull
    )
	), class = "icon_ai")
  knitr::knit_print(result)
}


