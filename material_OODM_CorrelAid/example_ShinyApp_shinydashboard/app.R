# -------------------------------------------------------------------------
# Topic: Shinydashboard: An example of how to create an easy ShinyApp with 
#                        echarts4r
# Name:
# Date:
# -------------------------------------------------------------------------


# Load dependencies -------------------------------------------------------

# Load dependencies
library(shiny) # Web Application Framework for R
library(shinydashboard) # Create Dashboards with 'Shiny'
library(echarts4r) # Create Interactive Graphs with 'Echarts JavaScript' Version 4
library(magrittr) # A Forward-Pipe Operator for R
library(dplyr) # A Grammar of Data Manipulation

# We use the penguin data
library(palmerpenguins) # Palmer Archipelago (Antarctica) Penguin Data


# Define UI ---------------------------------------------------------------


# Define UI for application that draws a scatter plot

ui <- dashboardPage(
    # Application title
    dashboardHeader(title = "Penguins"),
    # Sidebar with a slider input for number of bins
    dashboardSidebar(
        checkboxGroupInput(
            "penguinType",
            h4("Select a penguin species"),
            choices = list(
                "Adelie" = "Adelie",
                "Chinstrap" = "Chinstrap",
                "Gentoo" = "Gentoo"
            ),
            selected = "Adelie"
        )
    ),
    # Show a plot of the generated distribution
    dashboardBody(echarts4rOutput("penguins"))
)

# Define server  ----------------------------------------------------------


# Define server logic to draw a scatter plot
server <- function(input, output) {
    
    output$penguins <- renderEcharts4r({
        
        # Prepare the data and add colors
        penguins %<>%
            dplyr::filter(species %in% input$penguinType) %>% 
            dplyr::mutate(
                color = case_when(
                    species == "Adelie" ~ "#35b1c9",
                    species == "Chinstrap" ~ "#ebc83d",
                    species == "Gentoo" ~ "#badf55"
                )
            )
        
        # Use echarts4r to generate a scatter plot where the bill length is plotted against weight
        penguins %>%
            group_by(year) %>%
            e_charts(flipper_length_mm, timeline = TRUE) %>%
            e_scatter(body_mass_g, symbol_size = 10) %>%
            e_add("itemStyle", color) %>%
            e_axis_labels(x = "Flipper \nlength", y = "Weight (in gramm)")
    
    })
}


# Bring everything together -----------------------------------------------

# Run the application
shinyApp(ui = ui, server = server)

