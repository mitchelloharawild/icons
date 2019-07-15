#' @importFrom knitr knit_print
#' @export
knit_print.icon <- function(x, ...) {
  out_type <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  if(is.null(out_type)){
    warn("Could not detect output format, please use `rmarkdown::render()` to knit the document.")
    return(knitr::asis_output(""))
  }
  if(out_type == "html"){
    knitr::asis_output(htmltools::htmlPreserve(gsub('"', "'", format(x))))
  }
  else if(out_type == "pdf"){
    stop("Icons for PDF formats are currently not supported", call = FALSE)
  }
  else {
    stop("Icons for this format is currently not supported", call = FALSE)
  }
}
