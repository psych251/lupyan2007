library("tidyverse")

theme_set(theme_classic(base_size = 18))

#####################################

input_path <- "Pilot A/raw_data"
output_path <- "Pilot A/processed_data"

files <- list.files(path=input_path,
                    pattern=".csv",
                    all.files=FALSE,
                    full.names=FALSE)

condition_names <- tibble(experimentName = c("Category_Training_Label",
                                      "Category_Training_LabelWritten",
                                      "Category_Training_Location",
                                      "Category_Training_NoLabel"),
                          condition = c("Label_Auditory",
                                        "Label_Written",
                                        "Location",
                                        "No_Label"))

#######FUNCTIONS#####################

clean_data = function(dat) {
  dat_clean <- dat %>% 
    rename(participant = "Prolific ID") %>%
    select(participant,
           counterbalance.group,
           expName,
           #block,
           alien_stim,
           category,
           friendly,
           approach,
           key_resp.actual,
           correct) %>% 
    drop_na(alien_stim) %>% 
    mutate(trial = 1:144) %>%
    mutate(condition = filter(condition_names,
                              expName[1] == experimentName)$condition)

  return (dat_clean)
}

######################################

df.dat_clean_all <- tibble(participant = c(),
                           #block = c(),
                           condition = c(),
                           counterbalance.group = c(),
                           alien_stim = c(),
                           category = c(),
                           friendly = c(),
                           approach = c(),
                           key_resp.actual = c(),
                           correct = c())

for (i in 1:length(files)) {
  df.dat <- read_csv(paste0(input_path, "/", files[i]))
  df.dat_clean <- clean_data(df.dat)
  write.csv(df.dat_clean,
            paste0(output_path, "/", files[i], "_processed.csv"),
            row.names = FALSE)
  df.dat_clean_all <- rbind(df.dat_clean, df.dat_clean_all)
}

write.csv(df.dat_clean_all,
          paste0(output_path, "/all_participants.csv"),
          row.names = FALSE)

