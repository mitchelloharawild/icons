## Test environments

* local ubuntu 24.04 install, R 4.5.2
* ubuntu-latest (on GitHub actions), R-devel, R-release, R-oldrel-1, R-oldrel-2, R-oldrel-3, R-oldrel-4
* macOS-latest (on GitHub actions), R-release
* windows-latest (on GitHub actions), R-release, R-oldrel-4
* win-builder, R-devel, R-release, R-oldrelease

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  New submission (this is the package's first release to CRAN, under the
  `icons` name).

## Downloaded content

Icon sets (Font Awesome, Academicons, Ionicons, etc.) are **not** bundled
with the package and are never downloaded during install, build, or check.
Each icon library is fetched only via an explicit, user-invoked
`download_*()` call (e.g. `download_fontawesome()`), which writes into a
user-specific cache directory (`rappdirs::user_data_dir()`), never inside
the package installation. Examples and vignette chunks that would otherwise
require a downloaded icon library are guarded with
`eval = icon_installed(fontawesome)` (or wrapped in `\donttest{}`/skipped),
so `R CMD check` does not require, and does not trigger, any network access or
disk writes.
