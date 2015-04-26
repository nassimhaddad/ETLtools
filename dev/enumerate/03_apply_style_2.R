

enumapply <- function(X, FUN, ..., varName =  "i"){
  out <- list()
  i <- 0
  for (x in X){
    i <- i+1
    assign(varName, i)
    out[[i]] <- FUN(x, ...)
  }
  out
}

enumapply(rnorm(10), function(x)c(x, i))
