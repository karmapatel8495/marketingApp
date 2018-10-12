#install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R")))

#if (!require("pacman")) install.packages("pacman")
#pacman::p_load(tidyverse, mice, e1071, Metrics, skimr, pracma, shiny, h2o)

#runApp("marketingApp", display.mode = "normal")

library(tidyverse)
library(mice)
library(e1071)
library(Metrics)
library(skimr)
library(pracma)
library(shiny)
library(h2o)
library(shinyjs)
library(shinydashboard)
library(shinythemes)

h2o.init(port = 58000)

jobList <- c(
  'Admin',
  'Blue collar',
  'Entrepreneur',
  'Housemaid',
  'Management',
  'Retired',
  'Self employed',
  'Services',
  'Student',
  'Technician',
  'Unemployed',
  'Unknown'
)

maritalList <- c('Divorced', 'Married', 'Single', 'Unknown')

educationList  <- c(
  'Elementary',
  'Middle School',
  'High School',
  'College',
  'Illiterate',
  'Professional Course',
  'University Degree',
  'Unknown'
)

yesnoList <- c('No',
               'Yes',
               'Unknown')

contactList <- c('Cellular', 'Telephone')

dayList <- c('Monday',
             'Tuesday',
             'Wednesday',
             'Thursday',
             'Friday')

monthList <- c(
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
)

poutList <- c('Failure',
              'Non-existent',
              'Success')

download.file(
  "https://www.dropbox.com/s/pegs7cqt0prez7v/GBM_model_R_1539302923604_524?dl=1",
  "GBM_model_R_1539302923604_524"
)
download.file(
  "https://www.dropbox.com/s/eqb4t5yqihe9s5u/DRF_model_R_1539302923604_463?dl=1",
  "DRF_model_R_1539302923604_463"
)
download.file(
  "https://www.dropbox.com/s/sxlbk9i0xry4dr9/DeepLearning_model_R_1539302923604_952?dl=1",
  "DeepLearning_model_R_1539302923604_952"
)
download.file(
  "https://www.dropbox.com/s/oej8101jbcnumdb/GBM_model_R_1539304335929_50?dl=1",
  "GBM_model_R_1539304335929_50"
)
download.file(
  "https://www.dropbox.com/s/6cev281ejticiei/DRF_model_R_1539304335929_1?dl=1",
  "DRF_model_R_1539304335929_1"
)
download.file(
  "https://www.dropbox.com/s/22lqmilhnyfpsds/DeepLearning_model_R_1539304335929_456?dl=1",
  "DeepLearning_model_R_1539304335929_456"
)

gbm <- h2o.loadModel("GBM_model_R_1539302923604_524")
rf <- h2o.loadModel("DRF_model_R_1539302923604_463")
nn <- h2o.loadModel("DeepLearning_model_R_1539302923604_952")

gbmerr <- h2o.loadModel("GBM_model_R_1539304335929_50")
rferr <- h2o.loadModel("DRF_model_R_1539304335929_1")
nnerr <- h2o.loadModel("DeepLearning_model_R_1539304335929_456")

