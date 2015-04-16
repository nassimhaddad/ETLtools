#' Has this command been called from the Global environment
#' 
#' returns TRUE when called normally, but false when called with source(..., local = NS)
#' can be used like interactive(), to distinguish normal usage and usage in source.
#' 
inGlobal <- function(){identical((parent.frame()), globalenv())}
inGlobal()