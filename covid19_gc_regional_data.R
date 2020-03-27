# load packages
x <- c("dplyr", "ggplot2", "gganimate", "lubridate", "stringr", "tidyverse")
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

# transform data column
myfiles <- lapply(myfiles,
                  function(x) {x["data"] <- as_datetime(x$data); x})

# add a rank column to list
myfiles <- lapply(myfiles, cbind, rank = c(""))



# Total number of positive cases to date
# rank dfs based on "totale_attualmente_positivi" column
myfiles <- lapply(myfiles,
       function(x) {x["rank"] <- rank(-x$totale_attualmente_positivi,
                                         ties.method = "first"); x})

# collapse list in df
myfiles_df <- bind_rows(myfiles)

# Make graph and animation
p <- ggplot(myfiles_df,
            aes(rank,
                group = denominazione_regione, 
                fill = as.factor(denominazione_regione),
                color = as.factor(denominazione_regione))) +
  #scale_x_continuous(limits = c(0, 50000)) +
  geom_tile(aes(y = totale_attualmente_positivi/2, 
                height = totale_attualmente_positivi,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(denominazione_regione, " ")),
            vjust = 0.2, hjust = 1) +
  geom_text(aes(y = totale_attualmente_positivi,
                label = paste(totale_attualmente_positivi, " ")),
            vjust = 0.2, hjust = -.1) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  labs(title='{closest_state}', x = "", y = "Totale Positivi per Giorno") +
  theme(plot.title = element_text(hjust = 0, size = 22),
        axis.ticks.y = element_blank(),  # These relate to the axes post-flip
        axis.text.y  = element_blank(),  # These relate to the axes post-flip
        plot.margin = margin(1,1,1,4, "cm")) +
  transition_states(date(myfiles_df$data), transition_length = 4, state_length = 1) +
  ease_aes('cubic-in-out')

tot_att_pos_anim<- animate(p, fps = 25, duration = 20, width = 800, height = 600)

anim_save("tot_att_pos_anim.gif", animation = tot_att_pos_anim, "~/Desktop/")

# Total number of positive cases to date
# rank dfs based on "totale_attualmente_positivi" column
myfiles <- lapply(myfiles,
                  function(x) {x["rank"] <- rank(-x$nuovi_attualmente_positivi,
                                                 ties.method = "first"); x})

# collapse list in df
myfiles_df <- bind_rows(myfiles)

# Make graph and animation
p <- ggplot(myfiles_df,
            aes(rank,
                group = denominazione_regione, 
                fill = as.factor(denominazione_regione),
                color = as.factor(denominazione_regione))) +
  #scale_x_continuous(limits = c(0, 50000)) +
  geom_tile(aes(y = nuovi_attualmente_positivi/2, 
                height = nuovi_attualmente_positivi,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(denominazione_regione, " ")),
            vjust = 0.2, hjust = 1) +
  geom_text(aes(y = nuovi_attualmente_positivi,
                label = paste(nuovi_attualmente_positivi, " ")),
            vjust = 0.2, hjust = -.1) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  labs(title='{closest_state}', x = "", y = "Totale Positivi per Giorno") +
  theme(plot.title = element_text(hjust = 0, size = 22),
        axis.ticks.y = element_blank(),  # These relate to the axes post-flip
        axis.text.y  = element_blank(),  # These relate to the axes post-flip
        plot.margin = margin(1,1,1,4, "cm")) +
  transition_states(date(myfiles_df$data), transition_length = 4, state_length = 1) +
  ease_aes('cubic-in-out')

new_att_pos_anim<- animate(p, fps = 25, duration = 20, width = 800, height = 600)

anim_save("new_att_pos_anim.gif", animation = tot_att_pos_anim, "~/Desktop/")

