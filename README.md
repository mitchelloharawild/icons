
<!-- README.md is generated from README.Rmd. Please edit that file -->

# icon <a href='https://pkg.mitchelloharawild.com/icon'><img src='man/figures/logo.svg' align="right" height="139" /></a>

[![R build
status](https://github.com/mitchelloharawild/icon/workflows/R-CMD-check/badge.svg)](https://github.com/mitchelloharawild/icon/actions?workflow=R-CMD-check)
[![Coverage
status](https://codecov.io/gh/mitchelloharawild/icon/branch/master/graph/badge.svg)](https://codecov.io/gh/mitchelloharawild/icon?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/icon)](https://cran.r-project.org/package=icon)
<!-- [![Downloads](http://cranlogs.r-pkg.org/badges/icon?color=brightgreen)](https://cran.r-project.org/package=icon) -->

The `icon` package for R makes adding web icons to reports,
presentations and apps easy. It integrates many popular icon libraries
from around the web with a simple interface that works with any
`rmarkdown` output format. If a particular icon library is not
explicitly supported by this package, you can still use it by creating a
custom icon set from a folder of SVG files. Icons provide flexible means
of digital expression, allowing expressions and functionality beyond
what is possible with emoji.

The `icon` package currently provides helpful tools for downloading and
using icons from these libraries:

  - [Font Awesome](https://github.com/FortAwesome/Font-Awesome/) (Pro
    icons can be used using custom icon sets)
  - [Ionicons](https://github.com/ionic-team/ionicons/)
  - [Academicons](https://github.com/jpswalsh/academicons)

# Installation

The **development** version can be installed from GitHub using:

``` r
# install.packages("remotes")
remotes::install_github("mitchelloharawild/icon")
```

Once you’ve installed the package you’ll also need to download some
icons\! Supported icon libraries (listed above) can be downloaded using
the `download_*()` functions. For example, to download the Font Awesome
icons you would use `download_fontawesome()`.

# Usage

Icons can be inserted inline using inline code `` `r
icon::fontawesome("rocket", style = "solid")` ``
<img src="man/figures/gh-installation-1.svg" height="16px"/> or `` `r
icon::fontawesome$solid$rocket` ``
<img src="man/figures/gh-installation-1.svg" height="16px"/>.

Icons can also be inserted using usual R chunks.

    ```{r icon-chunk}
    icon::fontawesome("rocket", style = "solid") # equivalent to icon::fontawesome$solid$rocket
    ```

<img src="man/figures/unnamed-chunk-2-1.svg" height="16px"/>

Custom icon sets can be created using the `icon_set()` function, which
accepts a directory of SVG files and allows them to be used as icons.

    ```{r icon-custom}
    custom <- icon::icon_set("hex")
    custom
    ```

    #> Custom icon set (/hex)

    ```{r icon-sticker}
    custom$icon
    ```

<img src="man/figures/icon-sticker-1.svg" height="16px"/>

# A Note on the old API

This is the second iteration of the icon package, the [first icon
package](https://github.com/ropenscilabs/icon) has been successful, but
lacked a few features such as SVG icons, user defined libraries, and
extensibility support. You can read the notes on the new API
[here](https://github.com/ropenscilabs/icon/issues/19). It turns out
that it was easier to build the new and improved icon from scratch,
which is what this repository is. In the future this version of icon
might just be merged into rOpenScilabs/icon, but for the mean time it
will be developed here. We anticipate that there will only be any minor
changes to the existing API, so hopefully this will be a seamless
transition for users\! Notably, the `icon_name` functions have been
removed in favour of `icon$name`, and the interface for styling and
animating has been removed/changed.
