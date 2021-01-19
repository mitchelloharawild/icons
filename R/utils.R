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
  dir <- list.dirs(path, full.names = TRUE, recursive = FALSE)
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

install_icon_zip <- function(lib, url, svg_path, svg_pattern = "\\.svg$",
                             svg_dest = NULL, meta){
  # Temporary download location
  dl_file <- tempfile("icon_dl")
  dir.create(dl_dir <- tempfile("icon_dl"), showWarnings = FALSE)
  on.exit(unlink(c(dl_file, dl_dir)))

  # Download repo
  download.file(url, dl_file)

  # Find icons
  utils::unzip(dl_file, exdir = dl_dir)

  if(is.character(svg_path)){
    path <- do.call(file.path, c(list(list.dirs(dl_dir, recursive = FALSE)), svg_path))
  } else if (is.function(svg_path)){
    path <- svg_path(dl_dir)
  }

  # Copy icons
  files <- list.files(path, pattern = svg_pattern, recursive = TRUE, full.names = TRUE)
  dest_dir <- icon_path(lib)
  unlink(dest_dir, recursive = TRUE)
  dest_svg <- if(is.function(svg_dest)){
    svg_dest(files)
  } else {
    substring(files, nchar(path)+2)
  }
  files <- files[!is.na(dest_svg)]
  dest_svg <- dest_svg[!is.na(dest_svg)]
  dest <- file.path(dest_dir, dest_svg)
  lapply(unique(dirname(dest)), dir.create, recursive = TRUE, showWarnings = FALSE)
  file.copy(files, dest)

  # Create meta
  if(is.character(meta) & basename(meta) == "package.json") {
    meta <- jsonlite::read_json(file.path(list.dirs(dl_dir, recursive = FALSE), meta))
    meta <- list(name = meta$name, version = meta$version, license = meta$license)
  }
  saveRDS(meta, file.path(dest_dir, "meta.rds"))

  # Update icons
  update_icon(lib, silent = FALSE)

  return(dl_dir)
}
