#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinythemes)
library(tidyr)
library(tidyverse)
library(dplyr)
library(knitr)
library(ggplot2)
library(ggthemes)
library(plotly)
library(DT) 
library(countrycode)

# Data Provided by Organization for Economic Co-operation and Development
# OECD (2023), Suicide rates (indicator). doi: 10.1787/a82f3459-en (Accessed on 02 March 2023)
OECD_suicide <- read.csv("./data/OECD_suicide_rate.csv")

# Group dataset by continent, delete unnecessary columns, change country name to full names
OECD_suicide_continent <- OECD_suicide %>%
  # assign continent to each row based on iso3c
  mutate(Continent = countrycode(LOCATION, 'iso3c', 'continent'), 
         # eliminate unnecessary columns
         Flag.Codes = NULL, 
         FREQUENCY = NULL, 
         # reformat country names based on given country code
         LOCATION = countrycode(LOCATION, 'iso3c', 'country.name'),
         # rename the values
         SUBJECT = recode(SUBJECT,TOT="Total", MEN="Men", WOMEN="Women")) 

# change column names and order country in alphabetical order
colnames(OECD_suicide_continent) <- c('Country','Indicator','Gender','Measure','Year','Value','Continent')
OECD_suicide_continent <- OECD_suicide_continent[order(OECD_suicide_continent$Country), ]

# Data Provided by Organization for Economic Co-operation and Development
# OECD (2023), Fertility rates (indicator). doi: 10.1787/8272fb01-en (Accessed on 02 March 2023)
OECD_fertility <- read.csv("./data/OECD_fertility_rate.csv")

OECD_fertility_continent <- OECD_fertility %>%
  # eliminate unused rows
  filter(LOCATION !="EU" & LOCATION != "OAVG") %>%
  # assign continent to each row based on iso3c
  mutate(Continent = countrycode(LOCATION, 'iso3c', 'continent'), 
         # eliminate unnecessary columns
         Flag.Codes = NULL, 
         FREQUENCY = NULL, 
         # reformat country names based on given country code
         LOCATION = countrycode(LOCATION, 'iso3c', 'country.name'),
         # rename the values
         SUBJECT = recode(SUBJECT,TOT="Total", MEN="Men", WOMEN="Women"))

# change column names and order country in alphabetical order
colnames(OECD_fertility_continent) <- c('Country','Indicator','Gender','Measure', 'Year','Value','Continent')
OECD_fertility_continent <- OECD_fertility_continent[order(OECD_fertility_continent$Country), ]


