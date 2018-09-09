knitOutputType <- function() {
  output <- tryCatch(
    rmarkdown::yaml_front_matter(knitr::current_input())$output,
    error = function(e) "console"
  )
  if (is.list(output)) {
    return(names(output)[1])
  } else if (length(output) == 0) {
    return("unknown_document")
  } else {
    return(output[1])
  }
}

#' @importFrom knitr knit_print
#' @export
knit_print.icon <- function(x, ...) {
  if (knitOutputType() %in% c("pdf_document", "beamer", "pdf_document2")) {
    if (length(x$name) > 1) {
      stop("Icons for PDF formats are currently not supported", call = FALSE)
    }
    # knitr::asis_output(paste0("\\includesvg{", x$name, "}"), meta = list(rmarkdown::latex_dependency("svg")))
  } else if (knitOutputType() == "word_document") {
    stop("Icons for word document formats are currently not supported", call = FALSE)
  } else {
    knitr::asis_output(htmltools::htmlPreserve(gsub('"', "'", format(x))))
  }
}
