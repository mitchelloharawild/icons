test_that("an icons vector can be passed directly to a Shiny icon= argument", {
  skip_if_not_installed("shiny")

  set <- local_icon_set_flat()
  icon <- set$triangle

  expect_no_error(shiny::actionButton("go", "Launch", icon = icon))

  # A vectorised icon works too.
  set2 <- local_icon_set_multi()
  v <- c(set2$triangle, set2$circle)
  expect_no_error(shiny::actionButton("go2", "Launch", icon = v))

  # Materializing first still works, for anyone who was already doing so.
  expect_no_error(
    shiny::actionButton("go3", "Launch", icon = htmltools::as.tags(icon))
  )
})
