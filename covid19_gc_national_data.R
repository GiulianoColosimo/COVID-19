# load packages
x <- c("dplyr", "ggplot2", "gganimate", "lubridate", "stringr", "tidyverse")
lapply(x, require, character.only = T)
rm(x)

# change wd
setwd("dati-andamento-nazionale/")

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
                               "dpc-covid19-ita-andamento-nazionale-", "")
files_names <- str_replace_all(files_names,
                               ".csv", "")
files_names <- as.Date(files_names, "%Y%m%d")


# assign names to elements of the list
names(myfiles) <- files_names

# transform data column
myfiles <- lapply(myfiles,
                  function(x) {x["data"] <- as_datetime(x$data); x})

# collapse list in df
myfiles_df <- bind_rows(myfiles)


myfiles_df_a <- myfiles_df[, c("data", "terapia_intensiva", "nuovi_attualmente_positivi")]

myfiles_df_a_long <- gather(myfiles_df_a,
                            key = "type",
                            value = "count",
                            -data)

ggplot(myfiles_df_a_long, aes(x=data, y=count, fill=type)) +
  geom_bar(stat="identity", color = "black", position=position_dodge())
