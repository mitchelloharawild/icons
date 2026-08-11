test_that("icon_label() reconstructs the library$sub$name accessor for a library-sourced icon", {
  root <- tempfile("icon_cache")
  dir.create(file.path(root, "fontawesome", "solid"), recursive = TRUE)
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>',
    file.path(root, "fontawesome", "solid", "rocket.svg")
  )

  old <- options(icon.path = root)
  on.exit(options(old), add = TRUE)

  icon <- read_icon(file.path(root, "fontawesome", "solid", "rocket.svg"))
  expect_identical(icon_label(icon), "fontawesome$solid$rocket")

  v <- c(icon, icon)
  expect_s3_class(v, "icon_vec")
  expect_identical(icon_label(v), c("fontawesome$solid$rocket", "fontawesome$solid$rocket"))
})

test_that("icon_label() is NA for icons outside the icon cache (e.g. a local icon_set())", {
  set <- local_icon_set_flat()
  expect_true(is.na(icon_label(set$triangle)))

  multi <- local_icon_set_multi()
  v <- c(multi$triangle, multi$circle)
  expect_true(all(is.na(icon_label(v))))
})

test_that("icon_label() survives c()/rep()/subsetting, unlike names()", {
  root <- tempfile("icon_cache")
  dir.create(file.path(root, "academicons"), recursive = TRUE)
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2 L22 22 L2 22 Z"/></svg>',
    file.path(root, "academicons", "orcid.svg")
  )

  old <- options(icon.path = root)
  on.exit(options(old), add = TRUE)

  icon <- read_icon(file.path(root, "academicons", "orcid.svg"))
  r <- rep(icon, 3)
  expect_identical(icon_label(r), rep("academicons$orcid", 3))
  expect_identical(icon_label(vctrs::vec_slice(r, 2)), "academicons$orcid")
})

test_that("icon_label() matches names(icon_find())'s accessor expressions", {
  skip_if_not(icon_installed(fontawesome), "fontawesome is not installed locally")

  found <- suppressWarnings(icon_find("rocket", set = "fontawesome"))
  v <- do.call(c, found) # named list -> c.icon() must not error (no names<- on icon_vec)

  expect_s3_class(v, "icon_vec")
  expect_identical(icon_label(v), names(found))
})
