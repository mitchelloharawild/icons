.onLoad <- function(libname, pkgname) {
  op <- options()
  op.icon <- list(
    icon.path = rappdirs::user_data_dir("rpkg_icon")
  )
  toset <- !(names(op.icon) %in% names(op))
  if (any(toset)) options(op.icon[toset])

  # Update icon details
  get_env(fontawesome)[["icon_fn"]][["update"]](icon_path("fontawesome"), meta = icon_meta("fontawesome"))
  get_env(ionicons)[["icon_fn"]][["update"]](icon_path("ionicons"), meta = icon_meta("ionicons"))

  invisible()
}
