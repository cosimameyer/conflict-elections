# -------------------------------------------------------------------------
# Topic: Shinydashboard: An example of how to create an easy ShinyApp with 
#                        ggplot2
# Name:
# Date:
# -------------------------------------------------------------------------

# Load dependencies -------------------------------------------------------

# Load dependencies
library(shiny) # Web Application Framework for R
library(shinydashboard) # Create Dashboards with 'Shiny'
library(ggplot2)
library(magrittr) # A Forward-Pipe Operator for R
library(dplyr) # A Grammar of Data Manipulation

# We use the penguin data
library(palmerpenguins) # Palmer Archipelago (Antarctica) Penguin Data


# Define UI ---------------------------------------------------------------


# Define UI for application that draws a scatter plot

ui <- dashboardPage(
  # Application title
  dashboardHeader(title = "Penguins"),
  
  # Sidebar with check box
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
  # Show a plot
  dashboardBody(plotOutput("penguins"))
)

# Define server  ----------------------------------------------------------

# Define server logic to draw a scatter plot
server <- function(input, output) {
  
  output$penguins <- renderPlot({
    
    # Prepare the data and add colors
    penguins %<>%
      dplyr::filter(species %in% input$penguinType)
    
    # Use ggplot2 to generate a scatter plot where the flipper length is 
    # plotted against weight
    penguins %>%
      ggplot(aes(
        x = body_mass_g,
        y = flipper_length_mm,
        color = species)) +
      geom_point() +
      labs(x = "Flipper \nlength",
           y = "Weight (in gram)") +
      theme_minimal()
  })
}


# Bring everything together -----------------------------------------------

# Run the application
shinyApp(ui = ui, server = server)
