# load packages
x <- c("dplyr")
lapply(x, require, character.only = T)
rm(x)

# change wd
setwd("dati-regioni/")

# load path to csv files
files <- list.files(path = ".",
                    pattern = "*.csv",
                    full.names = T)

# remove redundant files
files <- files[-c((length(files)-1):length(files))]

# load only file names
files_names <- list.files(path = ".",
                          pattern = "*.csv",
                          full.names = F) 

# remove redundant files
files_names <- files_names[-c((length(files_names)-1):length(files_names))]

# load the actual data in a list
myfiles  <-  lapply(files,
                    read.csv,
                    header = TRUE)

# change names in file list

