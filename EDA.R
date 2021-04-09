
library('dplyr')
library('ggplot2')
library('tidyr')

'
How many restaurants in each metro area offers vegetarian options?
Which metros among the 50 most popular metro areas have the most and least vegetarian/vegan restaurants per 100,000 residents?
Do vegetarian/vegan restaurants tend to open close to other vegetarian/vegan restaurants?
What is average rating in OR, MA, TX?
What is the average price range by state?
Is the price higher among the 50 metro areas where have the most vegetarian and vegan restaurants than the metro areas where have the least?
'

#yelp food data
yelp.food.df<-read_csv('yelp_food_businesses.csv')
nrow(yelp.food.df[grepl('Vegetarian', yelp.food.df$categories)|grepl('Vegan', yelp.food.df$categories), ])
#vegetarian restaurants
yelp.vegetarian.restaurants<-yelp.food.df %>%
  filter(grepl('Vegetarian|Vegan', categories))
#1. How many restaurants in each metro area offers vegetarian options? What about state?
city_group<-vegetarian.df %>% 
  group_by(city) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count))

state_group<-vegetarian.df %>% 
  group_by(.,state) %>% 
  summarise(.,S_count=n()) %>%
  arrange(.,desc(S_count))

#2. top 25 cities have the most vegetarian restaurants
top_n(city_group,n=25,count) %>% 
  ggplot(.,aes(x=city,y=count))+
  geom_bar(fill='dark green',stat='identity')+
  coord_flip()+
  theme_bw()
#Veg options by state
ggplot(data = vegetarian.df,aes(x=state))+
  geom_bar(fill='light blue')+
  theme_bw()

#Find the cities have the least vegetarian restaurants, not able to see due to
#dataframe is not distinct to tell, too many rows have only 1 vegetarian restaurant
filter(city_group, count%in%1) %>% 
  ggplot(.,aes(x=city))+geom_bar()+
  coord_flip()

#3. Veggie Vs Non-veggie average rating
Non.Veggie<-yelp.restaurants%>%
  filter(!grepl('Vegetarian|Vegan', categories)) 

vegetarian.df %>% summarise(mean(stars))
###non-vegetarian is 3.51. Vegetarian is 4.00

#Are they significant different?
sd(yelp.food.df$stars)
sd(yelp.vegetarian.restaurants$stars)
boxplot(yelp.restaurants$stars, 
        vegetarian.df$stars, 
        main = "Average Rating", 
        col=c('light yellow','light green'), 
        names = c("Non-vegetarian", "Vegetarian"))

t.test(yelp.food.df$stars, yelp.vegetarian.restaurants$stars, alternative = "two.sided")
###sigificant different

#What is average rating for vegetarian restaurants in OR, MA, TX?
class(yelp.vegetarian.restaurants$stars)
yelp.vegetarian.restaurants %>% filter(.,state =='OR') %>%
  group_by(.,city) %>% 
  summarise(.,avg=mean(stars))

#4. Categories
category.table<-table(unlist(strsplit(vegetarian.df$categories, ", ", fixed = TRUE)))

category.df<-data.frame(category.table) %>% 
  rename(Categories=Var1,Count=Freq) %>% 
  filter(.,Categories!='Restaurants')
ggplot(category.df,aes(x=Feature, y=Count))+
  geom_bar(stat = 'identity')+
  coord_polar()

install.packages('treemap')
library(treemap)

treemap(category.df %>% top_n(50),
        index=c("Categories"),
        type="value",
        vSize="Count",
        vColor='Count',
        title='Top Vegetairan Categories',
        palette='BrBG')

#5. Reviews: Non Veggie Vs Vegetarian
yelp.food.df%>%
  filter(!grepl('Vegetarian|Vegan', categories)) %>% 
  summarise(max(review_count))
yelp.food.df %>% filter(.,review_count%in%9185) %>% select

yelp.vegetarian.restaurants %>% summarise(mean(review_count))
###non-vegetarian is 104 Vegetarian is 163
#Are they siginificant different?
sd(yelp.food.df$stars)
sd(yelp.vegetarian.restaurants$stars)

boxplot(Non.Veggie$review_count, 
        vegetarian.df$review_count, 
        main = "Average Reviews",
        col = c("light yellow", "light green"), names = c("Non-veggie", "Vege"), 
        log='y') #y-axis is log scale

t.test(yelp.food.df$review_count, yelp.vegetarian.restaurants$review_count, alternative = "two.sided")
  
library(leaflet)
get_map(location="oregan",source="google")

#GoogleTreeMap
output$Treemap <- renderGvis({
  gvisTreeMap(category.df,idvar="Categories", parentvar="Count",
              sizevar="Count", colorvar="Count")
})
