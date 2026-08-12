globalVariables("icon_fn")

dir_icon <- function(...){
  icon_fn$get(c(...))
}

icon_table <- new.env(parent = emptyenv())

# Turn `name` into an `icon_table` key that doesn't collide with an existing
# one, appending " (n)" as needed. Built-in libraries always pass a unique
# hard-coded key so never hit this; it's for `icon_set()`, where multiple
# custom icon sets often share the default `meta$name` of "Custom" (or could
# otherwise coincide with a library's name), and would otherwise silently
# overwrite each other's `icon_table` entry.
icon_table_key <- function(name) {
  if (!exists(name, envir = icon_table, inherits = FALSE)) return(name)
  i <- 2L
  repeat {
    candidate <- paste0(name, " (", i, ")")
    if (!exists(candidate, envir = icon_table, inherits = FALSE)) return(candidate)
    i <- i + 1L
  }
}

# Lookup table for features
new_icon_set <- function(nm, fn = dir_icon) {
  icon_table[[nm]] <- environment()
  table <- new.env(parent = emptyenv())
  icon_fn <- list(
    update = function(path, meta) {
      table[["path"]] <- path
      table[["files"]] <- list_svg(path)
      table[["meta"]] <- meta
    },
    get = function(name) {
      if(!dir.exists(table$path)){
        cli::cli_abort(
          c(
            "x" = "The {.field {nm}} icon library is not yet installed.",
            "i" = "Install it with {.fn download_{nm}}."
          ),
          call = NULL
        )
      }

      files <- Reduce(`[[`, name[-length(name)], table$files)
      icon <- name[length(name)]

      if(!(icon %in% files)){
        cli::cli_abort(
          c(
            "x" = "The {.val {icon}} icon could not be found in the {.field {nm}} icon set.",
            "i" = "Use {.fn icon_find} to search for icons across installed sets."
          ),
          call = NULL
        )
      }

      read_icon(glue(do.call(file.path, c(list(table[["path"]]), name)), ".svg"))
    },
    list = function() {
      if(is.list(table[["files"]])) names(table[["files"]]) else table[["files"]]
    }
  )

  structure(
    set_env(fn, environment()),
    class = c("icon_set", "list")
  )
}
