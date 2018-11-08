
<!-- README.md is generated from README.Rmd. Please edit that file -->

# icon <img src="man/figure/logo.png" align="right" />

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/mitchelloharawild/icon.svg?branch=master)](https://travis-ci.org/mitchelloharawild/icon)
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/icon)](https://cran.r-project.org/package=icon) -->
<!-- [![Downloads](http://cranlogs.r-pkg.org/badges/icon?color=brightgreen)](https://cran.r-project.org/package=icon) -->

An R package to easily insert web icons into R documents. Many icons are
available for use around the web, which provides new options (or fun)
for digital expressions.

It works with inline code `` `r icon::fa("rocket")` `` and chunks:

```` 

```r
icon::fa("rocket") # equivalent to icon::fa$rocket()
```
````

The **development** version can be installed from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("mitchelloharawild/icon")
```

# A Note on the old API

This is the second iteration of the icon package, the [first icon
package](https://github.com/ropenscilabs/icon) has been successful, but
lacked a few features such as SVG icons, user defined libraries, and
extensibility support. You can read the notes on the new API
[here](https://github.com/ropenscilabs/icon/issues/19). It turns out
that it was easier to build the new and improved icon from scratch,
which is what this repository is. In the future this version of icon
might just be merged into rOpenScilabs/icon, but for the mean time it
will be developed here. We anticipate that there will not be any major
changes to the existing API, so hopefully this will be a seamless
transition for users\!
