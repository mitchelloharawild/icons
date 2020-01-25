# icon 0.1.0.9000

## New icon sets

* Added the `simple_icons()` icon set (https://github.com/simple-icons/simple-icons/).

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
