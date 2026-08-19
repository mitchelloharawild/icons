# Small on-disk icon sets so tests don't depend on any icon library actually
# being downloaded. Directories live under tempdir(), which R removes
# automatically at the end of the session, so no explicit cleanup is needed.
#
# list_svg() (R/utils.R) only lists loose *.svg files when a directory has no
# subdirectories at all, so a set is either flat or nested by style - never a
# mix of both at the same level - and the two fixtures below mirror that.

# A flat set, like simple_icons(): icons are files directly under the root.
local_icon_set_flat <- function() {
  dir <- tempfile("icon_set_flat")
  dir.create(dir)

  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path d="M12 2 L22 22 L2 22 Z"/></svg>',
    file.path(dir, "triangle.svg")
  )

  icon_set(dir, meta = list(name = "Test", version = "1.0.0", license = NULL))
}

# A nested set, like fontawesome(): icons are grouped into style subdirectories.
local_icon_set_nested <- function() {
  dir <- tempfile("icon_set_nested")
  dir.create(file.path(dir, "solid"), recursive = TRUE)

  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>',
    file.path(dir, "solid", "circle.svg")
  )

  icon_set(dir, meta = list(name = "Test", version = "1.0.0", license = NULL))
}

# A flat set with two icons, for tests that need to combine distinct icons
# into an `icons` vector.
local_icon_set_multi <- function() {
  dir <- tempfile("icon_set_multi")
  dir.create(dir)

  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path d="M12 2 L22 22 L2 22 Z"/></svg>',
    file.path(dir, "triangle.svg")
  )
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><circle cx="12" cy="12" r="10"/></svg>',
    file.path(dir, "circle.svg")
  )

  icon_set(dir, meta = list(name = "Test", version = "1.0.0", license = NULL))
}
