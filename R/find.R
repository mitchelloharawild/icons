#' Find icons in installed sets by name
#'
#' @param name The name of the icon
#' @param set Icon sets to search. If NULL, all available icons will be searched.
#'
#' @export
icon_find <- function(name, set = NULL){
  all_icons <- lapply(icon_table, function(x) x$table$files)
  if(!is.null(set)) all_icons <- all_icons[set]
  search_icon <- function(x){
    if(is.list(x)) return(Filter(function(x) !is_empty(x), lapply(x, search_icon)))
    if(name %in% x) name else NULL
  }
  icon_method <- function(x, nm = NULL){
    if(is.list(x)){
      nm <- if(is.null(nm)) syms(names(x)) else lapply(names(x), function(.) expr(`$`(!!nm, !!sym(.))))
      flatten(mapply(icon_method, x = x, nm = nm, SIMPLIFY = FALSE, USE.NAMES = FALSE))
    } else {
      expr(`$`(!!nm, !!sym(x)))
    }
  }
  found_icons <- icon_method(search_icon(all_icons))
  names(found_icons) <- vapply(found_icons, deparse, FUN.VALUE = character(1L))
  lapply(found_icons, function(x){
    eval_tidy(x, env = env_parent(n = 2))
  })
}
