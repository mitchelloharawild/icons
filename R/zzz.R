.onLoad <- function(libname, pkgname) {
  op <- options()
  op.icon <- list(
    icon.path = rappdirs::user_data_dir("rpkg_icon")
  )
  toset <- !(names(op.icon) %in% names(op))
  if (any(toset)) options(op.icon[toset])

  # Update icon details
  fontawesome <<- icon_set(icon_path("fontawesome"), meta = icon_meta("fontawesome"))
  ionicons <<- icon_set(icon_path("ionicons"), meta = icon_meta("ionicons"))

  invisible()
}
