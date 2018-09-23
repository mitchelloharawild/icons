add_class <- function(x, new_class){
  `class<-`(x, union(new_class, class(x)))
}

icon_path <- function(){
  getOption("icon.path", default = rappdirs::user_data_dir("icon"))
}
