### Github Demo Sample R Script ###


# Libraries ---------------------------------------------------------------

library(readr) #read in data

library(dplyr) #data wrangling tools
library(tidyr) #data wrangling tools

library(janitor) #clean up and format data

library(ggplot2) #plotting tools

# Import dataset --------------------------------------------------------

# Long Acting Reversible Methods of Contaception(LARC) by age dataset
larc_age <- read_csv("https://www.opendata.nhs.scot/dataset/d7a60977-e127-4817-8669-69458d14ab4b/resource/a2e1e94c-9e39-480e-9644-c6d380ae9dea/download/larc_by_agegroup_1920.csv") %>% 
  clean_names()

#filter latest complete financial year
larc_age_19_20 <- larc_age %>% 
  filter(financial_year == "2019/20")


# Plots ------------------------------------------------------------------

color_pallete <- c("#42213D", "#683257", "#bd4089", "#fa78d1") #setting a color palette
  
#barchart of lARC frequencies by age
freq_chart <- ggplot(data=larc_age_19_20)+
  geom_bar(aes(x=age_group, y=count, fill = type),stat = "identity",
           position = "dodge")+
  scale_fill_discrete(type = color_pallete)+
  theme_linedraw()+
  labs(x = "Age Group", y = "LARC type", 
       title = "Barchart of LARC Methods Used in Scotland by Age Group")

#proportional barchart of LARC frequencies by age
prop_chart <- ggplot(data=larc_age_19_20)+
  geom_bar(aes(x=age_group, y=count, fill = type),stat = "identity",
           position = "fill")+
  scale_fill_discrete(type = color_pallete)+
  theme_linedraw()+
  labs(x = "Age Group", y = "LARC type", 
       title = "Proportional Barchart of LARC Methods Used in Scotland by Age Group")

#view plots
freq_chart
prop_chart
