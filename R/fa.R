#' Insert Icon From Font Awesome
#'
#' Inserts the icon with given name into R Markdown
#'
#' @param name The name of the icon
#' @param size Size of the icon relative to font size. Options are lg (33%
#' increase), 2x, 3x, 4x, or 5x.
#'
#' @export

fa <- function(name, size = 1, fixed_width = FALSE) {

	# Determine fa string to use -------------------------------------------------

	size_append <- switch(size,
												`1` = "",
												lg = " fa-lg",
												`2` = " fa-2x",
												`3` = " fa-3x",
												`4` = " fa-4x",
												`5` = " fa-5x")

	if (fixed_width) {
		fw_append <- " fa-fw"
	} else {
		fw_append <- ""
	}

	icon_string <- paste('fa fa-', name, size_append, fw_append, sep = "")

	# ----------------------------------------------------------------------------
	if(knitOutputType() == "pdf_document"){
	  stop("PDF not supported")
	}
	else if(knitOutputType() == "word_document"){
	  warning("Word output not supported")
	}
	else{
	  icon <- htmltools::tags$i(class = icon_string)
	  header <- htmltools::singleton(htmltools::tags$head(rmarkdown::html_dependency_font_awesome()))
	  htmltools::tagList(header, icon)
	}
}