



#' Function to take over an existing scripts with standard parameters
#' to allow for standardized etl processing
run_script <- function(file, outputFiles, inputFiles = NULL, parameters = NULL){
  require(jsonlite)
  
  # check that script exists
  stopifnot(file.exists(file))

  # for compatibility with JSON
  if (is.null(inputFiles)){inputFiles <- list()}
  if (is.null(parameters)){parameters <- list()}
  # helper function
  file.date <- function(file){out <- lapply(file, function(x)file.info(x)$mtime); do.call(c, out)}
  # extract meta data
  meta <- list(file = file, outputFiles = outputFiles, inputFiles = inputFiles, parameters = parameters)
  # where metadata is stored
  metaFiles <- paste0(outputFiles, ".json")
  
  # check if script needs to be processed
  TODO <- FALSE
  #
  if (!TODO){ # check if output files exist
    TODO <- (!all(file.exists(outputFiles)))
  }
  if (!TODO){ # check if metadata exists
    TODO <- !all(file.exists(metaFiles))
  }
  if (!TODO){ # check if metadata is same
    TODO <- !all(sapply(metaFiles, function(x)isTRUE(all.equal(fromJSON(x), meta))))
  }
  if (!TODO){ # check if input files have changed
    suppressWarnings({
      TODO <- (any(max(file.date(inputFiles)) > min(file.date(outputFiles))))
    })
  }
  if (!TODO){ # check if script has changed
    TODO <- (any(file.date(file) > min(file.date(outputFiles))))
  }
  
  if (TODO){
    cat("Running")
    suppressWarnings(file.remove(metaFiles))
    ETL <- TRUE # indicator that scripts should use variables defined below
    source(file, local = TRUE)
    temp <- sapply(metaFiles, function(x)write(toJSON(meta), x))
  }
  # add some checks
  stopifnot(all(file.exists(outputFiles)))
  stopifnot(all(file.exists(metaFiles)))
  return(invisible(NULL))
}



run_script("script_a.R", 
           outputFiles = c("cars_copy.csv"),
           inputFiles = NULL,
           parameters = NULL)

run_script("script_b.R", 
           outputFiles = c("cars_filtered.csv", "cars_cleaned.csv"),
           inputFiles = "cars_copy.csv",
           parameters = list("maxRows" = 4))



