# Base style applied to every icon before any icon_style() customisation.
#
# `vertical-align` nudges the icon down onto a text baseline for inline icons.
icon_base_style <- "height:1em;display:inline-block;vertical-align:-.1em;"

#' Materialize an `icon` tag from a path and (optionally) a style
#'
#' The internal path -> tag builder used by `icon_materialize_all()`. This
#' is the only place that ever parses an SVG file.
#'
#' @param path Path to the icon's SVG file.
#' @param style A pre-computed `style` attribute to use verbatim, or `NA` to
#'   fall back to `icon_base_style`.
#'
#' @return An `icon` object.
#' @noRd
icon_materialize <- function(path, style = NA_character_) {
  icon <- xml2::read_xml(path)
  attr <- xml2::xml_attrs(icon)
  xml2::xml_set_attrs(icon, NULL)
  xml2::xml_set_attrs(
    icon,
    c(
      attr[setdiff(names(attr), c("width", "height"))],
      style = if (is.na(style)) icon_base_style else style
    )
  )

  icon <- xml2tags(icon)
  icon <- add_class(icon, "icon")
  attr(icon, "path") <- path
  icon
}

#' Read an individual icon
#'
#' @param x Path to the icon
#'
#' @return An `icons` vector: an SVG icon that can be printed, embedded
#'   in R Markdown, or styled with [icon_style()]. If `x` is a file path, it
#'   is retained and can be retrieved with [icon_path()].
#'
#' @export
read_icon <- function(x) {
  new_icons(x)
}

#' Get the file path of an icon
#'
#' Icons created from an SVG file (such as those from an [icon_set()], or
#' read directly with [read_icon()]) retain the path to their source file.
#' This is useful for passing icons to other packages that work with SVG
#' files directly, such as `ggplot2` (via `grid::rasterGrob()` or similar) or
#' `gt`.
#'
#' @param x An `icons` vector.
#'
#' @return A character vector giving the path(s) to the icon's source SVG
#'   file(s) on disk.
#'
#' @export
icon_path <- function(x) {
  UseMethod("icon_path")
}

#' @export
icon_path.default <- function(x) {
  cli::cli_abort("{.arg x} must be an {.cls icons} vector.", call = NULL)
}

#' Identify an icon by its library accessor label
#'
#' Every icon sourced from an installed icon library (as opposed to a local
#' [icon_set()] or a raw [read_icon()] file) has a file path of the form
#' `<cache root>/<library>/<...name parts...>.svg` (see `00_registry.R`'s
#' `icon_fn$get()`), which is exactly the `library$sub$name` expression used
#' to access it. `icon_label()` recovers that label straight from
#' [icon_path()] rather than requiring a name to be tracked separately —
#' so, unlike `names()`, it survives `c()`/`rep()`/subsetting on an `icons`
#' vector (a `vctrs` rcrd, which cannot carry element `names()`).
#'
#' @param x An `icons` vector.
#'
#' @return A character vector the same length as `x` giving each icon's
#'   `library$sub$name` label. Icons not sourced from an installed library
#'   (a local [icon_set()] or a [read_icon()] file outside the icon cache)
#'   return `NA`.
#'
#' @export
icon_label <- function(x) {
  UseMethod("icon_label")
}

#' @export
icon_label.default <- function(x) {
  cli::cli_abort(
    "{.arg x} must be an {.cls icons} vector.",
    call = NULL
  )
}

#' Turn a `<cache root>/<lib>/<...>.svg` path into a `lib$...` label
#' @noRd
icon_label_path <- function(path) {
  root <- paste0(icon_cache_path(), "/")
  from_library <- startsWith(path, root)
  rel <- sub("\\.svg$", "", substring(path, nchar(root) + 1))
  out <- gsub("/", "$", rel, fixed = TRUE)
  out[!from_library] <- NA_character_
  out
}

#' Encode a (styled) icon as a self-contained `data:` URI
#'
#' @description
#' Renders an icon's SVG markup to a base64-encoded URI.
#'
#' This enables self-contained and styled icon for consumers that use image
#' paths/URLs, including for example: an `<img src>`, a `gt::html()` cell,
#' and a `leaflet` marker `iconUrl`.
#'
#' @param x An `icons` vector.
#'
#' @return A character vector giving each icon's base64 encoded URI.
#'
#' @export
icon_uri <- function(x) {
  UseMethod("icon_uri")
}

