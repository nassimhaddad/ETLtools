

if (!exists("ETL")){
  outputFiles <- c("cars_copy.csv")
  inputFiles <- NULL
  parameters <- NULL
}


library(readr)
readr::write_csv(cars, outputFiles)