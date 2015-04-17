

#' returns the date of a file
#' multiple files can be given as an input
#' 
#' @param file a vector of file paths
#' @return a vector of time stamps as POSIXct
#' 
file.date <- function(file){
  out <- lapply(file, function(x)file.info(x)$mtime)
  do.call(c, out)
}
