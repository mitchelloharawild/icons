#' @rdname bioicons
#' @export
download_bioicons <- function() {
  cli::cat_bullet("Gathering list of available Bioicons", bullet = "info")
  icon_df <-
    jsonlite::read_json(
      "https://raw.githubusercontent.com/duerrsimon/bioicons/main/static/icons/icons.json",
      simplifyVector = TRUE
    )

  author <- purrr::map_chr(gsub(" ", "_", icon_df$author), utils::URLencode)

  name <- gsub(" ", "%20", icon_df$name)

  cli::cat_bullet("Requesting Bioicons data from API", bullet = "info")
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

  to_keep <- purrr::map_lgl(bioicons, ~ length(.x)>0 & is.raw(.x))

  bioicons <- bioicons[to_keep]

  save_dir <-
    fs::path_real(fs::dir_create(rappdirs::user_data_dir('rpkg_icon/bioicons')))

  save_paths <- glue::glue("{save_dir}/{icon_df$name}.svg")[to_keep]

  cli::cat_bullet("Saving Bioicons as vector graphics", bullet = "info")
  purrr::walk2(bioicons, save_paths, rsvg::rsvg_svg)

  invisible(bioicons)
}

#' Bioicons icons
#'
#' @description Bioicons is a free library of open source icons for scientific
#'   illustrations using vector graphics software such as Inkscape or Adobe
#'   Illustrator.
#'
#' @param name Name of the icon.
#'
#' @seealso <https://bioicons.com/>
#'
#' @rdname bioicons
#' @md
#' @export
bioicons <- new_icon_set(
  "bioicons",
  function(name) {
    icon_fn$get(name)
  }
)
