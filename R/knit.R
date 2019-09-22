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
  else if(out_type == "latex"){
    require_package("rsvg")
    path <- paste0(tempfile(), ".pdf")
    rsvg::rsvg_pdf(charToRaw(format(x)), path)
    knitr::asis_output(
      glue("![](<path>){height=0.7em}", .open = "<", .close = ">")
    )
  }
  else {
    stop("Icons for this format is currently not supported", call = FALSE)
  }
}
