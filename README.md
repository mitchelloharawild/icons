
<!-- README.md is generated from README.Rmd. Please edit that file -->

# icons <a href='https://pkg.mitchelloharawild.com/icons/'><img src='man/figures/logo.png' align="right" height="138" /></a>

[![R-CMD-check](https://github.com/mitchelloharawild/icons/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mitchelloharawild/icons/actions/workflows/R-CMD-check.yaml)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/icons)](https://cran.r-project.org/package=icons)
<!-- [![Downloads](https://cranlogs.r-pkg.org/badges/icons?color=brightgreen)](https://cran.r-project.org/package=icons) -->

The `icons` package for R makes adding web icons to reports,
presentations and apps easy. It integrates many popular icon libraries
from around the web with a simple interface that works with any
`rmarkdown` output format. If a particular icon library is not
explicitly supported by this package, you can still use it by creating a
custom icon set from a folder of SVG files. Icons provide flexible means
of digital expression, allowing expressions and functionality beyond
what is possible with emoji.

The `icons` package currently provides helpful tools for downloading and
using icons from these libraries:

- [Font Awesome](https://github.com/FortAwesome/Font-Awesome/) (Pro
  icons can be used using custom icon sets)
- [Ionicons](https://github.com/ionic-team/ionicons/)
- [Academicons](https://github.com/jpswalsh/academicons)
- [Simple Icons](https://github.com/simple-icons/simple-icons/)
- [Google’s Material
  Design](https://github.com/google/material-design-icons)
- [Octicons](https://github.com/primer/octicons)
- [Feather Icons](https://github.com/feathericons/feather)
- [Bioicons](https://github.com/duerrsimon/bioicons)
- [Super Tiny Icons](https://github.com/edent/SuperTinyIcons)

# Installation

The **released** version can be installed from CRAN using:

``` r
install.packages("icons")
```

The **development** version can be installed from GitHub using:

``` r
# install.packages("remotes")
remotes::install_github("mitchelloharawild/icons")
```

Once you’ve installed the package you’ll also need to download some
icons! Supported icon libraries (listed above) can be downloaded using
the `download_*()` functions. For example, to download the Font Awesome
icons you would use `download_fontawesome()`.

# Usage

``` r
library(icons)
```

Icons can be inserted inline using inline code
`` `r icons::fontawesome("rocket", style = "solid")` ``
<img src="man/figures/unnamed-chunk-6-1.svg" height="16px"/> or
`` `r icons::fontawesome$solid$rocket` ``
<img src="man/figures/unnamed-chunk-6-2.svg" height="16px"/>.

Icons can also be inserted using usual R chunks.

    ```{r icon-chunk}
    fontawesome("rocket", style = "solid") # equivalent to icons::fontawesome$solid$rocket
    ```

<img src="man/figures/icon-chunk-3.svg" height="16px"/>

If the icon name contains non-syntactic name characters like a `-` or
`+`, you will need to quote the name with backticks, single or double
quotes:

``` r
fontawesome$brands$`r-project` # or 'r-project' or "r-project"
```

<img src="man/figures/icon-syntax-4.svg" height="16px"/>

The appearance of an icon can be customised using the `icon_style()`
function.

    ```{r icon-style}
    icon_style(fontawesome("rocket", style = "solid"), scale = 2, fill = "red")
    ```

<img src="man/figures/icon-style-5.svg" height="32px"/>

Custom icon sets can be created using the `icon_set()` function, which
accepts a directory of SVG files and allows them to be used as icons.

    ```{r icon-custom}
    custom <- icons::icon_set("hex")
    custom$icons
    ```

<img src="man/figures/icon-custom-6.svg" height="16px"/>

You can also search for icons using the `icon_find()` function, which
returns a vector of matching icons. Use `icon_label()` to see which icon
set and name each match came from.

``` r
found <- icon_find("rocket")
found
```

<img src="man/figures/icon-find-7.svg" height="16px"/><img src="man/figures/icon-find-8.svg" height="16px"/>

``` r
icon_label(found)
#> [1] "ionicons$rocket"          "fontawesome$solid$rocket"
```
