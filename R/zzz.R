.onLoad <- function(libname, pkgname) {
  op <- options()
  op.icon <- list(
    icon.path = rappdirs::user_data_dir("rpkg_icon")
  )
  toset <- !(names(op.icon) %in% names(op))
  if (any(toset)) options(op.icon[toset])

  # Update icon details
  update_icon()

  # `pillar` is a Suggests dependency, only used for tibble printing of an
  # `icon_vec` column, so it's registered conditionally rather than exported.
  vctrs::s3_register("pillar::pillar_shaft", "icon_vec")

  invisible()
}

.onAttach <- function(...) {
  icon_attach()
}
