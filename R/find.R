#' Find icons in installed sets by name
#'
#' @param name The name of the icon
#' @param set Icon sets to search. If NULL, all available icons will be searched.
#'
#' @return An `icons` vector of matching icons (empty if none are found). Use
#'   [icon_label()] to recover each match's `library$sub$name` accessor
#'   expression (for example `"fontawesome$solid$rocket"`) - the result
#'   itself carries no `names()`, since an `icons` vector can't hold them.
#'
#' @export
icon_find <- function(name, set = NULL) {
  libs <- as.list(icon_table)
  if (!is.null(set)) {
    libs <- libs[set]
  }

  # Recursively search a (possibly nested, one level per subdirectory)
  # `files` structure for `name`, returning the path components (each
  # subdirectory's key, then the file name) leading to every match.
  find_paths <- function(x, prefix = character()) {
    if (is.list(x)) {
      return(unlist(
        Map(function(v, k) find_paths(v, c(prefix, k)), x, names(x)),
        recursive = FALSE,
        use.names = FALSE
      ))
    }
    if (name %in% x) list(c(prefix, name)) else NULL
  }

  # Directly construct `new_icons()` directly from paths
  found_paths <- unlist(
    lapply(libs, function(lib) {
      parts <- find_paths(lib$table$files)
      vapply(
        parts,
        function(p) {
          glue(do.call(file.path, c(list(lib$table$path), as.list(p))), ".svg")
        },
        character(1)
      )
    }),
    use.names = FALSE
  )

  new_icons(path = found_paths)
}
