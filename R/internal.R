#' @importFrom rmarkdown yaml_front_matter
#' @importFrom knitr current_input
#' @export
knitOutputType <- function() {
  output <- rmarkdown::yaml_front_matter(
    knitr::current_input()
  )$output
  if (is.list(output)){
    return(names(output)[1])
  } else {
    return(output[1])
  }
}
