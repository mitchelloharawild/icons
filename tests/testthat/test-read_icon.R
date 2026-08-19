test_that("read_icon() converts an SVG file into a styled icon tag", {
  path <- tempfile(fileext = ".svg")
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M0 0"/></svg>',
    path
  )

  icon <- read_icon(path)

  expect_s3_class(icon, "icons")
  icon <- icon_materialize_all(icon)[[1]]
  expect_identical(icon$name, "svg")
  # width/height are stripped in favour of the em-relative style, so the
  # icon scales with surrounding text
  expect_null(icon$attribs$width)
  expect_null(icon$attribs$height)
  expect_match(icon$attribs$style, "height:1em")
  # non-size attributes (like viewBox) are preserved
  expect_identical(icon$attribs$viewBox, "0 0 24 24")
})

test_that("read_icon() preserves nested children", {
  path <- tempfile(fileext = ".svg")
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg"><g><path d="M0 0"/></g></svg>',
    path
  )

  icon <- icon_materialize_all(read_icon(path))[[1]]

  expect_identical(icon$children[[1]]$name, "g")
  expect_identical(icon$children[[1]]$children[[1]]$name, "path")
})

test_that("read_icon() records the source path for use with icon_path()", {
  path <- tempfile(fileext = ".svg")
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg"><path d="M0 0"/></svg>',
    path
  )

  icon <- read_icon(path)

  expect_identical(icon_path(icon), path)
})

test_that("icon_path() errors for non-icon input", {
  expect_error(icon_path("not-an-icon"), class = "rlang_error")
})
