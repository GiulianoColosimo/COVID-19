setwd("dati-regioni/")

files <- list.files(path = ".",
                    pattern = "*.csv",
                    full.names = T)

files <- files[-c((length(files)-1):length(files))]

files_names <- list.files(path = ".",
                          pattern = "*.csv",
                          full.names = F) # only file names

files_names <- files_names[-c((length(files_names)-1):length(files_names))]

myfiles  <-  lapply(files,
                    read.csv,
                    header = TRUE)                   
