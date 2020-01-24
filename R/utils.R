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
    `names<-`(lapply(dir, list_svg, ...), basename(dir))
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

install_icon_zip <- function(lib, url, svg_path, meta){
  # Temporary download location
  dl_file <- tempfile("icon_dl")
  dir.create(dl_dir <- tempfile("icon_dl"), showWarnings = FALSE)
  on.exit(unlink(c(dl_file, dl_dir)))

  # Download repo
  download.file(url, dl_file)

  # Find icons
  utils::unzip(dl_file, exdir = dl_dir)

  path <- do.call(file.path, c(list(list.dirs(dl_dir, recursive = FALSE)), svg_path))

  # Copy icons
  files <- list.files(path, pattern = "\\.svg$", recursive = TRUE, full.names = TRUE)
  dest_dir <- icon_path(lib)
  dest <- file.path(dest_dir, substring(files, nchar(path)+2))
  lapply(unique(dirname(dest)), dir.create, recursive = TRUE, showWarnings = FALSE)
  file.copy(files, dest)

  # Create meta
  saveRDS(meta, file.path(dest_dir, "meta.rds"))

  # Update icons
  update_icon(lib)
}
