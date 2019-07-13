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
      table[["icons"]] <- gsub("[[:punct:]]", "_", gsub("\\.svg$", "", table[["files"]]))
      table[["meta"]] <- meta
    },
    get = function(name) {
      idx <- match(name, table[["icons"]])
      if(is.na(idx)){
        stop(
          sprintf("The `%s` icon could not be found in this icon set.", name)
        )
      }

      icon_loc <- file.path(table[["path"]], table[["files"]][idx])
      read_icon(icon_loc)
    },
    list = function() {
      table[["icons"]]
    }
  )

  structure(
    function(name){
      icon_fn$get(name)
    },
    class = c("icon_set", "list")
  )
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
  lib(icon)
}

#' @export
names.icon_set <- function(x){
  get_env(x)[["icon_fn"]][["list"]]()
}

#' @export
print.icon_set <- function(x, ...){
  cat(
    glue("{get_env(x)$table$meta$name} icon set")
  )
  invisible(x)
}
