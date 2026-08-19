add_class <- function(x, new_class) {
  `class<-`(x, union(new_class, class(x)))
}

`%0%` <- function(x, y) {
  if (is_empty(x)) y else x
}

icon_cache_path <- function(...) {
  path <- getOption("icon.path", default = rappdirs::user_data_dir("rpkg_icon"))
  file.path(path, ...)
}

list_svg <- function(path, ...) {
  dir <- list.dirs(path, full.names = TRUE, recursive = FALSE)
  if (length(dir) == 0) {
    sub("\\.svg$", "", list.files(path, pattern = "\\.svg$", ...))
  } else {
    `names<-`(lapply(dir, list_svg, ...), basename(dir))
  }
}

icon_meta <- function(lib) {
  path <- icon_cache_path(lib, "meta.rds")
  if (file.exists(path)) {
    readRDS(path)
  } else {
    list(name = lib, version = NULL, licence = NULL)
  }
}

require_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cli::cli_abort(
      c(
        "The {.pkg {pkg}} package must be installed to use this functionality.",
        "i" = "Install it with {.code install.packages(\"{pkg}\")}."
      ),
      call = NULL
    )
  }
}

install_icon_zip <- function(
  lib,
  url,
  svg_path,
  svg_pattern = "\\.svg$",
  svg_dest = NULL,
  meta
) {
  # Temporary download location
  dl_file <- tempfile("icon_dl")
  dir.create(dl_dir <- tempfile("icon_dl"), showWarnings = FALSE)
  on.exit(unlink(c(dl_file, dl_dir)))

  # Download repo
  download.file(url, dl_file)

  # Find icons
  utils::unzip(dl_file, exdir = dl_dir)

  if (is.character(svg_path)) {
    path <- do.call(
      file.path,
      c(list(list.dirs(dl_dir, recursive = FALSE)), svg_path)
    )
  } else if (is.function(svg_path)) {
    path <- svg_path(dl_dir)
  }

  # Copy icons
  files <- list.files(
    path,
    pattern = svg_pattern,
    recursive = TRUE,
    full.names = TRUE
  )
  dest_dir <- icon_cache_path(lib)
  unlink(dest_dir, recursive = TRUE)
  dest_svg <- if (is.function(svg_dest)) {
    svg_dest(files)
  } else {
    substring(files, nchar(path) + 2)
  }
  files <- files[!is.na(dest_svg)]
  dest_svg <- dest_svg[!is.na(dest_svg)]
  dest <- file.path(dest_dir, dest_svg)
  lapply(
    unique(dirname(dest)),
    dir.create,
    recursive = TRUE,
    showWarnings = FALSE
  )
  file.copy(files, dest)

  # Create meta
  if (is.character(meta)) {
    if (basename(meta) != "package.json") {
      cli::cli_abort(
        c(
          "x" = "Expected a {.field package.json} metadata file.",
          "i" = "Got {.file {basename(meta)}} instead."
        ),
        call = NULL
      )
    }
    meta <- jsonlite::read_json(file.path(
      list.dirs(dl_dir, recursive = FALSE),
      meta
    ))
    meta <- list(
      name = meta$name,
      version = meta$version,
      license = meta$license
    )
  }
  saveRDS(meta, file.path(dest_dir, "meta.rds"))

  # Update icons
  update_icon(lib, silent = FALSE)

  return(dl_dir)
}

require_system <- function(cmd) {
  path <- Sys.which(cmd)
  if (!nzchar(path)) {
    cli::cli_abort(
      c(
        "x" = "The {.field {cmd}} command line tool must be installed and available on the {.envvar PATH} to use this functionality.",
        "i" = "Install {.field {cmd}} and try again."
      ),
      call = NULL
    )
  }
  invisible(path)
}

