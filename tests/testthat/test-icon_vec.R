test_that("c() combines icons into an icon_vec", {
  set <- local_icon_set_multi()

  v <- c(set$triangle, set$circle)

  expect_s3_class(v, "icon_vec")
  expect_length(v, 2L)
  expect_identical(icon_path(v), c(icon_path(set$triangle), icon_path(set$circle)))
})

test_that("c() appends an icon onto an existing icon_vec", {
  set <- local_icon_set_multi()

  v <- c(set$triangle, set$circle)
  v2 <- c(v, set$triangle)

  expect_s3_class(v2, "icon_vec")
  expect_length(v2, 3L)
  expect_identical(icon_path(v2), c(icon_path(set$triangle), icon_path(set$circle), icon_path(set$triangle)))
})

test_that("c() combines two icon_vecs", {
  set <- local_icon_set_multi()

  v1 <- c(set$triangle, set$circle)
  v2 <- c(set$circle, set$triangle)

  combined <- c(v1, v2)
  expect_s3_class(combined, "icon_vec")
  expect_length(combined, 4L)
})

test_that("rep() replicates an icon into an icon_vec", {
  set <- local_icon_set_flat()

  r <- rep(set$triangle, 3)

  expect_s3_class(r, "icon_vec")
  expect_length(r, 3L)
  expect_identical(icon_path(r), rep(icon_path(set$triangle), 3))
})

test_that("rep() supports each/times/length.out like base rep()", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  expect_identical(icon_path(rep(v, each = 2)), rep(icon_path(v), each = 2))
  expect_identical(icon_path(rep(v, times = 2)), rep(icon_path(v), times = 2))
  expect_identical(icon_path(rep(v, length.out = 5)), rep(icon_path(v), length.out = 5))
})

test_that("styling before c()'ing preserves the style", {
  set <- local_icon_set_multi()

  styled <- icon_style(set$triangle, fill = "red")
  v <- c(styled, set$circle)

  materialized <- icon_materialize_all(v)
  expect_match(materialized[[1]]$attribs$style, "fill:red;")
  expect_no_match(materialized[[2]]$attribs$style, "fill:red;")
})

test_that("icon_style() on an icon_vec styles every element", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  styled <- icon_style(v, fill = "blue")

  expect_s3_class(styled, "icon_vec")
  materialized <- icon_materialize_all(styled)
  expect_true(all(vapply(materialized, function(x) grepl("fill:blue;", x$attribs$style), logical(1))))
})

test_that("icon_path() vectorises over an icon_vec", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  expect_identical(icon_path(v), c(icon_path(set$triangle), icon_path(set$circle)))
})

test_that("format() gives a compact, non-materialized label", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  labels <- format(v)
  expect_length(labels, 2L)
  expect_match(labels[1], "triangle")
  expect_match(labels[2], "circle")
})

test_that("print() doesn't error and doesn't dump raw SVG markup", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  out <- capture.output(print(v))
  expect_false(any(grepl("<svg", out, fixed = TRUE)))
})

test_that("as.tags() materializes each element as a real SVG tag", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  tags <- htmltools::as.tags(v)

  expect_length(tags, 2L)
  expect_true(all(vapply(tags, inherits, logical(1), what = "icon")))
})

test_that("knit_print.icon_vec renders every element, looping knit_print.icon's logic", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  old <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  on.exit(knitr::opts_knit$set(rmarkdown.pandoc.to = old), add = TRUE)
  knitr::opts_knit$set(rmarkdown.pandoc.to = "html")

  out <- knit_print.icon_vec(v)
  expect_s3_class(out, "knit_asis")
  expect_length(gregexpr("<svg", as.character(out), fixed = TRUE)[[1]], 2L)
})

test_that("mixing icon sets in one vector is allowed", {
  flat <- local_icon_set_flat()
  nested <- local_icon_set_nested()

  v <- c(flat$triangle, nested$solid$circle)

  expect_s3_class(v, "icon_vec")
  expect_length(v, 2L)
})

test_that("pillar formats an icon_vec column compactly", {
  skip_if_not_installed("pillar")
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  shaft <- pillar::pillar_shaft(v)
  expect_s3_class(shaft, "pillar_shaft")
})

test_that("icon_vec column drops into a data.frame", {
  set <- local_icon_set_multi()
  v <- c(set$triangle, set$circle)

  df <- data.frame(id = 1:2)
  df$icon <- v

  expect_s3_class(df$icon, "icon_vec")
  expect_length(df$icon, 2L)
})
