

shinyServer(function(input, output){ 

  # top 25 cities have veggie restaurants 
  output$veggie_by_city = renderPlot({
    top_n(city_group,n=25,count) %>% 
      ggplot(.,aes(x=city,y=count))+
      geom_bar(fill='dark green',stat='identity')+ 
      theme(axis.text.x = element_text(angle=0, vjust=0.6),
            panel.background = element_blank(),
            text = element_text(size = 16 ),
            legend.text=element_text(size=16)) +
      labs(title="Top 25 cities have the most vegetarian restaurants", 
           y = 'Count',
           x = 'City')+
      scale_x_discrete(guide = guide_axis(angle = 45))
  })
  
  # veggie restaurants by States
  output$veggie_by_state = renderPlot({
    ggplot(data = vegetarian.df,aes(x=state))+
      geom_bar(fill='light blue')+
      theme(axis.text.x = element_text(angle=0, vjust=0.6),
            panel.background = element_blank(),
            text = element_text(size = 16 ),
            legend.text=element_text(size=16))+
      labs(title="Vegetarian restaurants by States", 
           x = 'State',
           y = 'Count')+
      scale_x_discrete(guide = guide_axis(angle = 45))
  })
  
  # leaflet plot by state
  output$leaflet_state = renderLeaflet({
    leaflet(vegetarian.df %>% filter(.,state == input$selectedState)) %>%
      addTiles() %>% 
      addMarkers(lng=~longitude, lat=~latitude)
  })
  
  
  # rating boxplot
  output$rating_t_test = renderPlot({
    boxplot(yelp.restaurants$stars, 
            vegetarian.df$stars, 
            main = "Average Rating", 
            col=c('light gray','light yellow'), 
            names = c("Non-vegetarian", "Vegetarian"))
  })
  
  # review boxplot
  output$reviews_t_test = renderPlot({
    boxplot(yelp.restaurants$review_count, 
            vegetarian.df$review_count, 
            main = "Average Reviews", 
            col=c('light gray','light yellow'), 
            names = c("Non-vegetarian", "Vegetarian"),
            log='y')
  })
  
  # category treemap
  output$category.treemap = renderPlot({
    treemap(category.df %>% top_n(50),
            index=c("Categories"),
            type="value",
            vSize="Count",
            vColor='Count',
            title='Top Vegetairan Categories',
            palette='BrBG')
  })
  
  # show dataset snapshot and download button
  datasetInput <- reactive({
    yelp.restaurants %>% 
      select(-X, -business_id,-attributes,-categories,-hours)
  })
  
  output$dataset <- DT::renderDataTable({
    datasetInput()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("yelp.restaurants", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(yelp.restaurants,file)
    }
  )
  
  
})
