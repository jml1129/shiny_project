

shinyUI(
  dashboardPage(
  dashboardHeader(title = "Vegetarian Restaurants Analysis-Yelp",titleWidth = 400),
# menu bar  
  dashboardSidebar(
    sidebarUserPanel(name="Dashboard"), 
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("home")),
      menuItem("City & State", tabName = "city", icon = icon("city")),
      menuItem("Rating & Review", tabName = "rating_review", icon = icon("star")),
      menuItem("Category", tabName = "category", icon = icon("book")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    tabItems(
      # Introduction tab
      tabItem(tabName = "intro",
              fluidRow(box(title= "Vegetarian Restaurants Analysis", status = "primary", solidHeader = TRUE, width =  12,
                           h5("This is a Yelp dataset with the restaurant's information including name, address, reviews, rating, etc.It is a trend
                             going on to advocate different diets. When we are on the trip, people certainly spend more time
                             to look for places if they are vegetarians. I am curious about, in this dataset with samples provided, is there any city
                             that has much more options for vegetarian to dine out?"), 
                           h5("I'd also like to see:"),
                           h5("Regarding reviews and rating, are there any differences between vegetarian restaurants and non-veggie restaurants?
                             Are they statistically significant? What categories appear to be the options for vegetarian?"),
                           h4("Let's go dive in!")),
                       box(img(src="https://malou.io/wp-content/uploads/2018/02/Foodporn-Instagram-image-mise-en-avant.jpg", 
                               width = "70%", height = "70%"), status = "primary", width = 12, align="center"),
                       box(title= "Future research",
                           tags$li("Study on the demographics of the cities in this dataset, adding the profiles on Portland and Austin to see any cultural
                                   behavioral linked with."),
                           tags$li("Use different samples that contain different states and cities to see if the insights from this analysis are applicable."), width =  12))
              ),
      
      # city $ state tab
      tabItem(tabName = "city",h3("Which cities and states are more vegetarian friendly?"),
              br(),
              fluidRow(box(plotOutput("veggie_by_city"), status = "primary",
                           br(),
                           box( p("The bar chart shows the top 25 cities have more vegetarian restaurants in this dataset.
                                  A few cities contain relatively more, such as Portland, Austin, Vancouver, and Atlanta. It is not
                                  surprisingly to see metropolitants and popular tourist places tend to have more options for vegetarian."), background = "blue", width = 12), width=6),
                       box(plotOutput("veggie_by_state"),
                           br(),
                           box( p("From this analysis, all the assumptions and conclusion are based on this States. Observations can only
                                  represent the phenomenon in these 9 states. According to the data, Oregon, Texas, Massachussets, and
                                  British Columbia have more vegetarian options. If you want to eat out and not eat meat, there is no 
                                  better place to be than these top States."), background = "blue", width = 12), width=6)),
              
              h3("Use the drop-down to see where are most of vegetarian restaurants located in top 4 states"),

              fluidRow(
                       box(leafletOutput("leaflet_state")),
                       box(selectizeInput(inputId = "selectedState",
                                          label = "Select State",
                                          choices = c("OR","TX","MA","BC")), width= 4)
                       )
              ),
      
      # rating & review tab
      tabItem(tabName = "rating_review", h3("Higher rating and more reviews about vegetarian restaurants?"),
              fluidRow(box(title = "Assumption", solidHeader = TRUE,status = "primary",
                           h5("The common belief is that vegeatarian restaurans have better ratings compared to non specific vegetarian 
                              restaurants. Is it true? If there are differences between them, are they statistically significant? The
                              analysis compares the restaurants that contain 'Vegetarian' or 'Vegen' in their categores and those are not."), width = 12),
                       box(plotOutput("rating_t_test"),
                           box(p('From the boxplot, it tells that the average rating of vegetarian restaurants (4) is higher than non-veggie (3.51).
                                 From 2 sample t-test, p-value is way smaller than 0.05. We can certainly accept that the rating is significantly higher.
                                 Furthermore, it would be interesting to see the possible reasons behind that by conducting qualitative research.'), width="100%",background = "navy")),
                       box(plotOutput("reviews_t_test"),
                           box(p('I use log scale on y-axis for the boxplot. The average reviews of non-veggie particularly is 104 while the 
                                 average review for vegetarian is 163. Similarly, I used 2 sample t-test calculates the p-value is way less than 0.05.
                                 Statistically speaking, there is a significant difference between them.'),width="100%",background = "navy"))
              )
              ),
              
      # category tab        
      tabItem(tabName = "category", h3('What kind of categories do vegetarian restaurants offer more?'),
              fluidRow(box(plotOutput('category.treemap'), height = 500,width = 8),
                       box(h4('Treemap is easier to see the which categories are more, which are not. We can see vegetarian is larger
                              than vegan.Gluten-free is the toppest option in vegetarian category. Cuisines that vegetarian restaurants have more 
                              are American, Indian, Asian fusion, Mediterranean, Mexican, Middle Eastern. Desserts and Asian cuisine are likely showing
                              up more in terms of vegetarian options.'), background = 'navy',width = 4)
                       )
              ),
      
      # data tab
      tabItem(tabName = "data",
              fluidRow(box(p("Here's a snap shot of the whole dataset. Feel free to download the complete one here!"),background = "blue",width = 5),
                       downloadButton("downloadData", "Download"),
                       box(DT::dataTableOutput("dataset"), width = 12))
              )
    )
  )
))

