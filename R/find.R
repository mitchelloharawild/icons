#' Find icons in installed sets by name
#'
#' @param name The name of the icon
#'
#' @export
icon_find <- function(name, lib = NULL){
  all_icons <- lapply(icon_table, function(x) x$table$files)
  if(!is.null(lib)) all_icons <- all_icons[lib]
  search_icon <- function(x){
    if(is.list(x)) return(Filter(function(x) !is_empty(x), lapply(x, search_icon)))
    if(name %in% x) name else NULL
  }
  icon_method <- function(x, nm = NULL){
    if(is.list(x)){
      nm <- if(is.null(nm)) names(x) else paste(nm, names(x), sep = "$")
      do.call(c, mapply(icon_method, x = x, nm = nm, SIMPLIFY = FALSE, USE.NAMES = FALSE))
    } else {
      paste(nm, x, sep = "$")
    }
  }
  found_icons <- icon_method(search_icon(all_icons))
  names(found_icons) <- found_icons
  lapply(found_icons, function(x){
    eval_tidy(parse_expr(x), env = env_parent(n = 2))
  })
}
