#' @keywords internal
"_PACKAGE"

#' @import rlang
#' @importFrom glue glue

icon_list <- function(path){
  files <- basename(list.files(path, pattern = "\\.svg$"))
  gsub("-", "_", gsub("\\.svg$", "", files), fixed = TRUE)
}

find_icon <- function(path, name){
  file.path(path, paste0(name, ".svg"))
}

empty_iconset <- function(x){
  read_icon(find_icon(path, x))
}

#' @export
new_iconset <- function(path, meta = list(name = "Custom", version = NULL, license = NULL)){
  path <- normalizePath(path)
  structure(
    set_env(
      empty_iconset,
      env_bury(get_env(empty_iconset),
               path = path,
               icons = icon_list(path),
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

print.iconset <- function(x){
  cat(
    glue("{get_env(x)$meta$name} icon set")
  )
  invisible(x)
}
