library(plotly)
library(shiny)
library(ggplot2)

################################################################################
########### Samplemeta #########################################################
################################################################################


tab_about <- fluidPage(
  p("This demo was originally developed by ", a("Johan Henriksson", href="http://www.henlab.org")),
  p("Licensed under 2-clause BSD license, https://opensource.org/license/bsd-2-clause/")
)

################################################################################
########### Markov chain tab ###################################################
################################################################################


tab_statdist <- fluidPage(
  fluidRow(
    column(6,
           
           h3("Selecting distribution"),

           selectInput(
             inputId = "distribution",
             label = "Distribution:",
             selectize = FALSE,
             multiple = FALSE,
             choices = c("Normal","Binomial","Poisson"),
             selected = "Normal"
           ),
           
           div(class = "label-left",
   
               sliderInput(
                 inputId = "normal_mu",
                 label = "Mu:",
                 min=-10,
                 max=10,
                 value=0,
                 step=0.01
               ),
               
               sliderInput(
                 inputId = "normal_sigma",
                 label = "Sigma:",
                 min=0,
                 max=10,
                 value=1,
                 step=0.01
               ),
               
               
               sliderInput(
                 inputId = "binom_n",
                 label = "N:",
                 min=1,
                 max=100,
                 value=1,
                 step=1
               ),
               
               sliderInput(
                 inputId = "binom_p",
                 label = "p:",
                 min=0,
                 max=1,
                 value=0.5,
                 step=0.01
               ),            
               
               
               sliderInput(
                 inputId = "poisson_lambda",
                 label = "lambda:",
                 min=0,
                 max=20,
                 value=1,
                 step=0.01
               ),

           ),
           
           plotOutput(outputId = "plotCDF", height = "200px"),
           plotOutput(outputId = "plotPDF", height = "200px"),

           
    ),
    column(6,
           
           
           
           sliderInput(
             inputId = "show_minx",
             label = "Show from x:",
             min=-1000,
             max=1000,
             value=-20,
             step=1
           ),
           
           sliderInput(
             inputId = "show_maxx",
             label = "Show to x:",
             min=-1000,
             max=1000,
             value=20,
             step=1
           ),
           
           h3("Computing probability"),
           
           div(class = "label-left",
               
               sliderInput(
                 inputId = "int_from",
                 label = "Integrate from:",
                 min=-10,
                 max=10,
                 value=0,
                 step=0.01
               ),
               
               sliderInput(
                 inputId = "int_to",
                 label = "Integrate to:",
                 min=-10,
                 max=10,
                 value=0,
                 step=0.01
               ),
           ),
           textOutput(outputId = "integral_value"),
           
           
           h3("Sampling from distribution"),
           
           div(class = "label-left",
               sliderInput(
                 inputId = "num_samples",
                 label = "Number of samples:",
                 min=0,
                 max=1000,
                 value=0,
                 step=1
               ),
           ),
           
           plotOutput(outputId = "plotSamples", height = "200px"),
           
           
    ),
  )
)



################################################################################
########### Total page #########################################################
################################################################################

#https://stackoverflow.com/questions/72040479/how-to-position-label-beside-slider-in-r-shiny

ui <- fluidPage(
  tags$style(HTML(
    "
    .label-left .form-group {
      display: flex;              /* Use flexbox for positioning children */
      flex-direction: row;        /* Place children on a row (default) */
      width: 100%;                /* Set width for container */
      max-width: 400px;
    }

    .label-left label {
      margin-right: 2rem;         /* Add spacing between label and slider */
      align-self: center;         /* Vertical align in center of row */
      text-align: right;
      flex-basis: 100px;          /* Target width for label */
    }

    .label-left .irs {
      flex-basis: 300px;          /* Target width for slider */
    }
    "
  )),
  
  shinyjs::useShinyjs(),
  
  titlePanel("Demo of Statistical distributions"),

  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("General", tab_statdist),
                tabPanel("About", tab_about)
    )
  )
  
)



