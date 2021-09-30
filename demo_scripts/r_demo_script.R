### R Demo Script (Data Monitoring Induction Sept 2021)

# Load R Libraries ----------------------------------------------------------
library(readr)
library(janitor)

library(tidyverse)
library(dplyr)

library(ggplot2)

# Load Data ---------------------------------------------------------------

borders_data <- read_csv(here::here("data", "Borders.csv")) %>% 
  clean_names() %>% 
  select(-uri)

## Step-by-step breakdown of code above

# path <- here::here("data", "Borders.csv")
# borders_data <- read_csv(path)
# borders_data <- clean_names(borders_data)
# borders_data <- borders_data[,-uri]

#The dates are in numerical format, lets change them to date objects
borders_clean <- borders_data %>% 
  mutate(dateofbirth = as.Date(as.character(dateofbirth), "%Y%m%d"),
         dateof_admission=as.Date(as.character(dateof_admission),"%Y%m%d"),
         dateof_discharge=as.Date(as.character(dateof_discharge), "%Y%m%d"))

# Explore Data ------------------------------------------------------------

##Summary statistics for length of stay
summary(borders_clean$length_of_stay)

##Spread of length of stay values across the full data set
ggplot(borders_clean, aes(x=length_of_stay))+
  geom_density()

##Are there any variations in length of stay by sex?
los_sex <- borders_clean %>% 
  group_by(sex) %>% 
  summarize(num_records = n(),mean_los = mean(length_of_stay), 
            min_los=min(length_of_stay), max_los=max(length_of_stay),
            median(length_of_stay)) %>% 
  ungroup()

##Are there any variations in length of stay by age?

#first we need to add a column with the patient's age
borders_age <- borders_clean%>% 
  mutate(age = trunc(as.numeric(difftime(Sys.Date(), dateofbirth, units = "weeks"))/52.25))

#plot age against length of stay
ggplot(borders_age, aes(x=length_of_stay, y=age))+
  geom_point()

##Other things to explore...

#search for specific main condition codes?
#For example, do people with a symmptomatic ICD10 code (Z code) tend to have a longer length of stay? 
#What about length of stay by hospital or specialty?
#What is the most common specialty in the borders dataset?

# Wrangle -----------------------------------------------------------------

#Scenario: We've been asked to produce summary statistics and plots
#for length of stay by sex in Borders General Hospital (B120H)

#filter data for Borders General Hospital
borders_general <- borders_clean %>% 
  filter(hospital_code=="B120H")

#change the sex variable labels
borders_general <- borders_general %>% 
  mutate(sex = as.character(sex)) %>% 
  mutate(sex = case_when(sex == 1 ~ "Male",
                         sex==2 ~ "Female",
                         sex==3 ~ "Not Known",
                         TRUE ~ sex))

#produce and save summary statistics by sex
borders_general_summary <- borders_general %>% 
  group_by(sex) %>% 
  summarize(num_records = n(),mean_los = mean(length_of_stay), 
            min_los=min(length_of_stay), max_los=max(length_of_stay),
            median(length_of_stay)) %>% 
  ungroup()
  

# Visualize ---------------------------------------------------------------
borders_plot_data <- borders_general %>% 
  filter(sex == "Male"| sex == "Female")

sex_los_plot <- ggplot(borders_plot_data, aes(x=length_of_stay, color=sex, fill=sex))+
  geom_histogram(alpha=0.4)+
  scale_color_manual(values = c("#00AFBB", "#E7B800"))+
  scale_fill_manual(values = c("#00AFBB", "#E7B800")) +
  facet_grid(.~sex)+
  labs(title = "Number of Borders General Hospital Records by Length of Stay",
         x="Length of Stay in Days", y="Number of Records")

sex_los_plot

# Output ------------------------------------------------------------------

#write summary output to a csv file
write_csv(borders_general_summary,
          here::here("outputs", "borders_general_summary.csv"))


  