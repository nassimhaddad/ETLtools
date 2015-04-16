

if (!exists("ETL")){
  outputFiles <- c("cars_filtered.csv", "cars_cleaned.csv")
  inputFiles <- "cars_copy.csv"
  parameters <- list("maxRows" = 3)
}

library(readr)

data <- readr::read_csv(inputFiles)

data <- data[seq(min(nrow(data), parameters$maxRows)),]

readr::write_csv(data, outputFiles[1])
readr::write_csv(data, outputFiles[2])