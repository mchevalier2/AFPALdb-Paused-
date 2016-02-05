library(devtools)
library(roxygen2)

setwd("~/Workspace/AFPALdb/RAFPALdb")
document()
setwd("..")
install("RAFPALdb")
