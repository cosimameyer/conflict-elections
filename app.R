# ------------------------------------------------------------------------------
# Topic: Shiny App:  Electoral violence in Afghanistan
# Name: Cosima Meyer
# Date: August 2020
# ------------------------------------------------------------------------------


# Load dependencies ------------------------------------------------------------

## Deploying the ShinyApp on shinyapps.io is easy. You can follow this
# [guide](https://shiny.rstudio.com/articles/shinyapps.html). Shiny requires you
# to load all packages with library (once they are installed locally).

# Uncomment if not installed
# install.packages(c("shiny",
#               "shinydashboard",
#               "magrittr",
#               "dplyr",
#               "lubridate",
#               "dashboardthemes",
#               "highcharter",
#               "shinyWidgets",
#               "ggplot2",
#               "overviewR",
#               "shinydashboard",
#               "emojifont",
#               "shinythemes"
#               ))
# devtools::install_github("JohnCoene/echarts4r", force=TRUE)
# remotes::install_github('JohnCoene/echarts4r.maps', force=TRUE)
# devtools::install_github("ropenscilabs/icon")

library(shiny) # Web Application Framework for R
library(shinydashboard) # Create Dashboards with 'Shiny' # Create Dashboards 
                        # with 'Shiny'
library(magrittr) # A Forward-Pipe Operator for R
library(dplyr) # A Grammar of Data Manipulation
library(lubridate) # Make Dealing with Dates a Little Easier
library(dashboardthemes) # Customise the Appearance of 'shinydashboard' 
                         # Applications using Themes
library(highcharter) # A Wrapper for the 'Highcharts' Library
library(shinyWidgets) # Custom Inputs Widgets for Shiny
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of 
                 # Graphics
library(overviewR) # Easily Extracting Information About Your Data
library(shinydashboard) # Create Dashboards with 'Shiny' # Create Dashboards 
                        # with 'Shiny'
library(emojifont) # Emoji and Font Awesome in Graphics
library(shinythemes) # Themes for Shiny
library(echarts4r) # load echarts4r
library(echarts4r.maps) # Maps for 'echarts4r'
library(icon) # Icon web-fonts for RMarkdown

load.fontawesome()

# Helper functions
source(file = "code/helper.R")
source(file = "code/theme_custom.R")

# Load data
load("data/data.RData")

# Generate hw object (will be used later)
hw <- list(
  "Election day" = 1,
  "1 - 30 days prior to election" = 2,
  "31 - 60 days prior to election" = 3,
  "61 - 90 days prior to election" = 4,
  "91 - 120 days prior to election" = 5,
  "121 - 150 days prior to election" = 6,
  "151 - 180 days prior to election" = 7
)

# UI ---------------------------------------------------------------------------

