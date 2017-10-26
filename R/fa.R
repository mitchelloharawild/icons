#' Insert Icon From Font Awesome
#'
#' Inserts the icon with given name into R Markdown
#'
#' @param name The name of the icon
#' @param size Size of the icon relative to font size. Options are lg (33%
#' increase), 2x, 3x, 4x, or 5x.
#'
#' @export

fa <- function(name, size = "default") {

	size_append <- switch(size,
												default = "",
												lg = " fa-lg",
												`2x` = " fa-2x",
												`3x` = " fa-3x",
												`4x` = " fa-4x",
												`5x` = " fa-5x")

	if(knitOutputType() == "pdf_document"){
	  stop("PDF not supported")
	}
	else if(knitOutputType() == "word_document"){
	  warning("Word output not supported")
	}
	else{
	  icon <- htmltools::tags$i(class = paste('fa fa-', name, size_append, sep = ""))
	  header <- htmltools::singleton(htmltools::tags$head(rmarkdown::html_dependency_font_awesome()))
	  htmltools::tagList(header, icon)
	}
}
