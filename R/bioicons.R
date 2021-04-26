#' @rdname bioicons
#' @export
download_bioicons <- function() {
  cli::cat_bullet("Gathering list of available Bioicons", bullet = "info")
  icon_df <-
    jsonlite::read_json(
      "https://raw.githubusercontent.com/duerrsimon/bioicons/main/static/icons/icons.json",
      simplifyVector = TRUE
    )

  icon_df$category2 <- tolower(gsub("_", " ", icon_df$category))
  icon_df$name2 <- tolower(icon_df$name)

  author <- purrr::map_chr(gsub(" ", "_", icon_df$author), utils::URLencode)

  name <- gsub(" ", "%20", icon_df$name)

  cli::cat_bullet("Requesting Bioicons data from web API", bullet = "info")
  bioicons <-
    purrr::pmap(
      list(
        icon_df$license,
        icon_df$category,
        author,
        name
      ),
      ~ httr::content(
          httr::GET(
            glue::glue("https://bioicons.com/icons/{..1}/{..2}/{..3}/{..4}.svg")
          )
        )
    )

  to_keep <- purrr::map_lgl(bioicons, ~ length(.x) > 0 & is.raw(.x))

  bioicons <- bioicons[to_keep]

  categories <- unique(icon_df$category2)

  save_dir <-
    fs::path_real(fs::dir_create(rappdirs::user_data_dir('rpkg_icon/bioicons')))

  fs::dir_create(
    glue::glue("{rappdirs::user_data_dir('rpkg_icon/bioicons')}/{categories}")
  )

  save_paths <- glue::glue("{save_dir}/{icon_df$category2}/{icon_df$name2}.svg")[to_keep]

  cli::cat_bullet("Storing Bioicons as vector graphics", bullet = "info")
  purrr::walk2(bioicons, save_paths, rsvg::rsvg_svg)

  cli::cat_bullet("Storing Bioicons metadata", bullet = "info")
  saveRDS(
    list(
      name = "Bioicons",
      version = "",
      licence = c("BSD", "CC-0", "CC by SA", "MIT")
    ),
    glue::glue("{save_dir}/meta.rds")
  )

  saveRDS(
    icon_df,
    glue::glue("{rappdirs::user_data_dir('rpkg_icon/bioicons')}/icons.rds")
  )

  invisible(bioicons)
}

#' Bioicons icons
#'
#' @description Bioicons is a free library of open source icons for scientific
#'   illustrations using vector graphics software such as Inkscape or Adobe
#'   Illustrator.
#'
#' @param name Name of the icon.
#' @param category The icon's category, one of "Animals", "Blood  immunology",
#'   "Cell lines", "Cell membrane", "Chemistry", "Chemo- and Bioinformatics",
#'   "General items", "Genetics", "Human physiology", "Intracellular
#'   components", "Lab apparatus", "Machine Learning", "Microbiology",
#'   "Nucleic Acids", "Oncology", "Parasites", "Receptor channels", "Safety
#'   symbols", "Scientific graphs", "Tissues", or "Viruses". `category` is not
#'   case-sensitive. If `NULL`, it will default to the first
#'   available icon with this name.
#'
#' @seealso <https://bioicons.com/>
#'
#' @rdname bioicons
#' @md
#' @export
bioicons <- new_icon_set(
  "bioicons",
  function(name, category = NULL) {
    if (is.null(category)) {
      info <-
        readRDS(
          glue::glue("{rappdirs::user_data_dir('rpkg_icon/bioicons')}/icons.rds")
        )
      icon_fn$get(
        c(
          info$category2[info$name2==tolower(name)][[1]],
          info$name2[info$name2==tolower(name)][[1]]
        )
      )
    }
    else {
      icon_fn$get(c(tolower(category), tolower(name)))
    }
  }
)