#' @export
icon_uri.default <- function(x) {
  cli::cli_abort(
    "{.arg x} must be an {.cls icons} vector.",
    call = NULL
  )
}

#' Base64-encode SVG markup into a `data:` URI
#'
#' Used by [icon_uri()]'s `icons` method.
#'
#' @param svg A string of `<svg ...>...</svg>` markup, as produced by
#'   `format()` on a materialized icon tag.
#'
#' @noRd
icon_svg_uri <- function(svg) {
  paste0("data:image/svg+xml;base64,", base64enc::base64encode(charToRaw(svg)))
}

xml2tags <- function(x) {
  out <- htmltools::tag(
    xml2::xml_name(x),
    varArgs = as.list(xml2::xml_attrs(x))
  )
  do.call(
    htmltools::tagAppendChildren,
    c(tag = list(out), Map(xml2tags, xml2::xml_children(x)))
  )
}


#' Create a custom icon set
#'
#' @param path Path to the icons
#' @param meta Meta information for the icons
#'
#' @return An `icon_set` object providing access to the SVG files found at
#'   `path`, for example via `$`.
#'
#' @export
icon_set <- function(
  path,
  meta = list(name = "Custom", version = NULL, license = NULL)
) {
  path <- suppressWarnings(normalizePath(path))

  existing <- Filter(
    function(nm) identical(icon_table[[nm]]$table$path, path),
    names(icon_table)
  )
  nm <- if (length(existing)) {
    existing[[1]]
  } else {
    icon_table_key(meta$name %||% "Custom")
  }

  icon <- new_icon_set(nm)
  get_env(icon)[["icon_fn"]][["update"]](path, meta)
  icon
}

#' @export
`$.icon_set` <- function(lib, icon) {
  is_dir <- is.list(get_env(lib)$table$files)
  if (is_dir) {
    structure(list(set = lib, path = icon), class = c("icon_dir", "list"))
  } else {
    get_env(lib)[["icon_fn"]][["get"]](icon)
  }
}

#' @export
`$.icon_dir` <- function(lib, icon) {
  path <- lib[["path"]]
  lib <- lib[["set"]]
  is_dir <- is.list(Reduce(`[[`, path, get_env(lib)$table$files))
  path <- c(path, icon)
  if (is_dir) {
    structure(list(set = lib, path = path), class = c("icon_dir", "list"))
  } else {
    get_env(lib)[["icon_fn"]][["get"]](path)
  }
}

#' @export
names.icon_set <- function(x) {
  get_env(x)[["icon_fn"]][["list"]]()
}

#' @export
names.icon_dir <- function(x) {
  path <- x[["path"]]
  lib <- x[["set"]]
  files <- Reduce(`[[`, path, get_env(lib)$table$files)
  if (is.list(files)) names(files) else files
}

#' @export
print.icon_set <- function(x, ...) {
  tbl <- get_env(x)$table

  extra <- if (!icon_installed(x)) {
    "not installed"
  } else if (!is.null(tbl$meta$version)) {
    glue("version {tbl$meta$version}")
  } else {
    glue("/{basename(tbl$path)}")
  }

  cat(
    glue("{tbl$meta$name} icon set ({extra})")
  )
  invisible(x)
}

#' @export
length.icon_set <- function(x) {
  length(get_env(x)[["icon_fn"]][["list"]]())
}

#' Check if an icon set is installed.
#'
#' This function will return `TRUE` if the icons for an icon set are installed.
#' If they aren't, they can be installed using the appropriate `download_*()`
#' function.
#'
#' @param x An icon set (such as [`fontawesome`]).
#'
#' @return A single `TRUE` or `FALSE`.
#'
#' @export
icon_installed <- function(x) {
  dir.exists(get_env(x)$table$path)
}

update_icon <- function(libs = NULL, silent = TRUE) {
  if (is.null(libs)) {
    libs <- names(icon_table)
  }
  lapply(libs, function(lib) {
    meta <- icon_meta(lib)
    if (!silent) {
      version <- tryCatch(
        format_version(package_version(meta$version)),
        error = function(e) meta$version
      )
      cli::cli_alert_success("{.field {lib}} updated to version {version}.")
    }
    get_env(get(lib, mode = "function"))[["icon_fn"]][["update"]](
      icon_cache_path(lib),
      meta = meta
    )
  })
}