ui <- dashboardPage(
  # Define header --------------------------------------------------------------
  dashboardHeader(title = "Conflict elections", titleWidth = 300),
  
  # Define sidebar -------------------------------------------------------------
  dashboardSidebar(
    width = 300,
    # Add selection on date
    pickerInput(
      inputId = "dateEvent",
      label = "Select time period",
      choices = hw,
      selected = 1,
      options = list(
        `actions-box` = TRUE,
        size = 10,
        `selected-text-format` = "count > 1"
      ),
      multiple = TRUE
    ),
    # Add selection on type of violence
    checkboxGroupInput(
      "dateType",
      h4("Select the type of violence"),
      choices = list(
        "Battles" = "Battles",
        "Violence against civilians" = "Violence against civilians",
        "Strategic developments" = "Strategic developments",
        "Explosions/Remote violence" = "Explosions/Remote violence"
      ),
      selected = "Battles"
    )
  ),
  
  # Main body ------------------------------------------------------------------
  dashboardBody(
    # Define themes ------------------------------------------------------------
    
    # Define colors for the value boxes
    tags$style(
      ".small-box.bg-blue { background-color: #046C9A !important; color: #000000 !important; }"
    ),
    tags$style(
      ".small-box.bg-black { background-color: #C93312 !important; color: #000000 !important; }"
    ),
    tags$style(
      ".small-box.bg-olive { background-color: #446455 !important; color: #000000 !important; }"
    ),
    tags$style(
      ".small-box.bg-red { background-color: #899DA4 !important; color: #000000 !important; }"
    ),
    # Define theme
    customTheme,
    
    navbarPage(
      title = "",
      
      # Tab 1: Add map and bar charts ------------------------------------------
      tabPanel("Map",
               icon = icon("map"),
               
               fluidRow(
                 column(8,
                        echarts4rOutput(
                          "mymap", height = 600, width = 700
                        )),
                 column(width = 3,  echarts4rOutput(
                   "barchart", height = 300, width = 380
                 )),
                 column(
                   width = 3,
                   echarts4rOutput("barchart_nona", height = 300, width = 380)
                 ),
               )),
      
      # Tab 2: Add table overview ----------------------------------------------
      tabPanel(
        "Table",
        fluidRow(
          valueBoxOutput("battle", width = 3),
          valueBoxOutput("remote", width = 3),
          valueBoxOutput("strat", width = 3),
          valueBoxOutput("civil", width = 3)
        ),
        dataTableOutput('table2'),
        icon = icon("table")
      ),
      
      # Tab 3: About -----------------------------------------------------------
      tabPanel("About",
               icon = icon("home"),
               mainPanel(div(
                 includeMarkdown("markdown/about.md")
               ))),
      
      # Tab 4: Github ----------------------------------------------------------
      tabPanel("Github", icon = icon("fab fa-github"),
               mainPanel(div(
                 includeMarkdown("markdown/git.md")
               )))
      
    )
  )
)




# Server -----------------------------------------------------------------------


