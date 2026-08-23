.onLoad <- function(libname, pkgname) {
  # Update icon details
  update_icon()

  # `pillar` is a Suggests dependency, only used for tibble printing of an
  # `icons` column, so it's registered conditionally rather than exported.
  vctrs::s3_register("pillar::pillar_shaft", "icons")

  invisible()
}

.onAttach <- function(...) {
  icon_attach()
}
