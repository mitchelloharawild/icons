#' @rdname bioicons
#' @export
download_bioicons <- function() {
  icon_df <-
    jsonlite::read_json(
      "https://raw.githubusercontent.com/duerrsimon/bioicons/main/static/icons/icons.json",
      simplifyVector = TRUE
    )
  icon_df$author <- gsub(" ", "_", icon_df$author)

  url <- "https://github.com/duerrsimon/bioicons/archive/refs/heads/main.zip"

  meta <-
    jsonlite::read_json(
      glue::glue("https://raw.githubusercontent.com/duerrsimon/bioicons/main/package.json")
    )

  install_icon_zip(
    "bioicons", url, c("static", "icons"),
    meta = list(
      name = "Bioicons",
      version = meta$version,
      licence = c("BSD", "CC-0", "CC-BY-SA", "MIT")
    )
  )
  saveRDS(icon_df, icon_path("bioicons", "icons.rds"))

  invisible(bioicons)
}

#' Bioicons icons
#'
#' @description Bioicons is a free library of open source icons for scientific
#'   illustrations using vector graphics software such as Inkscape or Adobe
#'   Illustrator.
#'
#' @param name Name of the icon.
#' @param category The icon's category, one of "Animals", "Blood_immunology",
#'   "Cell_lines", "Cell_membrane", "Chemistry", "Chemo-_and_Bioinformatics",
#'   "General_items", "Genetics", "Human_physiology", "Intracellular_components"
#'   , "Lab_apparatus", "Machine_Learning", "Microbiology",
#'   "Nucleic_Acids", "Oncology", "Parasites", "Receptor_channels",
#'   "Safety_symbols", "Scientific_graphs", "Tissues", or "Viruses".
#'   If `NULL`, it will default to the first available icon with this name.
#'
#' @seealso <https://bioicons.com/>
#'
#' @rdname bioicons
#' @md
#' @export
bioicons <- new_icon_set(
  "bioicons",
  function(name, category = NULL) {
    info <- readRDS(icon_path("bioicons", "icons.rds"))

    if (is.null(category)) {
      chosen_icon <- info[info$name==name, ]
      icon_fn$get(
        c(
          chosen_icon$license[1],
          chosen_icon$category[1],
          chosen_icon$author[1],
          name
        )
      )
    }
    else {
      chosen_icon <- info[info$name==name & info$category==category, ]
      icon_fn$get(
        c(
          chosen_icon$license[1],
          category,
          chosen_icon$author[1],
          name
        )
      )
    }
  }
)