ui <-
  fluidPage(theme = shinytheme("cyborg"),
            titlePanel(h2("Prediction of marketing efficiency")),
            sidebarLayout(
              sidebarPanel(
                helpText(h3("Enter the user data below:")),
                textInput(
                  inputId = "age",
                  label = "Age",
                  width = "400px"
                ),
                textInput(
                  inputId = "campaign",
                  label = "Number of contacts performed during this campaign for this client",
                  width = "400px"
                ),
                textInput(
                  inputId = "previous",
                  label = "Number of contacts performed before this campaign for this client",
                  width = "400px"
                ),
                selectInput(
                  inputId = "job",
                  label = "Job Type",
                  choices = jobList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "marital",
                  label = "Marital Status",
                  choices = maritalList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "education",
                  label = "Education Level",
                  choices = educationList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "default",
                  label = "Has Credit in Default?",
                  choices = yesnoList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "housing",
                  label = "Has Housing Loan?",
                  choices = yesnoList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "loan",
                  label = "Has Personal Loan?",
                  choices = yesnoList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "contact",
                  label = "Contact communication type",
                  choices = contactList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "day",
                  label = "Last contact day of the month",
                  choices = dayList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "month",
                  label = "Last contact month of year",
                  choices = monthList,
                  selected = NULL,
                  multiple = FALSE
                ),
                selectInput(
                  inputId = "pout",
                  label = "Outcome of the previous marketing campaign?",
                  choices = poutList,
                  selected = NULL,
                  multiple = FALSE
                ),
                checkboxInput("showgbm", "Show/Hide Gradient Boosting Prediction", value = FALSE),
                checkboxInput("showrf", "Show/Hide Random Forest Prediction", value = FALSE),
                checkboxInput("shownn", "Show/Hide Neural Network Prediction", value = FALSE)
              ),
              mainPanel(
                tabsetPanel(
                  type = "tabs",
                  tabPanel(
                    "Prediction",
                    br(),
                    textOutput("pred"),
                    textOutput("predgbm"),
                    textOutput("predrf"),
                    textOutput("prednn"),
                    hr(),
                    plotOutput("gbmpie")
                  ),
                  tabPanel("GBM Summary",
                           plotOutput("gbmerr"),
                           verbatimTextOutput("gbm")),
                  tabPanel("Random Forest Summary",
                           plotOutput("rferr"),
                           verbatimTextOutput("rf")),
                  tabPanel("Neural Network summary",
                           plotOutput("nnerr"),
                           verbatimTextOutput("nn"))
                )
              )
            ))

