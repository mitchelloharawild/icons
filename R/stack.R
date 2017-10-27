#' @export
`+.knit_icon` <- function(icon1, icon2) {
    out <- paste0("<span class=\"fa-stack fa-lg\">", icon1, "\n", icon2, "\n", 
        "</span>")
    class(out) <- class(icon1)
    out
}
