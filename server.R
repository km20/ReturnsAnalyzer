#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(pracma)
library(tidyr)
library(dplyr)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data <- read.csv(file = "data.csv",header = T, sep = ";")
  data$Date <- as.Date(data$Date,"%d/%m/%Y")
  nexp <- reactive({
    round(input$lambda/(1-input$lambda))+2
  })
  df<- reactive({
    u <- (data$Date >= input$startDate & data$Date <=  input$endDate)
    data.frame(
      SMA = movavg(data[u, input$asset], n = input$mawin, type = "s"),
      EWMA = movavg(data[u, input$asset], n = nexp(), type = "e"),
      Return = data[u, input$asset]
    )
  })
  betaval <- reactive({
    u <- (data$Date >= input$startDate & data$Date <=  input$endDate)
    cov(data[u,"sp500"],data[u,input$asset])/var(data[u,"sp500"])
  })
  
  myTab <- reactive({
    u <- (data$Date >= input$startDate & data$Date <=  input$endDate)
    data.frame(Beta=betaval(), 
               E = mean(df()$Return),
               Sigma = sd(df()$Return),
               EM = mean(data[u,"sp500"]),
               SigmaM =  sd(data[u,"sp500"]))
  })
  output$summary <- renderTable(myTab(),digits = 4)
  
  output$distPlot <- renderPlot({
    u <- (data$Date >= input$startDate & data$Date <=  input$endDate)
    sdf <- df() %>% gather(key, R) %>% mutate(time =rep(data$Date[u], 3))
    g <- ggplot(data = sdf, aes(x=time, y=R, group =key, colour=key))+geom_line()
    g
  })
  output$EMVarPlot <- renderPlot({
    d <- df()
    u <- (data$Date >= input$startDate & data$Date <=  input$endDate)
    nb = length(d$Return)
    delta = (d$Return[2:nb] - d$EWMA[1:nb-1])
    EMVar = vector(mode = "numeric",nb-1)
    EMVar[1]= delta[1]^2
    for(i in 2:(nb-1)){
      EMVar[i] = input$lambda * EMVar[i-1] + (1-input$lambda)*delta[i]^2 
    }
    dates <- data$Date[u]
    dd <- data.frame(time = dates[2:nb], EMWSD= sqrt(EMVar))
    gg <- ggplot(data = dd, aes(x=time, y=EMWSD))+geom_line()
    gg
  })
})
