#' @keywords internal
"_PACKAGE"

#' @import rlang
#' @importFrom glue glue
NULL

#' Read an individual icon
#'
#' @param x Path to the icon
#'
#' @importFrom htmltools tagAppendAttributes
#' @export
read_icon <- function(x){
  xml <- xml2::as_list(xml2::read_xml(x))
  icon <- xml_tagList(xml)$svg
  icon$attribs[c("width", "height")] <- NULL
  icon <- tagAppendAttributes(icon, style = "height:1em;fill:currentColor;position:relative;display:inline-block;top:.1em;")
  add_class(icon, "icon")
}

#' Create a custom icon set
#'
#' @param path Path to the icons
#' @param meta Meta information for the icons
#'
#' @export
icon_set <- function(path, meta = list(name = "Custom", version = NULL, license = NULL)){
  path <- suppressWarnings(normalizePath(path))

  icon <- new_icon(path)
  get_env(icon)[["icon_fn"]][["update"]](path, meta)
  icon
}

#' @export
`$.icon_set` <- function(lib, icon){
  is_dir <- is.list(get_env(lib)$table$files)
  if(is_dir){
    structure(list(set = lib, path = icon), class = c("icon_dir", "list"))
  } else {
    get_env(lib)[["icon_fn"]][["get"]](icon)
  }
}

#' @export
`$.icon_dir` <- function(lib, icon){
  path <- lib[["path"]]
  lib <- lib[["set"]]
  is_dir <- is.list(Reduce(`[[`, path, get_env(lib)$table$files))
  path <- c(path, icon)
  if(is_dir){
    structure(list(set = lib, path = path), class = c("icon_dir", "list"))
  } else {
    get_env(lib)[["icon_fn"]][["get"]](path)
  }
}

#' @export
names.icon_set <- function(x){
  get_env(x)[["icon_fn"]][["list"]]()
}

#' @export
names.icon_dir <- function(x){
  path <- x[["path"]]
  lib <- x[["set"]]
  files <- Reduce(`[[`, path, get_env(lib)$table$files)
  if(is.list(files)) names(files) else files
}

#' @export
print.icon_set <- function(x, ...){
  tbl <- get_env(x)$table

  extra <- if(!icon_installed(x)){
    "not installed"
  } else if(!is.null(tbl$meta$version)){
    glue("version {tbl$meta$version}")
  } else {
    glue("/{basename(tbl$path)}")
  }

  cat(
    glue("{tbl$meta$name} icon set ({extra})")
  )
  invisible(x)
}

#' @export
length.icon_set <- function(x){
  length(get_env(x)[["icon_fn"]][["list"]]())
}

#' Check if an icon set is installed.
#'
#' This function will return `TRUE` if the icons for an icon set are installed.
#' If they aren't, they can be installed using the appropriate `download_*()`
#' function.
#'
#' @param x An icon set (such as [`fontawesome`]).
#'
#' @export
icon_installed <- function(x){
  dir.exists(get_env(x)$table$path)
}

update_icon <- function(libs = NULL, silent = TRUE){
  if(is.null(libs)) libs <- names(icon_table)
  lapply(libs, function(lib){
    meta <- icon_meta(lib)
    if(!silent){
      msg(paste0(
        crayon::green(cli::symbol$tick), " ", crayon::blue(lib), " updated to version ",
        format_version(package_version(meta$version))
      ))
    }
    get_env(get(lib, mode = "function"))[["icon_fn"]][["update"]](icon_path(lib), meta = meta)
  })
}
