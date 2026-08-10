globalVariables("icon_fn")

dir_icon <- function(...){
  icon_fn$get(c(...))
}

icon_table <- new.env(parent = emptyenv())

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
