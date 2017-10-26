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


#' @importFrom knitr asis_output
knit_print.icon_fa <- function(x, ...){
  ## Class icon:
  ### - fa
  ### - rocket
  ### - 2x
  if(knitOutputType() %in% c("pdf_document", "beamer", "pdf_document2")){
    knitr::asis_output(paste0("\\faicon{", x$name, "}"),
                       meta = list(
                         rmarkdown::latex_dependency("fontawesome")
                       ))
  }
  else if(knitOutputType() == "word_document"){
    message("😞")
  }
  else { # HTML output
    message("😞")
  }
}

#' @export
fa2 <- function(name, opts = NULL){
  structure(list(name = name, options = list(opts)), class="icon_fa")
}
