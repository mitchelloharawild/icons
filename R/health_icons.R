
#' @rdname health_icons
#' @export
download_health_icons <- function(){
  url <- "https://healthicons.org/icons.zip"

  meta <- jsonlite::read_json(
    "https://raw.githubusercontent.com/resolvetosavelives/healthicons/main/package.json"
  )

  install_icon_zip(
    "health_icons", url, function(dl_dir) file.path(dl_dir, "icons", "svg"),
    meta = list(
      name = "Health Icons",
      version = meta$version,
      licence = c("CC-0", "MIT")
    )
  )

  invisible(health_icons)
}

#' Health icons
#'
#' @param name Name of the icon
#' @param category The icon's category, either "blood", "body", "conditions",
#'   "devices", "diagnostics", "emotions", "family", "medications", "objects",
#'   "people", "places", "shapes", "specialties", "symbols", "typography", or
#'   "vehicles"
#' @param theme The style variant for the icon, requires v4.0.0 or greater.
#'   Available themes vary by icon, but can be either "filled", "negative",
#'   "outline". If NULL, it will default to the
#'   first available variant in this order.
#' @rdname health_icons
#' @export
health_icons <- new_icon_set(
  "health_icons",
  function(name, category = NULL, theme = NULL){
    if(is.null(category)){
      icon_guess(name, "health_icons", pattern = theme)
    } else {
      icon_fn$get(c(theme, category, name))
    }
  }
)