#' Install icons from a sparse/partial git checkout
#'
#' Like install_icon_zip(), but instead of downloading a full repository
#' archive and discarding most of it, this uses `git`'s partial clone and
#' sparse-checkout support to fetch only `sparse_path` from the repository.
#' This avoids downloading unrelated folders (fonts, sprites, docs, ...) that
#' some icon repositories ship alongside their SVGs.
#'
#' @param repo A GitHub `"owner/repo"` slug.
#' @param ref The branch, tag, or commit to check out.
#' @param sparse_path The path (relative to the repository root) to check
#'   out, e.g. `"src"`.
#' @noRd
install_icon_git <- function(
  lib,
  repo,
  ref,
  sparse_path,
  svg_path,
  svg_pattern = "\\.svg$",
  svg_dest = NULL,
  meta
) {
  require_system("git")

  # Temporary checkout location
  dir.create(dl_dir <- tempfile("icon_dl"), showWarnings = FALSE)
  on.exit(unlink(dl_dir, recursive = TRUE, force = TRUE))

  # Partial clone (no blobs) + sparse checkout of just `sparse_path`, so
  # unrelated files/folders in the repo are never downloaded.
  url <- glue("https://github.com/{repo}.git")
  clone_ok <- identical(
    system2(
      "git",
      c(
        "clone",
        "--quiet",
        "--filter=blob:none",
        "--depth=1",
        "--sparse",
        "--branch",
        ref,
        url,
        dl_dir
      ),
      stdout = FALSE,
      stderr = FALSE
    ),
    0L
  )
  checkout_ok <- clone_ok &&
    identical(
      system2(
        "git",
        c("-C", dl_dir, "sparse-checkout", "set", sparse_path),
        stdout = FALSE,
        stderr = FALSE
      ),
      0L
    )
  if (!checkout_ok) {
    cli::cli_abort(
      "Failed to fetch {.val {sparse_path}} from {.val {repo}} ({ref}) with git.",
      call = NULL
    )
  }

  if (is.character(svg_path)) {
    path <- do.call(file.path, c(list(dl_dir), svg_path))
  } else if (is.function(svg_path)) {
    path <- svg_path(dl_dir)
  }

  # Copy icons
  files <- list.files(
    path,
    pattern = svg_pattern,
    recursive = TRUE,
    full.names = TRUE
  )
  dest_dir <- icon_cache_path(lib)
  unlink(dest_dir, recursive = TRUE)
  dest_svg <- if (is.function(svg_dest)) {
    svg_dest(files)
  } else {
    substring(files, nchar(path) + 2)
  }
  files <- files[!is.na(dest_svg)]
  dest_svg <- dest_svg[!is.na(dest_svg)]
  dest <- file.path(dest_dir, dest_svg)
  lapply(
    unique(dirname(dest)),
    dir.create,
    recursive = TRUE,
    showWarnings = FALSE
  )
  file.copy(files, dest)

  # `.git` (and its downloaded packs) served only to fetch `sparse_path`
  # above; discard it now rather than waiting for on.exit, since it's the
  # bulk of what was downloaded and has no further use.
  unlink(file.path(dl_dir, ".git"), recursive = TRUE, force = TRUE)

  saveRDS(meta, file.path(dest_dir, "meta.rds"))

  # Update icons
  update_icon(lib, silent = FALSE)

  invisible(dl_dir)
}

icon_guess <- function(name, ..., pattern = NULL) {
  icon_found <- icon_find(name, ...)
  if (!is.null(pattern)) {
    # icons vector carries no names() (see icon_find()'s @return docs), so
    # filtering matches icon_label()'s library$sub$name accessor instead.
    icon_found <- icon_found[grepl(
      pattern,
      icon_label(icon_found),
      fixed = TRUE
    )]
  }

  if (rlang::is_empty(icon_found)) {
    cli::cli_abort(
      c(
        "x" = "The {.val {name}} icon could not be found.",
        "i" = "Perhaps its icon set needs installing or updating with {.fn download_*}?"
      ),
      call = NULL
    )
  }
  vctrs::vec_slice(icon_found, 1)
}
