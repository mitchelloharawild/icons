test_that("icon_uri() encodes an icon as a self-contained data URI", {
  set <- local_icon_set_flat()

  uri <- icon_uri(set$triangle)

  expect_length(uri, 1L)
  expect_true(startsWith(uri, "data:image/svg+xml;base64,"))

  decoded <- rawToChar(base64enc::base64decode(sub("^data:image/svg\\+xml;base64,", "", uri)))
  expect_identical(decoded, format(set$triangle))
})

test_that("icon_uri() keeps icon_style() styling, unlike icon_path()", {
  set <- local_icon_set_flat()
  styled <- icon_style(set$triangle, fill = "red")

  uri <- icon_uri(styled)

  decoded <- rawToChar(base64enc::base64decode(sub("^data:image/svg\\+xml;base64,", "", uri)))
  expect_match(decoded, "fill:red;", fixed = TRUE)
})

test_that("icon_uri() vectorises over an icon_vec, one URI per element", {
  set <- local_icon_set_multi()
  v <- icon_style(c(set$triangle, set$circle), fill = "blue")

  uris <- icon_uri(v)

  expect_length(uris, 2L)
  expect_true(all(startsWith(uris, "data:image/svg+xml;base64,")))

  decoded <- vapply(
    uris,
    function(uri) rawToChar(base64enc::base64decode(sub("^data:image/svg\\+xml;base64,", "", uri))),
    character(1),
    USE.NAMES = FALSE
  )
  expect_true(all(grepl("fill:blue;", decoded, fixed = TRUE)))
  expect_identical(decoded, unname(vapply(icon_materialize_all(v), format, character(1))))
})

test_that("icon_uri() errors informatively for non-icon input", {
  expect_error(icon_uri("not an icon"), class = "rlang_error")
})
