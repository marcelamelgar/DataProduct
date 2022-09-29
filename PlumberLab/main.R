library(plumber)

r <- plumb('plumber_api.R')
r$run(port=8000)