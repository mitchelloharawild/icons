# icons 0.2.0

This release completely reimplements the package to use SVG icons. This is much
better for smaller file sizes, portability and icon customisation.

Icon libraries are no longer provided within the package, and instead must be
downloaded using the `download_*()` functions. This allows you to update and 
choose the version of your icon libraries without needing changes to the packages.

The package name is now also "icons", due to a package name conflict. Please use 
the `available::available()` function when choosing package names - and I should
submit packages to CRAN faster!

This release causes several breaking changes, if you have used the older version
of the package you should carefully read these changes.

## New icon sets

* Added the `simple_icons()` icon set (https://github.com/simple-icons/simple-icons/).
* Added the `google_material()` icon set (https://github.com/google/material-design-icons/).
* Added the `octicons()` icon set (https://github.com/primer/octicons).

## Breaking changes

* Icons are no longer included directly in the package, and will require downloading before use.
* Animations of icons is no longer supported (this functionality will be re-introduced as a new package).
* The `iconset_icon` interface for accessing the `icon` icon from the `iconset` icon set has been replaced with `iconset$icon`.
* The `iconset()` interface for accessing the icons is now specific to each icon library.
* The short names (`fa`, `ii`, etc.) have been replaced with longer, more informative names (`fontawesome`, `ionicons`, etc.).

## Improvements

* Icons now use SVG files instead of font files. This substantially reduces the output file's size and allows more flexibility and integrations with other libraries in the future.
* Icon sets can now be updated at any time without updating the package. The `download_*()` helpers can be used to install icon libraries.
* Custom icon sets can be created from a folder of SVG files.
* Icons can now be used with `word_document` and `github_document` output formats.
* Improved detection of output format types to work with more rmarkdown extensions.

## Bug fixes

* Icons now work as expected in titles.
* Icons now work alongside emojis.

# icon 0.1.0

* First release.
* Allows font icons to be easily included in R Markdown documents.
* Provides support for Font Awesome, Academicons, and Ionicons icon libraries.
* Some control options for the icons are possible, including icon colour, rotation, size and animations.
