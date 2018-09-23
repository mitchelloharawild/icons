#' @keywords internal
"_PACKAGE"

#' @import rlang
#' @importFrom glue glue

get_icon <- function(x){
  icon_loc <- file.path(path, files[match(x, icons)])
  read_icon(icon_loc)
}

#' @export
new_iconset <- function(path, meta = list(name = "Custom", version = NULL, license = NULL)){
  path <- normalizePath(path)
  files <- list_svg(path)
  names <- gsub("[[:punct:]]", "_", gsub("\\.svg$", "", files), fixed = TRUE)
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

print.iconset <- function(x){
  cat(
    glue("{get_env(x)$meta$name} icon set")
  )
  invisible(x)
}
