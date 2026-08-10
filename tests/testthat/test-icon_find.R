test_that("icon_find() returns no matches for an unknown icon name", {
  # icon_find()'s internal use of rlang::flatten() is soft-deprecated and
  # warns on every call (independent of what's being tested here).
  expect_length(suppressWarnings(icon_find("this-icon-definitely-does-not-exist-12345")), 0)
})

test_that("icon_find() locates a known icon in an installed set", {
  skip_if_not(icon_installed(fontawesome), "fontawesome is not installed locally")

  found <- suppressWarnings(icon_find("rocket", set = "fontawesome"))

  expect_true(length(found) > 0)
  expect_true(all(vapply(found, inherits, logical(1), what = "icon")))
  expect_true(all(grepl("^fontawesome\\$", names(found))))
})
