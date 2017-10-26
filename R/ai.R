html_dependency_academicons <- function() {
  htmltools::htmlDependency("academicons", "1.8.0", 
    src = icon_system_file("fonts/academicons-1.8.0"), 
    stylesheet = "css/academicons.min.css"
  ) 
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}

#' Insert Icon From Academicons
#' 
#' @inheritParams fa
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


