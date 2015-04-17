#' Run an existing script with a certain structure while
#' checking if computations are necessary.
#' 
#' @param file path of the .R script to run
#' @param outputFiles files to be created by the script
#' @param inputFiles files used as an input by the script
#' @param parameters additional parameters, as a list
#' 
#' 
#' @export
#' 
#' 
run_script <- function(file, outputFiles, inputFiles = NULL, parameters = NULL){
  
  # check that script exists
  stopifnot(file.exists(file))
  
  # for compatibility with JSON
  if (is.null(inputFiles)){inputFiles <- list()}
  if (is.null(parameters)){parameters <- list()}
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
    TODO <- !all(sapply(metaFiles, function(x)isTRUE(all.equal(jsonlite::fromJSON(x), meta))))
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
    temp <- sapply(metaFiles, function(x)write(jsonlite::toJSON(meta), x))
  }
  # add some checks
  stopifnot(all(file.exists(outputFiles)))
  stopifnot(all(file.exists(metaFiles)))
  return(invisible(NULL))
}
