library(shiny)
library(rpart)
library(caret)
library(randomForest)
require(e1071)

# Define server logic required to draw a histogram
shinyServer(function(input,output){
  
  training <- read.csv('pml-training.csv')
  inTrain  <- createDataPartition(training$classe, p=0.25, list=FALSE)
  training <- training[inTrain, ]
  NZV <- nearZeroVar(training)  #identifying variables with near zero variance
  training <- training[, -NZV]
  MajNA    <- sapply(training, function(x) mean(is.na(x))) > 0.95  #identifying majority NA variables
  training <- training[, MajNA==F]
  training <- training[, -(1:5)]    #identifying identity variables
  
  output$plot1 <- renderPlot({
  mpgInput <- input$sliderMPG
  Algorithm <- input$Algorithm
  inTrain  <- createDataPartition(training$classe, p=mpgInput/100, list=FALSE)
  TrainSet <- training[inTrain, ]
  TestSet  <- training[-inTrain, ]
  
  if (Algorithm == 'Linear Discriminant Analysis'){
    lineFit <- train(classe ~ ., data=TrainSet, method='lda')
    linePredict <- predict(lineFit, newdata=TestSet)  #prediction on test dataset
    lineMatrix <- confusionMatrix(linePredict, TestSet$classe)
    plot(lineMatrix$table, col = lineMatrix$byClass, main = paste("LDA - Accuracy =", round(lineMatrix$overall['Accuracy'], 4)))
  }
  
  if (Algorithm == 'Random Forest'){
    forestFit <- randomForest(classe ~ ., data=TrainSet)
    forestPredict <- predict(forestFit, newdata=TestSet)  #prediction on test dataset
    forestMatrix <- confusionMatrix(forestPredict, TestSet$classe)
    plot(forestMatrix$table, col = forestMatrix$byClass, main = paste("Random Forest - Accuracy =", round(forestMatrix$overall['Accuracy'], 4)))
  }
  
  if (Algorithm == 'Decision Tree'){
    treeFit <- rpart(classe ~ ., data=TrainSet, method='class')
    treePredict <- predict(treeFit, newdata=TestSet, type='class')  #prediction on test dataset
    treeMatrix <- confusionMatrix(treePredict, TestSet$classe)
    plot(treeMatrix$table, col = treeMatrix$byClass, main = paste("Decision Tree - Accuracy =", round(treeMatrix$overall['Accuracy'], 4)))
  }
  })
  
  output$plot2 <- renderPlot({
    expInput <- input$sliderEXP
    msn=NULL
    for (i in 1 : expInput) msn = c(msn, mean(rexp(40,0.2)))
    data2 <- data.frame(msn,size=40)
    ggplot(data2,aes(x=msn,fill=size)) + geom_histogram(aes(y=..density..),alpha=0.7,binwidth=.25,col="black") + 
    ylim(c(0,0.6))+ stat_function(fun=dnorm,args=list(mean=5,sd=sd(msn)))+ xlab("Averages of the distribution") + 
    ylab("Frequency")+ggtitle(paste0("Distribution of the averages of 40 random exponentials (",expInput," simulations)"))
  })
  
    })
