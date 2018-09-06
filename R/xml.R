#' @importFrom htmltools tagList
xml_tagList <- function(x){
  do.call("tagList", Map(make_xml_tags, x, names(x)))
}

#' @importFrom htmltools tag tagAppendChildren
make_xml_tags <- function(x, name){
  out <- tag(name, varArgs = attributes(x)[names(attributes(x)) != "names"])
  if(length(x) == 0){
    return(out)
  }
  do.call(tagAppendChildren, c(tag = list(out), Map(make_xml_tags, x, names(x))))
}
