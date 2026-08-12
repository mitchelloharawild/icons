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

test_that("icon_find() locates an icon from a custom icon_set()", {
  set <- local_icon_set_flat()
  nm <- rlang::get_env(set)$nm

  found <- icon_find("triangle", set = nm)

  expect_s3_class(found, "icon_vec")
  expect_length(found, 1L)
})

test_that("icon_find() filters a custom icon_set() by its meta$name, not its path", {
  set <- local_icon_set_flat()
  nm <- rlang::get_env(set)$nm
  path <- rlang::get_env(set)$table$path

  # `set` should be usable with the icon_set()'s own readable `meta$name`
  # (derived from "Test", per the fixture), not an internal implementation
  # detail like the set's absolute source directory.
  expect_true(startsWith(nm, "Test"))
  expect_length(icon_find("triangle", set = nm), 1L)
  expect_length(icon_find("triangle", set = path), 0L)
})

test_that("icon_set() re-registers the same directory under the same icon_table key", {
  dir <- tempfile("icon_set_repeat")
  dir.create(dir)
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2 L22 22 L2 22 Z"/></svg>',
    file.path(dir, "triangle.svg")
  )
  meta <- list(name = "Repeat", version = "1.0.0", license = NULL)

  before <- ls(icon_table)
  icon_set(dir, meta = meta)
  after_first <- ls(icon_table)
  icon_set(dir, meta = meta)
  after_second <- ls(icon_table)

  expect_length(setdiff(after_first, before), 1L)
  expect_identical(after_second, after_first)
})

test_that("icon_set() deduplicates icon_table keys for colliding meta$name", {
  dir_a <- local_icon_set_flat()
  dir_b <- tempfile("icon_set_dup")
  dir.create(dir_b)
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>',
    file.path(dir_b, "circle.svg")
  )

  nm_a <- rlang::get_env(dir_a)$nm
  set_b <- icon_set(dir_b, meta = list(name = nm_a, version = NULL, license = NULL))
  nm_b <- rlang::get_env(set_b)$nm

  expect_false(identical(nm_a, nm_b))
  expect_true(startsWith(nm_b, nm_a))
})
