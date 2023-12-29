library(plotly)
library(Cairo)

options(shiny.usecairo=T)


if(FALSE){
  install.packages("matlib")
}



if(FALSE){
  #To run this app
  library(shiny)
  runApp(".")
}


server <- function(input, output, session) {


  ##############################################################################
  ########### Update controllers as needed #####################################
  ##############################################################################


  observe({
    #Note that this requires shinyjs::useShinyjs() in ui.R
    
    shinyjs::toggle("normal_mu",condition=input$distribution=="Normal")
    shinyjs::toggle("normal_sigma",condition=input$distribution=="Normal")
    
    shinyjs::toggle("binom_n",condition=input$distribution=="Binomial")
    shinyjs::toggle("binom_p",condition=input$distribution=="Binomial")

    shinyjs::toggle("poisson_lambda",condition=input$distribution=="Poisson")
    
    
  })
  
  observe({
    from <- min(input$show_minx,input$show_maxx) 
    to <- max(input$show_minx,input$show_maxx) 
    updateSliderInput(session,"int_from", min = from, max=to)
    updateSliderInput(session,"int_to", min = from, max=to)
  })
  
    
  ##############################################################################
  ########### Distribution functions ###########################################
  ##############################################################################
  
  getDistPDF <- function(){
    if(input$distribution=="Normal"){
      return(function(x) dnorm(x, input$normal_mu, input$normal_sigma))
    }
    if(input$distribution=="Binomial"){
      return(function(x) dbinom(x, input$binom_n, input$binom_p))
    }
    if(input$distribution=="Poisson"){
      return(function(x) dpois(x, input$poisson_lambda))
    }
  }
  
  getDistCDF <- function(){
    if(input$distribution=="Normal"){
      return(function(x) pnorm(x, input$normal_mu, input$normal_sigma))
    }
    if(input$distribution=="Binomial"){
      return(function(x) pbinom(x, input$binom_n, input$binom_p))
    }
    if(input$distribution=="Poisson"){
      return(function(x) ppois(x, input$poisson_lambda))
    }
  }
  
  getDistRandom <- function(){
    if(input$distribution=="Normal"){
      return(function(x) rnorm(x, input$normal_mu, input$normal_sigma))
    }
    if(input$distribution=="Binomial"){
      return(function(x) rbinom(x, input$binom_n, input$binom_p))
    }
    if(input$distribution=="Poisson"){
      return(function(x) rpois(x, input$poisson_lambda))
    }
  }
  
  
  getXToShow <- function(){
    if(input$distribution=="Normal"){
      return(seq(from=input$show_minx, to=input$show_maxx, length.out=500))
    }
    if(input$distribution=="Binomial"){
      return(seq(from=input$show_minx, to=input$show_maxx, by=1))
    }
    if(input$distribution=="Poisson"){
      return(seq(from=max(0,input$show_minx), to=input$show_maxx, by=1))
    }
  }
  
  
  getIsDiscrete <- function(){
    if(input$distribution=="Normal"){
      return(FALSE)
    }
    if(input$distribution=="Binomial"){
      return(TRUE)
    }
    if(input$distribution=="Poisson"){
      return(TRUE)
    }
  }
  
  ##############################################################################
  ########### Output ###########################################################
  ##############################################################################
  
  
  output$plotPDF <- renderPlot({
    dat <- data.frame(
      x=getXToShow()
    )
    dat$p <- getDistPDF()(dat$x)
    dat$in_integral <- input$int_from < dat$x  & dat$x < input$int_to
    
    if(getIsDiscrete()){
      ggplot(dat, aes(x,p,fill=in_integral)) + geom_bar(stat = "identity") +
        ylab("Probability density")+
        xlim(c(input$show_minx,input$show_maxx))
    } else {
      ggplot(dat, aes(x,p)) + geom_line() +
        geom_area(data = dat[dat$in_integral,], fill="red") +
        ylab("Probability density")+
        xlim(c(input$show_minx,input$show_maxx))
    }
  })
  
  
  output$plotCDF <- renderPlot({
    dat <- data.frame(
      x=getXToShow()
    )
    dat$p <- getDistCDF()(dat$x)
    if(getIsDiscrete()){
      ggplot(dat, aes(x,p)) + geom_bar(stat = "identity") +
        ylab("Cumulate probability density")  +
        xlim(c(input$show_minx,input$show_maxx))
    } else {
      ggplot(dat, aes(x,p)) + geom_line()  +
        ylab("Cumulate probability density")  +
        xlim(c(input$show_minx,input$show_maxx))
    }
  })
  
  
  output$integral_value <- renderText({
    p <- getDistCDF()(input$int_to) - getDistCDF()(input$int_from)
    paste("Integral of area, the probability:",p)
  })
  
  
  output$plotSamples <- renderPlot({
    dat <- data.frame(
      x=getDistRandom()(input$num_samples),
      y=runif(input$num_samples, min=-0.2, max=0.2) #rep(0,input$num_samples)
    )

    ggplot(dat, aes(x,y)) + geom_point()+
      ylim(c(-1,1))+
      xlim(c(input$show_minx,input$show_maxx))
  })
  
}