server <- function(input, output) {
  # Value box ------------------------------------------------------------------
  # This code is inspired by this great guide:
  # https://jkunst.com/blog/posts/2020-06-26-valuebox-and-sparklines/
  
  # Value box for battles
  output$battle <- renderValueBox({
    filteredData <- data %>%
      dplyr::filter(Type == "Battles") %>%
      dplyr::mutate(
        month = month(Date),
        month = case_when(
          month == 4 ~ "4 - April",
          month == 5 ~ "5 - May",
          month == 6 ~ "6 - June",
          month == 7 ~ "7 - July",
          month == 8 ~ "8 - August",
          month == 9 ~ "9 - September"
        )
      ) %>%
      group_by(month) %>%
      dplyr::summarise(sum_fatal = sum(Fatalities))
    
    hc <-
      hchart(filteredData, "area", hcaes(month, sum_fatal), name = "")  %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())
    
    valueBoxSpark(
      h5("Battles"),
      filteredData <- data %>%
        dplyr::filter(Type == "Battles" &
                        time_dummy %in% input$dateEvent) %>%
        dplyr::summarise(sum(Fatalities)),
      sparkobj = hc,
      info = "These are all fatalities that occured due to battles at the time points you selected.",
      color = "blue"
    )
  })
  # Value box for explosions and remote violence
  output$remote <- renderValueBox({
    filteredData <- data %>%
      dplyr::filter(Type == "Explosions/Remote violence") %>%
      dplyr::mutate(
        month = month(Date),
        month = case_when(
          month == 4 ~ "4 - April",
          month == 5 ~ "5 - May",
          month == 6 ~ "6 - June",
          month == 7 ~ "7 - July",
          month == 8 ~ "8 - August",
          month == 9 ~ "9 - September"
        )
      ) %>%
      group_by(month) %>%
      dplyr::summarise(sum_fatal = sum(Fatalities))
    
    hc <-
      hchart(filteredData, "area", hcaes(month, sum_fatal), name = "")  %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())
    
    valueBoxSpark(
      h5("Explosions \n and remote violence"),
      filteredData <- data %>%
        dplyr::filter(
          Type == "Explosions/Remote violence" &
            time_dummy %in% input$dateEvent
        ) %>%
        dplyr::summarise(sum(Fatalities)),
      sparkobj = hc,
      color = "black",
      info = "These are all fatalities that occured due to explosions and remote violence at the time points you selected."
    )
    
    
  })
  # Value box for strategic development
  output$strat <- renderValueBox({
    filteredData <- data %>%
      dplyr::filter(Type == "Strategic developments") %>%
      dplyr::mutate(
        month = month(Date),
        month = case_when(
          month == 4 ~ "4 - April",
          month == 5 ~ "5 - May",
          month == 6 ~ "6 - June",
          month == 7 ~ "7 - July",
          month == 8 ~ "8 - August",
          month == 9 ~ "9 - September"
        )
      ) %>%
      dplyr::group_by(month) %>%
      dplyr::summarise(sum_fatal = sum(Fatalities))
    
    hc <-
      hchart(filteredData, "area", hcaes(month, sum_fatal), name = "")  %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())
    
    valueBoxSpark(
      h5("Strategic development"),
      filteredData <- data %>%
        dplyr::filter(
          Type == "Strategic developments" &
            time_dummy %in% input$dateEvent
        ) %>%
        dplyr::summarise(sum(Fatalities)),
      sparkobj = hc,
      info = "These are all fatalities that occured due to strategic developments at the time points you selected.",
      color = "olive"
    )
    
    
  })
  # Value box for violence against civilians
  output$civil <- renderValueBox({
    filteredData <- data %>%
      dplyr::filter(Type == "Violence against civilians") %>%
      dplyr::mutate(
        month = month(Date),
        month = case_when(
          month == 4 ~ "4 - April",
          month == 5 ~ "5 - May",
          month == 6 ~ "6 - June",
          month == 7 ~ "7 - July",
          month == 8 ~ "8 - August",
          month == 9 ~ "9 - September"
        )
      ) %>%
      group_by(month) %>%
      dplyr::summarise(sum_fatal = sum(Fatalities))
    
    hc <-
      hchart(filteredData, "area", hcaes(month, sum_fatal), name = "")  %>%
      hc_size(height = 100) %>%
      hc_credits(enabled = FALSE) %>%
      hc_add_theme(hc_theme_sparkline_vb())
    
    valueBoxSpark(
      h5("Violence against civilians"),
      filteredData <- data %>%
        dplyr::filter(
          Type == "Violence against civilians" &
            time_dummy %in% input$dateEvent
        ) %>%
        dplyr::summarise(sum(Fatalities)),
      sparkobj = hc,
      info = "These are all fatalities that occured due violence against civilians at the time points you selected.",
      color = "red"
    )
    
    
  })
  
  # custom scaling function to make sure that also zero values are shown
  # and the different sizes are at most half of each other
  my_scale <- function(x) scales::rescale(x, to = c(10, 20))
  
  # The following plots (including the map) are generated with the package 
  # echarts4r (https://echarts4r.john-coene.com)
  # Map ------------------------------------------------------------------------
  output$mymap <- renderEcharts4r({
    # Filter data by input
    filteredData <- data %>%
      dplyr::filter(Type %in% input$dateType &
                      time_dummy %in% input$dateEvent)
    
    # Use filtered data to plot the map
    filteredData %>%
      dplyr::mutate(
        color = case_when(
          Type == "Battles" ~ "#046C9A",
          Type == "Explosions/Remote violence" ~ "#C93312",
          Type == "Strategic developments" ~ "#446455",
          Type == "Violence against civilians" ~ "#899DA4"
        )
      ) %>%
      group_by(month = month(Date, label = FALSE)) %>%
      e_charts(longitude,
               timeline = TRUE) %>% #, timeline = TRUE) %>%
      em_map("Afghanistan") %>%
      e_geo("Afghanistan") %>%
      
      e_scatter(
        latitude,
        size = Fatalities,
        scale = my_scale,
        coord_system = "geo",
        legend = FALSE
      ) %>%
      e_timeline_serie(title = list(
        list(text = "Afghanistan - April 2019"),
        list(text = "Afghanistan - May 2019"),
        list(text = "Afghanistan - June 2019"),
        list(text = "Afghanistan - July 2019"),
        list(text = "Afghanistan - August 2019"),
        list(text = "Afghanistan - September 2019")
      )) %>%
      e_add("itemStyle", color) %>%
      e_tooltip(
        formatter = htmlwidgets::JS(
          "
                                        function(params){
                                        return('<strong>' +
                                        'Fatalities: ' +  params.value[2])   }  "
        )
      ) %>%
      e_toolbox_feature(feature = "saveAsImage",
                        title = "Save as image")  %>%
      e_group("grp")
    
  })
  
  # Barplot 1 ------------------------------------------------------------------
  output$barchart <- renderEcharts4r({
    # Filter data by input
    
    filteredData <- data %>%
      dplyr::filter(Type %in% input$dateType &
                      time_dummy %in% input$dateEvent) %>%
      group_by(Type, Date) %>%
      count() %>%
      dplyr::mutate(
        color = case_when(
          Type == "Battles" ~ "#046C9A",
          Type == "Explosions/Remote violence" ~ "#C93312",
          Type == "Strategic developments" ~ "#446455",
          Type == "Violence against civilians" ~ "#899DA4"
        ),
        Type = case_when(
          Type == "Battles" ~ "Battles",
          Type == "Explosions/Remote violence" ~ "Explosions/\nRemote \nviolence",
          Type == "Strategic developments" ~ "Strategic\ndevelopment",
          Type == "Violence against civilians" ~ "Violence\nagainst \ncivilians"
        )
      )
    
    
    # Use filtered data to generate bar plot 1
    filteredData %>%
      group_by(month(Date, label = FALSE)) %>%
      e_charts(Type, timeline = TRUE, show = FALSE) %>%
      e_bar(n) %>%
      e_legend(FALSE) %>%  # hide legend
      e_title("Bar charts", "Total number of occassions", color = "#ffffff") %>%
      e_toolbox_feature(feature = "saveAsImage",
                        title = "Save as image") %>%
      e_add("itemStyle", color) %>%
      e_color(background = NULL) %>%
      e_group("grp") %>%  # assign group
      e_connect_group("grp") %>% 
      e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize = 10)) # rotate label
    
    
  })
  
  # Barplot 2 ------------------------------------------------------------------
  output$barchart_nona <- renderEcharts4r({
    # Filter data by input
    
    filteredData <- data %>%
      dplyr::filter(Type %in% input$dateType &
                      time_dummy %in% input$dateEvent)
    # Use filtered data to proceed
    dat <- filteredData %>%
      dplyr::filter(Fatalities != 0) %>%
      dplyr::group_by(Type, Date) %>%
      dplyr::summarise(sum_fatalities = sum(Fatalities)) %>%
      dplyr::mutate(
        color = case_when(
          Type == "Battles" ~ "#046C9A",
          Type == "Explosions/Remote violence" ~ "#C93312",
          Type == "Strategic developments" ~ "#446455",
          Type == "Violence against civilians" ~ "#899DA4"
        ),
        Type = case_when(
          Type == "Battles" ~ "Battles",
          Type == "Explosions/Remote violence" ~ "Explosions/ \nRemote \nviolence",
          Type == "Strategic developments" ~ "Strategic \ndevelopment",
          Type == "Violence against civilians" ~ "Violence \nagainst \ncivilians"
        )
      ) %>%
      ungroup()
    # And to generate bar plot 2
    dat %>%
      group_by(month(Date, label = FALSE)) %>%
      e_charts(Type, timeline = TRUE, show = FALSE) %>%
      e_bar(sum_fatalities) %>%
      e_add("itemStyle", color) %>%
      e_title("", "Total number of fatalities") %>%
      e_legend(FALSE) %>%  # Hide the legend
      e_toolbox_feature(feature = "saveAsImage",
                        title = "Save as image") %>%
      e_group("grp") %>%  # assign group
      e_connect_group("grp") %>% 
      e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize = 10)) # rotate label 
  })
  
  
  # Table ----------------------------------------------------------------------
  output$table2 <- renderDataTable({
    # Filter data by input and generate a table based on pre-specified input
    data %>%
      dplyr::filter(Type %in% input$dateType &
                      time_dummy %in% input$dateEvent) %>%
      dplyr::select(Date, Type, Location, Fatalities, Actor1, Actor2, Notes)
  })
  
  
}


# Bring everything together ----------------------------------------------------

shinyApp(ui, server)


