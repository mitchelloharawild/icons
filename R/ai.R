html_dependency_academicons <- function() {
  htmltools::htmlDependency("academicons", "1.8.0", 
    src = icon_system_file("fonts/academicons-1.8.0"), 
    stylesheet = "css/academicons.min.css"
  ) 
}

icon_system_file <- function(file) {
  system.file(file, package = "icon")
}
