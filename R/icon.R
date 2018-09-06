#' @keywords internal
"_PACKAGE"

icon_list <- function(path){
  files <- basename(list.files(path, pattern = "\\.svg$"))
  gsub("-", "_", gsub("\\.svg$", "", files), fixed = TRUE)
}

find_icon <- function(lib, name){
  file.path(lib%@%"path", paste0(name, ".svg"))
}

#' @export
new_iconset <- function(path){
  path <- normalizePath(path)
  structure(
    function(x){
      stop("not implemented")
    },
    class = c("iconset", "list"),
    path = path,
    list = icon_list(path)
  )
}

#' @export
`$.iconset` <- function(lib, icon){
  read_icon(find_icon(lib, icon))
}

#' @export
names.iconset <- function(x){
  x%@%"list"
}
