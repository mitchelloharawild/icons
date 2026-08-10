#' Render a single materialized icon for a knitr output format
#'
#' Factored out of `knit_print.icon()` so that `knit_print.icon_vec()` can
#' loop the exact same per-format logic over each materialized element,
#' rather than re-implementing it.
#'
#' @param x A materialized `icon` tag.
#' @param out_type The knitr/pandoc output format, e.g. from
#'   `knitr::opts_knit$get("rmarkdown.pandoc.to")`. Must not be `NULL`.
#'
#' @return A plain string of output markup/markdown for `x`.
#' @importFrom stringr str_extract
#' @noRd
render_icon_output <- function(x, out_type){
  if(out_type %in% c("html", "html4", "html5", "markdown_strict", "slideous",
                     "slidy", "dzslides", "revealjs", "s5")){
    return(gsub('\n', "", format(x)))
  }

  height <- as.numeric(str_extract(
    str_extract(
      x$attribs$style,
      "height:[^;]*;"
    ), "(\\.|\\d)+"
  ))

  if(out_type %in% c("latex", "beamer")){
    require_package("rsvg")
    path <- paste0(tempfile(), ".pdf")
    rsvg::rsvg_pdf(charToRaw(format(x)), path)
    glue("\\protect\\includegraphics[height=<height*0.7>em]{<path>}", .open = "<", .close = ">")
  }
  else if(out_type %in% c("gfm", "gfm-ascii_identifiers", "markdown_github")){
    path <- knitr::fig_path(".svg")
    if(!dir.exists(dirname(path))){
      dir.create(dirname(path))
    }
    writeLines(format(x), path)
    glue('<img src="{path}" height="{height*16}px"/>')
  }
  else {
    require_package("rsvg")
    path <- paste0(tempfile(), ".png")
    rsvg::rsvg_png(charToRaw(format(x)), path)
    glue("![](<path>){height=<height*0.7>em}", .open = "<", .close = ">")
  }
}

icon_out_type <- function(){
  out_type <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  if(is.null(out_type)){
    cli::cli_warn(
      c(
        "!" = "Could not detect output format.",
        "i" = "Please use {.fn rmarkdown::render} to knit the document."
      )
    )
  }
  out_type
}

#' @importFrom knitr knit_print
#' @export
knit_print.icon <- function(x, ...) {
  out_type <- icon_out_type()
  if(is.null(out_type)) return(knitr::asis_output(""))

  knitr::asis_output(render_icon_output(x, out_type))
}

#' @export
knit_print.icon_vec <- function(x, ...) {
  out_type <- icon_out_type()
  if(is.null(out_type)) return(knitr::asis_output(""))

  knitr::asis_output(paste(
    vapply(icon_materialize_all(x), render_icon_output, character(1), out_type = out_type),
    collapse = ""
  ))
}
