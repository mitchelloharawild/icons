test_that("icon_find() returns an empty icon_vec for an unknown icon name", {
  found <- icon_find("this-icon-definitely-does-not-exist-12345")

  expect_s3_class(found, "icon_vec")
  expect_length(found, 0)
})

test_that("icon_find() locates a known icon in an installed set", {
  skip_if_not(icon_installed(fontawesome), "fontawesome is not installed locally")

  found <- icon_find("rocket", set = "fontawesome")

  expect_s3_class(found, "icon_vec")
  expect_true(length(found) > 0)
  expect_true(all(grepl("^fontawesome\\$", icon_label(found))))
})
