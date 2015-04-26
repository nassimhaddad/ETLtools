enapply <- function(X, FUN, ...) {
  result <- vector("list", length(X))
  for (i in seq_along(result)) {
    tmp <- FUN(X[[i]], i, ...)
    if (is.null(tmp))
      result[i] <- list(NULL)
    else
      result[[i]] <- tmp
  }
  names(result)<-names(X)
  result
}

l <- list(a = 1, b = 2, c = 3)


#' `enumapply` works like `lapply`, but also passes the index of the 
#' current element to `FUN` as a second variable.
#' 
#' @param X a vector (atomic or list)
#' @param FUN function to apply. first input receives elements of X, the second the index, the next ones from `...`
#' @param ... optional arguments to FUN
#' 
#' @return
#' 
#' @examples
#' enumapply(c("a", "b", "c"), function(x, i)c(x,i))
#' 
enumapply <- function(X, FUN, ...){
  FUN <- match.fun(FUN)
  mapply(FUN, X, seq_along(X), MoreArgs = list(...), SIMPLIFY = F)
}
enumapply(c("a", "b", "c"), function(x, i)c(x,i))
enumapply(c("a", "b", "c"), function(x, i, j){print(j)}, j=15)