# Define UI
ui <- fluidPage(theme = shinytheme("flatly"),
  navbarPage("OECD Country Data Analysis",
    # tab for main page(about page)
    tabPanel("About",
             h3("About"),
             HTML('<center><img src="oecd_main.jpeg" width="736"></center>'),
             h4("Research Question"),
             p("There are many interesting statistics of the OECD countries around the world, but two dataset we focused on were 
             suicide rate and fertility rate. We have questions we want answers to using the two datasets for further analysis.
             How does suicide rate relate to the continent of the OECD countries? How does fertility rate relate to the continent of the OECD countries?"),
             h4("Tabs"),
             h5("About:"),
             h6("The About tab is the main page of the website and has information about the website and each tab."),
             h5("Dataset:"),
             h6("The Dataset tab explains the definition of suicide rate and fertility rate. It also gives a chance for the user to look at the dataset we used."),
             h5("Suicide Rate & Fertility Rate:"),
             h6("For both tabs, there are two down menus the user can choose from: View By Continent & View By Country"), 
             h6("They each have interactive graphs based on the dataset, where the user can choose inputs for what they want the graph to show. If the user wants to check what each visualization represents, they can hover the mouse over the graph and it will provide them with the data that each data in the graph represents."),
             h5("What is the OECD?"),
             h6("'OECD' stands for 'Organization for Economic Co-operation and Development', which is 'an international organization that works to build better policies for better lives.' According to the official OECD website, their goal is 'to shape policies that foster prosperity, equality, opportunity and well-being for all.'") 
             ), 
             
    # tab for dataset page
    tabPanel("Dataset",
             h3("Dataset"),
             h6("In this website, we are accessing the data for suicide rate and fertility rate."),
             h6("So before we move on, what is the definition of suicide rate and fertility rate? Take a look at the explanations below."),
             h5("Suicide Rate"),
             h6("Deaths deliberately initiated and performed by a person in the full knowledge or expectation of its fatal outcome"),
             h5("Fertility Rate"),
             h6("Total number of children that would be born to each woman if she were to live to the end of her childbearing years and give birth to children in alignment with the prevailing age-specific fertility rates"),
             h6("Now, since we understand what suicide rate and fertility rate represents, let's look at the dataset."),
             h6("Below are the datasets that we used to create interactive graphics. This dataset is the modified dataset, without any unnecessary information."),
              tabsetPanel(
                tabPanel("Suicide", dataTableOutput("OECD_suicide_datatable")),
                tabPanel("Fertility", dataTableOutput("OECD_fertility_datatable")),
                h6("Data Source: Organization for Economic Co-operation and Development")
            )),
    
    # tab for suicide rate interactive graphics
    navbarMenu("Suicide Rate",
            # first drop down menu
            tabPanel("View By Continent",
                     
                     # Application title
                     titlePanel("Suicide Rate by Continent"),
                     
                     # Application explanation
                     h6("This interactive line graph shows the trend of how the suicide rate changed over a selected year range for selected genders and countries located in selected continents."), 
                     h6(" The graph allows the user to choose an input for Year, Gender, and Continents."),
                     h6("Year: The graph will show the data for the selected year range."),
                     h6("Gender: The graph will show the data for the selected gender(Total, Men, Women)."),
                     h6("Continents: The graph will show the data for all countries that are in the selected continents."),
                     h6("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
                     h6("'Value' in our y-axis of the interactive line graph refers to the suicide rate of each country."),
                     h6("It is important to note that the number of countries in each continent is different, 
                        so the analysis of the line graph may not be perfectly accurate."),
                     h6("However, from the trends of countries in each continent, an observation can be made."),
                     h6("From the interactive line graph, we see that the suicide rates generally is the highest for countries in Europe."),
                     h6("We can see the high suicide rates for countries in Europe as we go back more in time"),
                     h6("Then follow countries in Asia, in where suicide rates has increased greatly recently, countries in Oceania, countries in Americas and a country in Africa (only one OECD country from Africa)."),
                     h6("Continent may not be the only factor that affects suicide rate, but is observed to have a correlation to the suicide rate of OECD countries."),
                     h6("User can select continents of choice to see how suicide rate change by the continents of OECD countries over selected range of time."),
                     
                     
                     # put input panels into sidebar
                     sidebarLayout(
                       sidebarPanel(
                         # slider input responsible for setting the range of years
                         sliderInput("suicide_year_continent", label = "Year", min = 1960, max = 2020, value = c(1970, 2015), step = 1),
                         # select input responsible for setting the gender
                         selectInput('suicide_perspective', label = 'Gender', choices = c("Total", "Men", "Women")),
                         # select input responsible for setting the continent
                         selectInput('suicide_continents', label = 'Continents', choices = unique(OECD_suicide_continent$Continent), multiple = TRUE)
                       ),
                       
                       mainPanel(
                         # Show a plot of the selected relationship
                         plotlyOutput(outputId = "suicide_continent_Plot")
                       )
                     )),
            # second drop down menu
            tabPanel("View By Country", 
                     
                     # Application title
                     titlePanel("Suicide Rate by Country"),
                     
                     # Application explanation
                     h6("This interactive line graph shows the trend of how the suicide rate per 100,000 people(regardless of gender) changed over a selected year range for a selected country."), 
                     h6("The line that corresponds to the selected country is shown in color, while the other lines stay gray in the background."), 
                     h6("The graph allows the user to choose an input for Year and Country."),
                     h6("Year: The graph will show the data for the selected year range."),
                     h6("Country: The graph will show the data for the selected country in color."),
                     h6("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
                     h6("'Value' in our y-axis of the interactive line graph refers to the suicide rate of each country."),
                     h6("From this graph, we can see where each country stands in comparison with all the other OECD countries in terms of suicide rate."),
                     h6("As you navigate between different countries, see how the continent of the selected OECD country correlates to the suicide rate."),

                     # put input panels into sidebar
                     sidebarLayout(
                       sidebarPanel(
                         # slider input responsible for setting the range of years
                         sliderInput("suicide_year_country", label = "Year", min = 1960, max = 2020, value = c(1970, 2015)),
                         # select input responsible for setting the country
                         selectInput('suicide_countries', label = 'Country', choices = unique(OECD_suicide_continent$Country))
                         
                         ),
                       
                       mainPanel(
                         # Show a plot of the selected relationship
                         plotlyOutput(outputId = "suicide_country_Plot")
                       )
                     ))
    ),
  
    # tab for fertility rate interactive graphics
    navbarMenu("Fertility Rate",
             tabPanel("View By Continent",
                      # Application title
                      titlePanel("Fertility Rate by Continent"),
                      
                      # Application explanation
                      h6("This interactive line graph shows the trend of how the fertility rate changed over a selected year range for countries located in selected continents."), 
                      h6("The graph allows the user to choose an input for Year and Continents."),
                      h6("Year: The graph will show the data for the selected year range."),
                      h6("Continents: The graph will show the data for all countries that are in the selected continents."),
                      h6("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
                      h6("'Value' in our y-axis of the interactive line graph refers to the fertility rate of each country."),
                      h6("It is important to note that the number of countries in each continent is different, 
                        so the analysis of the line graph may not be perfectly accurate."),
                      h6("From the interactive line graph and the trends of countries, we see that fertility rates of countries in all the continents are decreasing over time."),
                      h6("The rate of decrease may differ by each country, but we can make an observation viewing the countries by the continent."),
                      h6("We see that countries in Asia, including country like Saudi Arabia, show a strong decrease in fertility rate."),
                      h6("Then, countries in Americas and Africa show a steady decrease in fertility rate over time."),
                      h6("Lastly, countries in Europe and Oceania do show a general decrease in fertility rate over time, but not by much compared to other continents."),
                      h6("Continent may not be the only factor that affects the decrease in fertility rate over time, but is observed to have a correlation to the fertility rate of OECD countries."),
                      h6("User can select continents of choice to see how fertility rate change by the continents of OECD countries over selected range of time."),
                      
                      # put input panels into sidebar
                      sidebarLayout(
                        sidebarPanel(
                          # slider input responsible for setting the range of years
                          sliderInput("fertility_year_continent", label = "Year", min = 1960, max = 2021, value = c(1970, 2015)),
                          # select input responsible for setting the continent
                          selectInput('fertility_continents', label = 'Continents', choices = unique(OECD_fertility_continent$Continent), multiple = TRUE)
                        ),
                        
                        mainPanel(
                          # Show a plot of the selected relationship
                          plotlyOutput(outputId = "fertility_continent_Plot")
                        )
                      )),
             tabPanel("View By Country", 
                      
                      # Application title
                      titlePanel("Fertility Rate by Country"),
                      
                      # Application explanation
                      h6("This interactive line graph shows the trend of how the fertility rate changed over a selected year range for a selected country."), 
                      h6("The line that corresponds to the selected country is shown in color, while the other lines stay gray in the background."), 
                      h6("The graph allows the user to choose an input for Year and Country."),
                      h6("Year: The graph will show the data for the selected year range."),
                      h6("Country: The graph will show the data for the selected country in color."),
                      h6("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
                      h6("'Value' in our y-axis of the interactive line graph refers to the fertility rate of each country."),
                      h6("From this graph, we can see where each country stands in comparison with all the other OECD countries in terms of fertility rate."),
                      h6("As you navigate between different countries, see how the continent of the selected OECD country correlates to the fertility rate."),
                      
                      # put input panels into sidebar
                      sidebarLayout(
                        
                        sidebarPanel(
                          # slider input responsible for setting the range of years
                          sliderInput("fertility_year_country", label = "Year", min = 1960, max = 2021, value = c(1970, 2015)),
                          # select input responsible for setting the country
                          selectInput('fertility_countries', label = 'Country', choices = unique(OECD_fertility_continent$Country))
                          
                          
                        ),
                        
                        mainPanel(
                          # Show a plot of the selected relationship
                          plotlyOutput(outputId = "fertility_country_Plot")
                        )
                      ))
    )))

# Define server logic required to draw plots
server <- function(input, output) {
  
  # reactive expression for filtering suicide data by continent
  select_data_suicide_continent <- reactive(
    OECD_suicide_continent %>% 
      # filter by selected gender
      filter(Gender == input$suicide_perspective) %>%
      # filter by selected range of years
      filter(Year >= input$suicide_year_continent[1] & Year <= input$suicide_year_continent[2]) %>%
      # filter by selected continents, if none is selected, select all the continents
      filter(if(is.null(input$suicide_continents)) Continent %in% unique(Continent) else Continent %in% input$suicide_continents)
  )
  
  # Faced memory error when trying to use reactive in reactive
  
  # reactive expression for filtering suicide data by selected country
  selected_suicide_country <- reactive(
    OECD_suicide_continent %>% 
      # filter by selected range of years
      filter(Year >= input$suicide_year_country[1] & Year <= input$suicide_year_country[2]) %>%
      # filter by average of two genders
      filter(Gender == "Total") %>%
      filter(Country == input$suicide_countries)
  )
  
  # reactive expression for filtering suicide data for all the unselected countries
  unselected_suicide_countries <- reactive(
    OECD_suicide_continent %>% 
      # filter by selected range of years
      filter(Year >= input$suicide_year_country[1] & Year <= input$suicide_year_country[2]) %>%
      # filter by average of two genders
      filter(Gender == "Total") %>%
      filter(Country != input$suicide_countries)
  )
  
  
  # reactive expression for filtering fertility data by continent
  select_data_fertility_continent <- reactive(
    OECD_fertility_continent %>% 
      # filter by selected range of years
      filter(Year >= input$fertility_year_continent[1] & Year <= input$fertility_year_continent[2]) %>%
      # filter by selected continents, if none is selected, select all the continents
      filter(if(is.null(input$fertility_continents)) Continent %in% unique(Continent) else Continent %in% input$fertility_continents)
  )
  
  # reactive expression for filtering fertility data by selected country
  selected_fertility_country <- reactive(
    OECD_fertility_continent %>% 
      # filter by selected range of years
      filter(Year >= input$fertility_year_country[1] & Year <= input$fertility_year_country[2]) %>%
      filter(Country == input$fertility_countries)
  )
  
  # reactive expression for filtering fertility data for all the unselected countries
  unselected_fertility_countries <- reactive(
    OECD_fertility_continent %>% 
      # filter by selected range of years
      filter(Year >= input$fertility_year_country[1] & Year <= input$fertility_year_country[2]) %>%
      filter(Country != input$fertility_countries)
  )

  # line plot for suicide rate by continent
  output$suicide_continent_Plot <- renderPlotly({
    ggplotly(ggplot(data=OECD_suicide_continent, aes(x = Year, y = Value, color=Continent, group=Country)) +
               # make lines and points thinner
               geom_line(data=select_data_suicide_continent(), linewidth=0.5) +
               geom_point(data=select_data_suicide_continent(), size=0.8) +
               # apply colorblind friendly colors
               scale_colour_manual(values = c("Oceania" = "#E69F00", "Europe" = "#999999", "Americas" = "#009E73", "Asia"="#332288", "Africa"="#CC79A7")))
  })
  
  # line plot for suicide rate by country
  output$suicide_country_Plot <- renderPlotly({
    ggplotly(ggplot(data=OECD_suicide_continent, aes(x = Year, y = Value, group=Country, text=paste("Continent:", Continent))) +
               # lines and points for all the other countries
               geom_line(data=unselected_suicide_countries(), linewidth=0.4, alpha=0.45, color="grey") +
               geom_point(data=unselected_suicide_countries(), size=0.5, alpha=0.4, color="grey") +
               # line and points for selected country
               geom_line(data=selected_suicide_country(), linewidth=1, color="#009E73") +
               geom_point(data=selected_suicide_country(), size=0.8, color="#332288"))
  })

  # line plot for fertility rate by continent
  output$fertility_continent_Plot <- renderPlotly({
    ggplotly(ggplot(data=OECD_fertility_continent, aes(x = Year, y = Value, color=Continent, group=Country)) +
               # make lines and points thinner
               geom_line(data=select_data_fertility_continent(), linewidth=0.5) +
               geom_point(data=select_data_fertility_continent(), size=0.8) +
               # apply colorblind friendly colors
               scale_colour_manual(values = c("Oceania" = "#E69F00", "Europe" = "#999999", "Americas" = "#009E73", "Asia"="#332288", "Africa"="#CC79A7")))
  })
  
  # line plot for fertility rate by country
  output$fertility_country_Plot <- renderPlotly({
    ggplotly(ggplot(data=OECD_fertility_continent, aes(x = Year, y = Value, group=Country, text=paste("Continent:", Continent))) +
               # lines and points for all the other countries
               geom_line(data=unselected_fertility_countries(), linewidth=0.4, alpha=0.45, color="grey") +
               geom_point(data=unselected_fertility_countries(), size=0.5, alpha=0.4, color="grey") +
               # line and points for selected country
               geom_line(data=selected_fertility_country(), linewidth=1, color="#CC79A7") +
               geom_point(data=selected_fertility_country(), size=0.8, color="#E69F00"))
  })
  
  # table for suicide rate to show on Dataset page
  output$OECD_suicide_datatable <- renderDataTable({
    datatable(OECD_suicide_continent, rownames = FALSE)
  })
  
  # table for fertility rate to show on Dataset page
  output$OECD_fertility_datatable <- renderDataTable({
    datatable(OECD_fertility_continent, rownames = FALSE)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


