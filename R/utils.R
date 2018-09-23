add_class <- function(x, new_class){
  `class<-`(x, union(new_class, class(x)))
}

icon_path <- function(...){
  path <- getOption("icon.path", default = rappdirs::user_data_dir("icon"))
  file.path(path, ...)
}

list_svg <- function(path, full.names = FALSE, ...){
  icons <- list.files(path, pattern = "\\.svg$", full.names = full.names, ...)
  if(full.names){
    icons
  }
  else{
    basename(icons)
  }
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
