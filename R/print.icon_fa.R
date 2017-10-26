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
#' @export
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
  } else if (knitOutputType() == "word_document") {
    stop("a")
  

  } else {

    icon <- htmltools::tags$i(class = icon_string(x$name, x$options))
    header <- htmltools::singleton(htmltools::tags$head(rmarkdown::html_dependency_font_awesome()))
    knitr::knit_print(htmltools::tagList(header, icon))
    # knitr::asis_output(icon), 
    #                           meta = list(
    #                             htmltools::tagList(header, icon)
    #                           )
    #                   )

  }
}

icon_string <- function(name, opts){
  size <- opts$size
  fixed_width <- opts$fixed_width
  animate <- opts$animate
  rotate <- opts$rotate
  flip <- opts$flip
  border <- opts$border
  pull <- opts$pull


  # Determine fa string to use -------------------------------------------------
  size_append <- switch(as.character(size),
                        '1' = "",
                        lg = " fa-lg",
                        '2' = " fa-2x",
                        '3' = " fa-3x",
                        '4' = " fa-4x",
                        '5' = " fa-5x")

  if (fixed_width) {
    fw_append <- " fa-fw"
  } else {
    fw_append <- ""
  }

  anim_append <- switch(animate,
                        "still" = "",
                        "spin" = " fa-spin",
                        "pulse" = " fa-pulse")

  rotate_append <- switch(as.character(rotate),
                          '0' = "",
                          '90' = " fa-rotate-90",
                          '180' = " fa-rotate-180",
                          '270' = " fa-rotate-270") 

  flip_append <- switch(flip,
                        "none" = "",
                        "horizontal" = " fa-flip-horizontal",
                        "vertical" = " fa-flip-vertical")

  if (border) {
    border_append <- " fa-border"
  } else {
    border_append <- ""
  }

  if (!is.null(pull)) {
    pull_append <- switch(pull,
                          "left"  = " fa-pull-left",
                          "right" = " fa-pull-right")
  } else {
    pull_append <- ""
  }

  full_string <- paste('fa fa-', 
                       name, 
                       size_append, 
                       fw_append, 
                       anim_append, 
                       rotate_append, 
                       flip_append, 
                       border_append,
                       pull_append, sep = "")

  full_string
}