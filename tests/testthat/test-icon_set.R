test_that("icon_set() reads a flat SVG directory", {
  set <- local_icon_set_flat()

  expect_s3_class(set, "icon_set")
  expect_true(icon_installed(set))
  expect_identical(names(set), "triangle")
  expect_length(set, 1L)
})

test_that("$.icon_set returns an icon for a top-level file", {
  set <- local_icon_set_flat()

  icon <- set$triangle
  expect_s3_class(icon, "icons")
})

test_that("$.icon_set returns an icon whose icon_path() resolves on disk", {
  set <- local_icon_set_flat()

  icon <- set$triangle
  expect_true(file.exists(icon_path(icon)))
})

test_that("$.icon_set descends into a subdirectory via $.icon_dir", {
  set <- local_icon_set_nested()

  sub <- set$solid
  expect_s3_class(sub, "icon_dir")
  expect_identical(names(sub), "circle")

  icon <- sub$circle
  expect_s3_class(icon, "icons")
})

test_that("$.icon_set errors informatively for an unknown icon", {
  set <- local_icon_set_flat()

  expect_error(set$nope, class = "rlang_error")
})

test_that("icon_installed() is FALSE for a set whose directory doesn't exist", {
  set <- icon_set(tempfile(), meta = list(name = "Missing", version = NULL, license = NULL))

  expect_false(icon_installed(set))
  expect_error(set$anything, class = "rlang_error")
})

test_that("print.icon_set() reports the set name and version", {
  set <- local_icon_set_flat()

  expect_output(print(set), "Test icon set \\(version 1\\.0\\.0\\)")
})
