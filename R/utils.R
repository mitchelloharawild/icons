add_class <- function(x, new_class){
  `class<-`(x, union(new_class, class(x)))
}

icon_path <- function(...){
  path <- getOption("icon.path", default = rappdirs::user_data_dir("rpkg_icon"))
  file.path(path, ...)
}

list_svg <- function(path, recursive = TRUE, ...){
  list.files(path, pattern = "\\.svg$", recursive = recursive, ...)
}

icon_meta <- function(lib){
  path <- icon_path(lib, "meta.rds")
  if(file.exists(path)){
    readRDS(path)
  }
  else{
    list(name = "Missing", version = NULL, licence = NULL)
  }
}

require_package <- function(pkg){
  if(!requireNamespace(pkg, quietly = TRUE)){
    stop(
      sprintf('The `%s` package must be installed to use this functionality. It can be installed with install.packages("%s")', pkg, pkg),
      call. = FALSE
    )
  }
}
