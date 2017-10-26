#' Insert Icon From Font Awesome
#'
#' Inserts the icon with given name into R Markdown
#'
#' @param name The name of the icon
#' @param size Size of the icon relative to font size. Options are 1, lg (33%
#' increase), 2, 3, 4, or 5.
#' @param fixed_width If true, icons are set to a fixed width
#' @param animate Options are "still", "spin", or "pulse".
#' @param rotate Options are 0, 90, 180, or 270.
#' @param flip Options are "none", "horizontal", "vertical".
#' @param border If true, draws a border around the icon.
#' @param pull Pulls icon to either "left" or "right" and wraps proceeding text 
#' around it.
#'
#' @export

fa <- function(name, size = 1, fixed_width = FALSE, animate = "still", 
							 rotate = 0, flip = "none", border = FALSE, pull = NULL) {

	structure(list(name = name, 
								 options = list(size = size, 
								 								fixed_width = fixed_width, 
								 								animate = animate, 
								 								rotate = rotate, 
								 								flip = flip, 
								 								border = border, 
								 								pull = pull)
								 ), 
						class = "icon_fa")
}


