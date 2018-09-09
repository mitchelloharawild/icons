#' @keywords internal
"_PACKAGE"

#' @import rlang

icon_list <- function(path){
  files <- basename(list.files(path, pattern = "\\.svg$"))
  gsub("-", "_", gsub("\\.svg$", "", files), fixed = TRUE)
}

find_icon <- function(path, name){
  file.path(path, paste0(name, ".svg"))
}

#' @export
new_iconset <- function(path){
  path <- normalizePath(path)
  structure(
    new_function(alist(x = ), expr(read_icon(find_icon(!!path, x)))),
    class = c("iconset", "list"),
    path = path,
    list = icon_list(path)
  )
}

#' @export
`$.iconset` <- function(lib, icon){
  lib(icon)
}

#' @export
names.iconset <- function(x){
  x%@%"list"
}
