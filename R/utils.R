add_class <- function(x, new_class){
  `class<-`(x, union(new_class, class(x)))
}

`%0%` <- function(x, y){
  if(is_empty(x)) y else x
}

icon_path <- function(...){
  path <- getOption("icon.path", default = rappdirs::user_data_dir("rpkg_icon"))
  file.path(path, ...)
}

list_svg <- function(path, ...){
  dir <- list.dirs(path, full.names = TRUE)[-1]
  if(length(dir) == 0){
    sub("\\.svg$", "", list.files(path, pattern = "\\.svg$", ...))
  } else {
    setNames(lapply(dir, list_svg, ...), basename(dir))
  }
}

icon_meta <- function(lib){
  path <- icon_path(lib, "meta.rds")
  if(file.exists(path)){
    readRDS(path)
  }
  else{
    list(name = lib, version = NULL, licence = NULL)
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
