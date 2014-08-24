library(ggvis)
library(googleVis)
# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(
  navbarPage("Nutrition Application - USDA Data",
             tabPanel("Explore Food",
                      fluidPage(
                        fluidRow(  
                          column(3,
                                 wellPanel(
                                   h5("Filters"),
                                   selectInput("fg", "Food Groups", fg_vars, selected = "0000",multiple = FALSE),
                                   textInput("description", "Food Description")
                                 ),
                                 wellPanel(
                                   h5("Axis Selection"),
                                   selectInput("xvar", "X-axis variable", axis_vars, selected = "Protein"),
                                   selectInput("yvar", "Y-axis variable", axis_vars, selected = "Carbohydrate")
                                 )
                          ),    
                          column(4,
                                 ggvisOutput("plot1")
                          ),
                          column(4, offset = 1,
                                 wellPanel( h5(textOutput("text1"))  ,
                                            htmlOutput("viewx"),
                                            htmlOutput("viewy")
                                 ) 
                          )
                        ),
                        fluidRow(
                          column(4, offset = 1,
                                 #  tableOutput("details")
                                 htmlOutput("details")
                          )
                        )  
                      )),
             tabPanel("Data",
                      dataTableOutput(outputId="table"),
                      downloadButton('downloadData', 'Download')
             ),
             tabPanel("About",
                      includeMarkdown("about.md")      
             )  
  )
)