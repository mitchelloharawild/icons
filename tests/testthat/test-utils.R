test_that("add_class() prepends a class without duplicating existing ones", {
  x <- structure(list(), class = "icon")

  expect_identical(class(add_class(x, "icon")), "icon")
  expect_identical(class(add_class(x, "shiny.tag")), c("shiny.tag", "icon"))
})

test_that("%0% falls back to the right-hand side for empty values", {
  expect_identical(NULL %0% "default", "default")
  expect_identical(character() %0% "default", "default")
  expect_identical("value" %0% "default", "value")
})

test_that("list_svg() lists SVG basenames without their extension", {
  dir <- tempfile()
  dir.create(dir)
  file.create(file.path(dir, c("a.svg", "b.svg", "readme.txt")))

  expect_setequal(list_svg(dir), c("a", "b"))
})

test_that("list_svg() recurses into subdirectories, keyed by directory name", {
  dir <- tempfile()
  dir.create(file.path(dir, "solid"), recursive = TRUE)
  file.create(file.path(dir, "solid", "circle.svg"))

  files <- list_svg(dir)

  expect_type(files, "list")
  expect_identical(names(files), "solid")
  expect_identical(files$solid, "circle")
})

test_that("format_version() joins version components and highlights any 4th+", {
  expect_identical(format_version(package_version("1.2.3")), "1.2.3")
  # a trailing (e.g. dev/build) component beyond major.minor.patch is styled,
  # but the plain text still reads through when ANSI colour is unsupported
  expect_match(format_version(package_version("1.2.3.4")), "^1\\.2\\.3\\.")
})
