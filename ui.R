#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Returns analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("asset", "Asset:", choices = c(Apple="apple", Google="google",
                                                 SP500="sp500"),
                   selected = "Apple"),
    dateInput("startDate", "Start date", value = "2015-08-31", min = "2015-08-31",
              max = "2017-11-30", format = "yyyy-mm-dd", startview = "month"),
    dateInput("endDate", "End date", value = "2015-11-30", min = "2015-08-31",
              max = "2017-11-30", format = "yyyy-mm-dd", startview = "month"),
    sliderInput("lambda","Exponential Weightening parameter", min=0, max =1,
                value = 0.95),
    numericInput("mawin", "Moving Average window size", value = 10)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Results", h2("Summary"),
                           tableOutput("summary"),
                           h2("Returns and moving averages"),
                           plotOutput("distPlot")),
                  tabPanel("Documentation",h2("Documentation"),
                           
                           p("The proposed shiny application provides analysis results for a chosen financial asset. It uses historical data to calculate the daily returns and related indicators such as moving averages, variance and Beta. The application also provides two plots showing the evolution of the daily returns and their moving averages over a given period.
                             "),
                           
                           h3("Input parameters"),
                           tags$ul(tags$li(" Asset name : An asset name from three choices: Apple, google (Alphabet) or SP500 index."),
                                   
                                   tags$li("Start Date & End Date: specify the period over which the daily returns will be used."),
                                   
                                   tags$li("Exponential weightening parameter : a slider between 0 and 1 which specifies the parameters to be used in the computation of the exponentilly weighted moving average."),
                                   
                                   tags$li("Moving average window size: number of returns to be used to compute the simple moving average of the daily returns.")),
      h3("Output"),
      p("This application provides a table containing :"),
      tags$ul(tags$li("E :the mean of the daily returns of the select asset."),
              
              tags$li("Sigma : the standard deviation of the daily returns of the select asset."),
              
              tags$li("Beta : the regression coefficient of the SP500 index daily return (see CAPM)."),
              
              tags$li("EM :the mean of the daily returns of the SP500 index."),
              tags$li("SigmaM : the standard deviation of the daily returns of SP500.")
              
              ),
      p("It also provides a plot of the daily returns and their associated moving averages (simple moving averges and exponentially weighted averages)."
      ),
    h3("Additional informations and references"),
    p("The proposed calculation are based on Capital Asset pricing model (CAPM). Further information about CAPM and Moving averages can be found on wikipedia :"),
    tags$ul(tags$li(a("Capital Asset Pricing Model.",href="https://en.wikipedia.org/wiki/Capital_asset_pricing_model") ),
            tags$li(tags$a("Moving averages.", href="https://en.wikipedia.org/wiki/Moving_average")) )
    )
  
  )
)
)))
