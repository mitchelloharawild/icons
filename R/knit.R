#' Render a single materialized icon for a knitr output format
#'
#' Used by `knit_print.icons()` to loop the same per-format logic over
#' each materialized element.
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
    path <- icon_fig_path(".pdf")
    rsvg::rsvg_pdf(charToRaw(format(x)), path)
    glue("\\protect\\includegraphics[height=<height*0.7>em]{<path>}", .open = "<", .close = ">")
  }
  else if(grepl("^(gfm|markdown_github)", out_type)){
    path <- icon_fig_path(".svg")
    writeLines(format(x), path)
    glue('<img src="{path}" height="{height*16}px"/>')
  }
  else {
    require_package("rsvg")
    path <- icon_fig_path(".png")
    rsvg::rsvg_png(charToRaw(format(x)), path)
    glue("![](<path>){height=<height*0.7>em}", .open = "<", .close = ">")
  }
}

#' A counter for unique icon figure filenames within a render session
#'
#' `knitr::fig_path()`'s own "-<n>" suffix comes from the `fig.cur` chunk
#' option, which only advances via knitr's internal plot-recording hook -
#' calling `fig_path()` by hand more than once per chunk (a loop over an
#' `icons` vector, several icons in one chunk, ...) leaves `fig.cur`
#' untouched, so every call resolves to the exact same "-1" path and each
#' icon silently overwrites the last one's file on disk. This package-local
#' counter
#' advances on every icon actually saved to disk instead, so concurrent
#' icons in the same chunk never collide.
#'
#' @noRd
icon_fig_num <- local({
  i <- 0L
  function(){
    i <<- i + 1L
    i
  }
})

#' A persistent (non-tempdir) path to save a rendered icon file to
#'
#' Rendered icons for non-HTML output formats (LaTeX, EPUB, ...) are saved
#' to disk and referenced by path in the pandoc markdown `knit()` produces,
#' rather than embedded inline. `tempfile()` is the wrong place for this:
#' `rmarkdown::render()` knits and calls pandoc/LaTeX in the same R process,
#' so a tempdir path stays valid throughout, but Quarto knits in a
#' subprocess that exits (deleting its tempdir) before its separate
#' pandoc/LaTeX step reads the file back in, breaking the reference. Using
#' the same project-relative `<file>_files/figure-*/` location knitr itself
#' uses for chunk plots (as the "gfm" branch above always has) keeps the
#' file around for whichever process needs it next, under both renderers -
#' and `icon_fig_num()` (rather than the default `fig.cur`-derived "-1")
#' keeps multiple icons rendered in the same chunk from clobbering each
#' other's file.
#'
#' @noRd
icon_fig_path <- function(ext){
  path <- knitr::fig_path(ext, number = icon_fig_num())
  if(!dir.exists(dirname(path))){
    dir.create(dirname(path), recursive = TRUE)
  }
  path
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
knit_print.icons <- function(x, ...) {
  out_type <- icon_out_type()
  if(is.null(out_type)) return(knitr::asis_output(""))

  knitr::asis_output(paste(
    vapply(icon_materialize_all(x), render_icon_output, character(1), out_type = out_type),
    collapse = ""
  ))
}
