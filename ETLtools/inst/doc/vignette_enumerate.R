## ------------------------------------------------------------------------
random_numbers <- rnorm(3)
print(random_numbers)

## ------------------------------------------------------------------------
library(ETLtools)
for (x in enumerate(random_numbers)){
  print(list(iteration = i_(x), value = x))
}

## ------------------------------------------------------------------------
enumapply(rnorm(3), function(x, i)list(iteration = i,value = x))

