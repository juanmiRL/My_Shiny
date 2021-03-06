#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

list_choices <-  unique(msleep$vore)[!is.na(unique(msleep$vore))] # unique values of vore and remove na
names(list_choices) <- paste(unique(msleep$vore)[!is.na(unique(msleep$vore))],"vore",sep="") # add vore to each name

# Define UI for application that draws a histogram
ui <- fluidPage(
   
    
   # Application title
   titlePanel("This is a new Shiny app "),
   p(tags$button(class="btn btn-default", 
                 `data-toggle`="collapse", 
                 `data-target`="#collapseExample",
                 "References")),
   
   div(class="collapse", id="collapseExample",
       div(class="card card-body",
           includeMarkdown("references.rmd")
       )),
   h3("Plots"),
   sidebarLayout(
     sidebarPanel(
       selectInput("select", label = h3("Plot by type of alimentation"), 
                   choices = character(0),
                   selected = 1)
     ),
     mainPanel(
       plotOutput(outputId = "plot")
     )
   )
   
)

col_scale <- scale_colour_discrete(limits = list_choices)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  updateSelectInput(session, "select",
                    choices = list_choices,
                    selected = tail(list_choices, 1)
  )
  
  output$plot <- renderPlot({
    if(input$select != ""){
      ggplot(msleep %>% filter(vore == input$select), aes(bodywt, sleep_total, colour = vore)) +
        scale_x_log10() +
        col_scale +
        geom_point()
    }
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

