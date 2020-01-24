#' @keywords internal
"_PACKAGE"

#' @import rlang
#' @importFrom glue glue
NULL

# Lookup table for features
new_icon <- function() {
  table <- new.env(parent = emptyenv())
  icon_fn <- list(
    update = function(path, meta) {
      table[["path"]] <- path
      table[["files"]] <- list_svg(path)
      table[["meta"]] <- meta
    },
    get = function(name) {
      if(!dir.exists(table$path)){
        abort("This icon library is not yet installed, install it with `install_*()`.")
      }

      files <- Reduce(`[[`, name[-length(name)], table$files)
      icon <- name[length(name)]

      if(!(icon %in% files)){
        abort(
          glue("The `{icon}` icon could not be found in this icon set.")
        )
      }

      read_icon(glue(do.call(file.path, c(list(table[["path"]]), name)), ".svg"))
    },
    list = function() {
      if(is.list(table[["files"]])) names(table[["files"]]) else table[["files"]]
    }
  )

  structure(
    function(...){
      icon_fn$get(c(...))
    },
    class = c("icon_set", "list")
  )
}

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
  icon <- tagAppendAttributes(icon, style = "height:1em;position:relative;display:inline-block;top:.1em;")
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

  icon <- new_icon()
  get_env(icon)[["icon_fn"]][["update"]](path, meta)
  icon
}

#' @export
`$.icon_set` <- function(lib, icon){
  is_dir <- is.list(get_env(lib)$table$files)
  if(is_dir){
    structure(list(set = lib, path = icon), class = c("icon_dir", "list"))
  } else {
    lib(icon)
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
    lib(path)
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

icon_installed <- function(x){
  dir.exists(get_env(x)$table$path)
}
