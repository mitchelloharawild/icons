# icon 0.1.0.9000

## Breaking changes

* Icons are no longer included directly in the package, and will require downloading before use.
* Animations of icons is no longer supported (this functionality will be re-introduced as a new package).
* The `library_icon` interface for accessing the `icon` icon from the `library` icon set has been replaced with `library$icon`.

## Improvements

* Icons now use SVG files instead of font files. This substantially reduces the output file's size and allows more flexibility and integrations with other libraries in the future.
* Icon sets can now be updated at any time without updating the package. The `download_*()` helpers can be used to install icon libraries.
* Custom icon sets can be created from a folder of SVG files.
* Icons can now be used with `word_document()` output formats.
* Improved detection of output format types to work with more rmarkdown extensions.

## Bug fixes

* Icons now work as expected in titles

# icon 0.1.0

* First release.
* Allows font icons to be easily included in R Markdown documents.
* Provides support for Font Awesome, Academicons, and Ionicons icon libraries.
* Some control options for the icons are possible, including icon colour, rotation, size and animations.
