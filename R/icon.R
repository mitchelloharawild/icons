#' @keywords internal
"_PACKAGE"

#' @import rlang
#' @importFrom glue glue


globalVariables(c("path", "files", "icons"))
get_icon <- function(name){
  icon_loc <- file.path(path, files[match(name, icons)])
  read_icon(icon_loc)
}

#' Create a custom icon set
#'
#' @param path Path to the icons
#' @param meta Meta information for the icons
#'
#' @export
iconset <- function(path, meta = list(name = "Custom", version = NULL, license = NULL)){
  path <- suppressWarnings(normalizePath(path))
  files <- list_svg(path)
  names <- gsub("[[:punct:]]", "_", gsub("\\.svg$", "", files))
  structure(
    set_env(
      get_icon,
      env_bury(get_env(get_icon),
               path = path,
               files = files,
               icons = names,
               meta = meta)
    ),
    class = c("iconset", "list")
  )
}

#' @export
`$.iconset` <- function(lib, icon){
  lib(icon)
}

#' @export
names.iconset <- function(x){
  get_env(x)$icons
}

#' @export
print.iconset <- function(x, ...){
  cat(
    glue("{get_env(x)$meta$name} icon set")
  )
  invisible(x)
}
