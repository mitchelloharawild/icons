# icons 0.3.0

## New icon sets

* Added the `health_icons()` icon set (https://healthicons.org/).
* Added the `super_tiny_icons()` icon set (https://github.com/edent/SuperTinyIcons).

## New features

* Added `icon_uri()`, which encodes icons as self-contained base64 data strings.
  This makes it easier to use icons in other contexts, such as gt tables and as
  leaflet markers.
* Added icon vectors, to make it easier to use icons in data-oriented workflows
  (e.g. in tables, graphics, maps, ...)
* Added `icon_path()`, giving the file path(s) of an icon's source SVG - handy
  for using icons with ggplot2 and other packages that plot from image files.
* Added `icon_label()`, for identifying an icon by its library accessor label
  (for example `"fontawesome$solid$rocket"`).
* Added a "Using icons" vignette covering installation, insertion, styling,
  custom icon sets and Shiny usage.

## Breaking changes

* Icons are now fully vectorised. Accessing a single icon (e.g.
  `fontawesome$solid$rocket`) no longer returns a scalar icon that outputs
  raw SVG directly - it returns a length-1 `icons` vector, the same type
  returned by `icon_find()` and other multi-icon results. Code that reached
  into a result as a raw `htmltools` tag, or called `format()` expecting SVG
  markup, should use `htmltools::as.tags()` first.

## Improvements

* Each icon set's documentation now includes a "License" section describing
  the license its icons are distributed under, with a link to the source
  (#15).
* Messages, warnings and errors are now consistently produced with the `cli`
  package, and include more helpful hints (`crayon` is no longer used).
* Icon set functions now suggest similarly named icons when a requested icon
  can't be found (#67).
* `icons` vectors now have an `as.character()` method that returns their labels.
* Improved embedding of icons in other output formats.
* Improved the base icon style used for inline icon positioning.
* Downloading `google_material()` icons is now faster, using a git sparse
  checkout to fetch only the required SVG files (#70).
* The package's startup message is now suppressed in development sessions
  (e.g. `devtools::load_all()`).

## Bug fixes

* Icons now work as expected in titles (#7).
* Icons now work alongside emojis (#25).
* Fixed `icon_find()` when searching custom icon sets (#38).
* Fixed the download URL for `octicons()` (thanks @bbest, #58).

# icons 0.2.0

This release completely reimplements the package to use SVG icons. This is much
better for smaller file sizes, portability and icon customisation.

Icon libraries are no longer provided within the package, and instead must be
downloaded using the `download_*()` functions. This allows you to update and 
choose the version of your icon libraries without needing changes to the packages.

The package name is now also "icons", due to a package name conflict. Please use 
the `available::available()` function when choosing package names - and I should
submit packages to CRAN faster! (#48).

This release causes several breaking changes, if you have used the older version
of the package you should carefully read these changes.

## New icon sets

* Added the `simple_icons()` icon set (https://github.com/simple-icons/simple-icons/).
* Added the `google_material()` icon set (https://github.com/google/material-design-icons/).
* Added the `octicons()` icon set (https://github.com/primer/octicons).

## Breaking changes

* Icons are no longer included directly in the package, and will require 
  downloading before use. Use the `download_*()` functions to download an icon
  library you want to use.
* The short names (`fa`, `ii`, etc.) have been replaced with longer, more 
  informative names (`fontawesome`, `ionicons`, etc.).
* Animations of icons is no longer supported (this functionality will be
  made possible in a new package specific to CSS animations).
* The `iconset_icon` interface for accessing the `icon` icon from the `iconset` 
  icon set has been replaced with `iconset$icon`.
* The `iconset()` interface for accessing the icons is now specific to each icon 
  library.

## Improvements

* Icons now use SVG files instead of font files. This substantially reduces the 
  output file's size and allows more flexibility and integration with other 
  libraries in the future.
* Icon sets can now be updated at any time without updating the package. The
  `download_*()` helpers can be used to install icon libraries.
* Custom icon sets can be created from a folder of SVG files.
* Icons can now be used with `word_document` and `github_document` output 
  formats (#33).
* Improved detection of output format types to work with more rmarkdown 
  extensions.

# icon 0.1.0

* First release.
* Allows font icons to be easily included in R Markdown documents.
* Provides support for Font Awesome, Academicons, and Ionicons icon libraries.
* Some control options for the icons are possible, including icon colour, rotation, size and animations.