server <- function(input, output, session) {
  predictMarketing <- reactive({
    input_data <- data.frame(matrix(ncol = 54, nrow = 0))
    
    age_1 <- as.numeric(input$age < 30)
    age_2 <- as.numeric(input$age >= 30 & input$age <= 60)
    age_3 <- as.numeric(input$age > 60)
    
    job_1 <- as.numeric(input$job == "Admin")
    job_2 <- as.numeric(input$job == "Blue collar")
    job_3 <- as.numeric(input$job == "Entrepreneur")
    job_4 <- as.numeric(input$job == "Housemaid")
    job_5 <- as.numeric(input$job == "Management")
    job_6 <- as.numeric(input$job == "Retired")
    job_7 <- as.numeric(input$job == "Self employed")
    job_8 <- as.numeric(input$job == "Services")
    job_9 <- as.numeric(input$job == "Student")
    job_10 <- as.numeric(input$job == "Technician")
    job_11 <- as.numeric(input$job == "Unemployed")
    
    marital_1 <- as.numeric(input$marital == "Single")
    marital_2 <- as.numeric(input$marital == "Married")
    marital_3 <- as.numeric(input$marital == "Divorced")
    
    edu_1 <- as.numeric(input$education == "Elementary")
    edu_2 <- as.numeric(input$education == "Middle School")
    edu_3 <- as.numeric(input$education == "High School")
    edu_4 <- as.numeric(input$education == "College")
    edu_5 <- as.numeric(input$education == "Professional Course")
    edu_6 <- as.numeric(input$education == "University Degree")
    edu_7 <- as.numeric(input$education == "Unknown")
    
    default_1 <- as.numeric(input$default == "No")
    default_2 <- as.numeric(input$default == "Unknown")
    
    housing_1 <- as.numeric(input$housing == "No")
    housing_2 <- as.numeric(input$housing == "Yes")
    
    loan_1 <- as.numeric(input$loan == "No")
    loan_2 <- as.numeric(input$loan == "Yes")
    
    con_1 <- as.numeric(input$contact == "Cellular")
    con_2 <- as.numeric(input$contact == "Telephone")
    
    mar <- as.numeric(input$month == "March")
    apr <- as.numeric(input$month  == "April")
    may <- as.numeric(input$month  == "May")
    jun <- as.numeric(input$month  == "June")
    jul <- as.numeric(input$month  == "July")
    aug <- as.numeric(input$month  == "August")
    sep <- as.numeric(input$month  == "September")
    oct <- as.numeric(input$month  == "October")
    nov <- as.numeric(input$month  == "November")
    dec <- as.numeric(input$month  == "December")
    
    mon <- as.numeric(input$day == "Monday")
    tue <- as.numeric(input$day  == "Tuesday")
    wed <- as.numeric(input$day  == "Wednesday")
    thu <- as.numeric(input$day  == "Thursday")
    fri <- as.numeric(input$day  == "Friday")
    
    poutcome1  <- as.numeric(input$pout == "Failure")
    poutcome2  <- as.numeric(input$pout == "Non-existent")
    poutcome3  <- as.numeric(input$pout == "Success")
    
    cols <-
      c(
        "age",
        "campaign",
        "previous",
        "lnage",
        "age_1",
        "age_2",
        "age_3",
        "job_1",
        "job_2",
        "job_3",
        "job_4",
        "job_5",
        "job_6",
        "job_7",
        "job_8",
        "job_9",
        "job_10",
        "job_11",
        "marital_1",
        "marital_2",
        "marital_3",
        "edu_1",
        "edu_2",
        "edu_3",
        "edu_4",
        "edu_5",
        "edu_6",
        "edu_7",
        "default_1",
        "default_2",
        "housing_1",
        "housing_2",
        "loan_1",
        "loan_2",
        "con_1",
        "con_2",
        "mar",
        "apr",
        "may",
        "jun",
        "jul",
        "aug",
        "sep",
        "oct",
        "nov",
        "dec",
        "mon",
        "tue",
        "wed",
        "thu",
        "fri",
        "poutcome1",
        "poutcome2",
        "poutcome3"
      )
    
    colnames(input_data) <- cols
    
    current_obs <-
      c(
        as.numeric(input$age),
        as.numeric(input$campaign),
        as.numeric(input$previous),
        log(as.numeric(input$age)),
        age_1,
        age_2,
        age_3,
        job_1,
        job_2,
        job_3,
        job_4,
        job_5,
        job_6,
        job_7,
        job_8,
        job_9,
        job_10,
        job_11,
        marital_1,
        marital_2,
        marital_3,
        edu_1,
        edu_2,
        edu_3,
        edu_4,
        edu_5,
        edu_6,
        edu_7,
        default_1,
        default_2,
        housing_1,
        housing_2,
        loan_1,
        loan_2,
        con_1,
        con_2,
        mar,
        apr,
        may,
        jun,
        jul,
        aug,
        sep,
        oct,
        nov,
        dec,
        mon,
        tue,
        wed,
        thu,
        fri,
        poutcome1,
        poutcome2,
        poutcome3
      )
    
    colnames(input_data) <- cols
    input_data[1,] <- current_obs
    
    h2o.no_progress()
    
    no_list <- NULL
    yes_list <- NULL
    
    # GBM
    if (input$showgbm) {
      prediction_gbm <-  h2o.predict(gbm, newdata = as.h2o(input_data))
      output_gbm <- as.data.frame(prediction_gbm)
      output_value_gbm <- output_gbm$predict[1]
      output_no_accuracy_gbm <-
        round(as.numeric(output_gbm$no[1]) * 100, 4)
      output_yes_accuracy_gbm <-
        round(as.numeric(output_gbm$yes[1]) * 100, 4)
      no_list <- cbind(no_list, output_no_accuracy_gbm)
      yes_list <- cbind(yes_list, output_yes_accuracy_gbm)
      output$predgbm <-
        renderPrint(cat(
          paste(
            "Our Gradient Boosting model predicts that there is ",
            output_yes_accuracy_gbm,
            "% probability that the client would subscribe to a term deposit."
          )
        ))
    }
    else if (!input$showgbm) {
      output$predgbm <- renderPrint(cat(""))
    }
    
    # RF
    if (input$showrf) {
      prediction_rf <- h2o.predict(rf, newdata = as.h2o(input_data))
      output_rf <- as.data.frame(prediction_rf)
      output_value_rf <- output_rf$predict[1]
      output_no_accuracy_rf <-
        round(as.numeric(output_rf$no[1]) * 100, 4)
      output_yes_accuracy_rf <-
        round(as.numeric(output_rf$yes[1]) * 100, 4)
      no_list <- cbind(no_list, output_no_accuracy_rf)
      yes_list <- cbind(yes_list, output_yes_accuracy_rf)
      output$predrf <-
        renderPrint(cat(
          paste(
            "Our Random Forest model predicts that there is ",
            output_yes_accuracy_rf,
            "% probability that the client would subscribe to a term deposit."
          )
        ))
    }
    else if (!input$showrf) {
      output$predrf <- renderPrint(cat(""))
    }
    
    # NN
    if (input$shownn) {
      prediction_nn <- h2o.predict(nn, newdata = as.h2o(input_data))
      output_nn <- as.data.frame(prediction_nn)
      output_value_nn <- output_nn$predict[1]
      output_no_accuracy_nn <-
        round(as.numeric(output_nn$no[1]) * 100, 4)
      output_yes_accuracy_nn <-
        round(as.numeric(output_nn$yes[1]) * 100, 4)
      no_list <- cbind(no_list, output_no_accuracy_nn)
      yes_list <- cbind(yes_list, output_yes_accuracy_nn)
      output$prednn <-
        renderPrint(cat(
          paste(
            "Our Neural Network model predicts that there is ",
            output_yes_accuracy_nn,
            "% probability that the client would subscribe to a term deposit."
          )
        ))
    }
    else if (!input$shownn) {
      output$predrr <- renderPrint(cat(""))
    }
    
    pie_no <- mean(no_list)
    pie_yes <- mean(yes_list)
    
    if (input$showgbm | input$showrf | input$shownn)
    {
      output$gbmpie <- renderPlot({
        pie(
          c(pie_no, pie_yes),
          labels = c(paste("No (", pie_no, "%)"), paste("Yes (", pie_yes, "%)")),
          main = "Probability of lead conversion",
          col = c("#999999", "#108010"),
          cex = 2,
          cex.main = 3,
          border = TRUE
        )
      })
    }
    else if(!input$showgbm & !input$showrf & !input$shownn){
      output$gbmpie <- renderPrint(cat(""))
    }
  })
  
  output$age <- renderText({
    paste("Age = ", input$age)
  })
  output$campaign <- renderText({
    paste("Number of contacts performed during this campaign for this client = ",
          input$campaign)
  })
  output$previous <- renderText({
    paste("Number of contacts performed before this campaign for this client = ",
          input$previous)
  })
  output$job <- renderText({
    paste("Job Type = ", input$job)
  })
  output$marital <- renderText({
    paste("Marital Status = ", input$marital)
  })
  output$education <- renderText({
    paste("Education Level = ", input$education)
  })
  output$default <- renderText({
    paste("Has Credit in Default? = ", input$default)
  })
  output$housing <- renderText({
    paste("Has Housing Loan? = ", input$housing)
  })
  output$loan <- renderText({
    paste("Has Personal Loan? = ", input$loan)
  })
  output$contact <- renderText({
    paste("Contact communication type = ", input$contact)
  })
  output$day <- renderText({
    paste("Last contact day of the month = ", input$day)
  })
  output$month <- renderText({
    paste("Last contact month of year = ", input$month)
  })
  output$pout <- renderText({
    paste("Outcome of the previous marketing campaign? = ", input$pout)
  })
  output$pred <- renderPrint(predictMarketing())
  output$gbm <- renderPrint({
    summary(gbm)
  })
  output$rf <- renderPrint({
    summary(rf)
  })
  output$nn <- renderPrint({
    summary(nn)
  })
  output$gbmerr <- renderPlot({
    plot(gbmerr)
  })
  output$rferr <- renderPlot({
    plot(rferr)
  })
  output$nnerr <- renderPlot({
    plot(nnerr)
  })
}

shinyApp(ui = ui, server = server)
