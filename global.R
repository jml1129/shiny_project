library(dplyr)
library(ggplot2)
library(treemap)
library(DT)
library(shiny)
library(shinydashboard)
library(googleVis)
library(devtools)
library(leaflet)


# convert matrix to dataframe
yelp.restaurants <- read.csv('yelp_food_businesses.csv')

vegetarian.df<-yelp.restaurants[grepl('Vegetarian', yelp.restaurants$categories)|grepl('Vegan', yelp.restaurants$categories), ]
category.table<-table(unlist(strsplit(vegetarian.df$categories, ", ", fixed = TRUE)))

category.df<-data.frame(category.table) %>% 
  rename(Categories=Var1,Count=Freq) %>% 
  filter(.,Categories!='Restaurants')

city_group<-vegetarian.df %>% 
  group_by(city) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count))
# remove row names
rownames(vegetarian.df) <- NULL
# create variable with colnames as choice
choice <- vegetarian.df %>% 
  filter(.,state=="OR"|state=="TX"|state=="MA") %>% 
  group_by(.,state)
