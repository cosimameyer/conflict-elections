# -------------------------------------------------------------------------
# Topic: An example of how to create an easy ShinyApp with ggplot
# Name:
# Date:
# -------------------------------------------------------------------------


# Load dependencies -------------------------------------------------------


# Load dependencies
library(shiny) # Web Application Framework for R
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(magrittr) # A Forward-Pipe Operator for R
library(dplyr) # A Grammar of Data Manipulation

# We use the penguin data

library(palmerpenguins) # Palmer Archipelago (Antarctica) Penguin Data


# Define UI ---------------------------------------------------------------


# Define UI for application that draws a scatter plot

ui <- fluidPage(
  # Application title
  titlePanel("Penguins"),
  
  # Sidebar with check box
  sidebarLayout(
    sidebarPanel(
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
    mainPanel(plotOutput("penguins"))
  ))


# Define server  ----------------------------------------------------------


# Define server logic to draw a scatter plot
server <- function(input, output) {
  
  output$penguins <- renderPlot({
    
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
    
    # Use ggplot2 to generate a scatter plot where the flipper length is 
    # plotted against weight
    penguins %>%
      ggplot(aes(x = body_mass_g,
                 y = flipper_length_mm,
                 color = species)) +
      geom_point(size = 10) +
      labs(x = "Flipper \nlength",
           y = "Weight (in gram)")
  })
}


# Bring everything together -----------------------------------------------

# Run the application
shinyApp(ui = ui, server = server)
