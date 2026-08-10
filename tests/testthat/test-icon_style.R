test_that("icon_style() sets and replaces style properties", {
  set <- local_icon_set_flat()
  icon <- set$triangle

  styled <- icon_style(icon, scale = 2, fill = "red")
  expect_match(styled$attribs$style, "height:2em;")
  expect_match(styled$attribs$style, "fill:red;")

  # calling again replaces rather than duplicates the property
  restyled <- icon_style(styled, scale = 3)
  expect_match(restyled$attribs$style, "height:3em;")
  expect_no_match(restyled$attribs$style, "height:2em;")
})

test_that("icon_style() sets rotation and arbitrary CSS via ...", {
  set <- local_icon_set_flat()
  icon <- set$triangle

  styled <- icon_style(icon, rotate = 45, float = "right")
  expect_match(styled$attribs$style, "transform: rotate\\(45deg\\);")
  expect_match(styled$attribs$style, "float:right;")
})
