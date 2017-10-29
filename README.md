
<!-- README.md is generated from README.Rmd. Please edit that file -->
icon <img src="man/figure/logo.png" align="right" />
====================================================

<!-- [![Travis-CI Build Status](https://travis-ci.org/earowang/icon.svg?branch=master)](https://travis-ci.org/earowang/icon) -->
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/icon)](https://cran.r-project.org/package=icon) -->
<!-- [![Downloads](http://cranlogs.r-pkg.org/badges/icon?color=brightgreen)](https://cran.r-project.org/package=icon) -->
An R package to easily insert web icons, including [font awesome](http://fontawesome.io), [academicons](http://jpswalsh.github.io/academicons/) and [ionicons](http://ionicons.com), into RMarkdown. Besides emoji, a sea of icons are floating around the web, which provides new options (or fun) for digital expressions. Please see [the vignette](http://mitchelloharawild.com/icon) as slides for details.

It works with inline code `` `r icon::fa("rocket")` `` and chunks:


    ```r
    icon::fa("rocket") # equivalent to icon::fa_rocket()
    ```

The **development** version can be installed from GitHub using:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/icon")
```
