
#' To be used in a for loop, it adds the
#' iteration number to the object, that can be 
#' accessed via i_()
#' 
#' @param x object to iterate on
#' @return list of objects with class enumerate
#' @export
#' 
#' @examples
#' random_numbers <- rnorm(10)
#' random_numbers
#' for (num in enumerate(random_numbers)){
#'   print(i_(num))
#'   print(num)
#' }
#' 
enumerate <- function(x){
  out <- list()
  i <- 0
  for (current in x){
    i <- i+1
    attr(current, "i_enumerate")<-i
    class(current)<-c("enumerate",class(current))
    out[[i]] <- current
  }
  return(out)
}

#' Acces the iteration number of objects created with enumerate()
#' 
#' @param x object
#' 
#' @export
i_ <- function(x) UseMethod("i_")

#' @export
i_.enumerate <- function(x){
  return(attr(x, "i_enumerate"))
}

#' @export
print.enumerate <- function(x, ...){
  class(x) <- setdiff(class(x), "enumerate")
  attr(x, "i_enumerate") <- NULL
  print(x, ...)
}


#' enumapply works like lapply, but also passes the index of the 
#' current element to FUN as a second variable.
#' 
#' @param X a vector (atomic or list)
#' @param FUN function to apply. first input receives elements of X, the second the index, the next ones from ...
#' @param ... optional arguments to FUN
#' 
#' @return a list of same length as X
#' @export
#' 
#' @examples
#' enumapply(c("a", "b", "c"), function(x, i)c(x,i))
#' 
enumapply <- function(X, FUN, ...){
  FUN <- match.fun(FUN)
  mapply(FUN, X, seq_along(X), MoreArgs = list(...), SIMPLIFY = F)
}

