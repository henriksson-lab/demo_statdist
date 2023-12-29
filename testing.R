input <- list(
  
  distribution="Normal",
  
  normal_mu=0,
  normal_sigma=1,

  binom_n=10,
  binom_p=0.5
  
)

reactive <- function(f) function() f























output$dist_param_controls <- renderUI({
  if(input$distribution=="Normal"){
    p(
      
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
    )
  }
  if(input$distribution=="Binomial"){
    p(
      
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
      
    )
  }
})