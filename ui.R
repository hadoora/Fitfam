library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exponentials & Prediction Algorithms"),
  br(),
  p(h4( class='simpleDiv', 'Welcome to my first Shiny app!')),
  br(),
  p(h4( class='simpleDiv', 'The first part of this app demonstrates the Gaussian nature of the means of 40 random exponents.')),
  p(h4( class='simpleDiv', 'It allows you, the user, to observe the sharpness of the Gauss curve as the number of simulations approaches six digits.')),
  p(h4( class='simpleDiv', 'Simply drag the slider to specify ur chosen number of simulations and hit the submit button.')),  
  p(h4( class='simpleDiv', 'For each simulation, the mean of 40 random exponents is taken, and the resultant curve is more Gaussian as the simulations increase.')),
  br(),
  p(h4( class='simpleDiv', 'The second part of the app compares the accuracies of three prediction algorithms using different training set sizes of the same data set.')),
  p(h4( class='simpleDiv', 'Both algorithm and training set size can be varied using the selector and the slider respectively.')),
  p(h4( class='simpleDiv', 'The plot is derived reactively from the calculated confusion matrix.')),
  p(h4( class='simpleDiv', 'Due to the complex nature of the computation, you must hit the submit button after every change to the paramters.')),
  br(),
  p(h4( class='simpleDiv', 'Enjoy!')),
  br(),
  sidebarLayout(
    sidebarPanel(
      sliderInput('sliderEXP','Select simulation count', 1000, 100000, value = 10000),
      sliderInput('sliderMPG','Select training set size in %', 50, 90, value = 70),
      selectInput('Algorithm', 'Select Algorithm', c('Decision Tree','Linear Discriminant Analysis','Random Forest')),
      submitButton('Submit')
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput('plot2'),
      plotOutput('plot1')
    )
  )
))