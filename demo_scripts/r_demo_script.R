### R Demo Script (Data Monitoring Induction Sept 2021)


# Load R Libraries ----------------------------------------------------------
library(readr)
library(janitor)

library(tidyverse)
library(dplyr)

# Load Data ---------------------------------------------------------------

borders_data <- read_csv(here::here("data", "Borders.csv")) %>% 
  clean_names() %>% 
  select(-uri)

## Step-by-step breakdown of code above

# path <- here::here("data", "Borders.csv")
# borders_data <- read_csv(path)
# borders_data <- clean_names(borders_data)
# borders_data <- borders_data[,-uri]

# Explore Data ------------------------------------------------------------


