#' ####################################################################################
#' ETLtool 1:
#' Function operator, that wraps a function of type function(outFile, inFiles, param)
#' and adds version control features, by checking both the dates and the parameters.
#' #################################################################################### 
#' Author: Nassim Haddad
#' #################################################################################### 
#' TODO:
#' add file synced metadata




library(readr)

# utilities
file.date <- function(file)(file.info(file)$mtime)
file.date("cars.csv")


# example input function
filterMaxRows <- function(outputFile, inputFiles, parameters){
  
  if (length(inputFiles)>1){
    inputFiles <- inputFiles[1]
  }
  
  stopifnot("maxRows" %in% names(parameters))
  
  data <- readr::read_csv2(inputFiles)
  
  data <- data[seq(min(nrow(data), parameters$maxRows)),]
  
  readr::write_csv(data, outputFile)
  
  return(invisible(NULL))
}

# test usage
filterMaxRows("cars_filtered.csv", c("cars.csv"), 
              parameters = list("maxRows" = 5))


# function operator
pkg.env <- new.env()
pkg.env$catalog <- list()
control <- function(myFun){
  stopifnot(c("outputFile", "inputFiles", "parameters") %in%  names(as.list(args(myFun))))
  
  function(outputFile, inputFiles, parameters){
    TODO <- FALSE
    
    if (!TODO){
      TODO <- (!file.exists(outputFile))
    }
    if (!TODO){
      TODO <- (any(sapply(inputFiles, file.date) > file.date(outputFile)))
    }
    if (!TODO){ # check if parameters have changed
      TODO <- !identical(pkg.env$catalog[[outputFile]],
                        list(inputFiles = inputFiles,
                             parameters = parameters))
    }
    
    cat(sprintf("TODO: %s", TODO))
    if (TODO){
      myFun(outputFile, inputFiles, parameters)
      
      pkg.env$catalog[[outputFile]] <- list(inputFiles = inputFiles,
                                            parameters = parameters)
    }
  }
}

system("touch cars.csv")
control(filterMaxRows)("cars_filtered.csv", "cars.csv", parameters = list("maxRows" = 3))
control(filterMaxRows)("cars_filtered.csv", "cars.csv", parameters = list("maxRows" = 3))
control(filterMaxRows)("cars_filtered.csv", "cars.csv", parameters = list("maxRows" = 5))



