.onLoad <- function(libname, pkgname) {
  op <- options()
  op.icon <- list(
    icon.path = rappdirs::user_data_dir("icon")
  )
  toset <- !(names(op.icon) %in% names(op))
  if (any(toset)) options(op.icon[toset])

  # Update icon details
  fa <<- icon_set(icon_path("fa"), meta = icon_meta("fa"))
  ii <<- icon_set(icon_path("ii"), meta = icon_meta("ii"))

  invisible()
}
