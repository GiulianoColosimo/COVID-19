# load packages
x <- c("dplyr", "lubridate", "stringr")
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
files_names <- str_replace_all(files_names,
                               "dpc-covid19-ita-regioni-", "")
files_names <- str_replace_all(files_names,
                               ".csv", "")
files_names <- as.Date(files_names, "%Y%m%d")

# assign names to elements of the list
names(myfiles) <- files_names 

