#' @importFrom knitr knit_print
#' @importFrom stringr str_extract
#' @export
knit_print.icon <- function(x, ...) {
  out_type <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  if(is.null(out_type)){
    warn("Could not detect output format, please use `rmarkdown::render()` to knit the document.")
    return(knitr::asis_output(""))
  }
  if(out_type == "html"){
    return(knitr::asis_output(htmltools::htmlPreserve(gsub('"', "'", format(x)))))
  }

  height <- as.numeric(str_extract(
    str_extract(
      x$attribs$style,
      "height:[^;]*;"
    ), "(\\.|\\d)+"
  ))

  if(out_type == "latex"){
    require_package("rsvg")
    path <- paste0(tempfile(), ".pdf")
    rsvg::rsvg_pdf(charToRaw(format(x)), path)
    knitr::asis_output(
      glue("![](<path>){height=<height*0.7>em}", .open = "<", .close = ">")
    )
  }
  else if(out_type == "docx"){
    require_package("rsvg")
    path <- paste0(tempfile(), ".png")
    rsvg::rsvg_png(charToRaw(format(x)), path)
    knitr::asis_output(
      glue("![](<path>){height=<height*0.7>em}", .open = "<", .close = ">")
    )
  }
  else if(out_type == "gfm-ascii_identifiers"){
    path <- knitr::fig_path(".svg")
    writeLines(format(x), path)
    knitr::asis_output(
      glue("![](<path>){height=<height>em}", .open = "<", .close = ">")
    )
    knitr::asis_output(
      glue('<img src="{path}" height="{height*16}px"/>')
    )
  }
  else {
    stop("Icons for this format is currently not supported", call = FALSE)
  }
}
