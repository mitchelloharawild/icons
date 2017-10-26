#' Insert Icon From Font Awesome
#' 
#' Inserts the icon with given name into R Markdown
#' 
#' @param name The name of the icon
#' 
#' @export

fa <- function(name) {
  string <- paste("<i class='fa fa-", name, "'></i>", sep = "")
  
  structure(string, class = "icon")
}


#' @export
print.icon <- function(x, ...){
	cat(x, "\n")
	invisible(x)
}