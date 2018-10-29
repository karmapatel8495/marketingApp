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

h2o.init()

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

gbm <- h2o.loadModel(GBM_model_R_1539302923604_524)
rf <- h2o.loadModel(DRF_model_R_1539302923604_463)
nn <- h2o.loadModel(DeepLearning_model_R_1539302923604_952)

gbmerr <- h2o.loadModel(GBM_model_R_1539304335929_50)
rferr <- h2o.loadModel(DRF_model_R_1539304335929_1)
nnerr <- h2o.loadModel(DeepLearning_model_R_1539304335929_456)

ui <-
  fluidPage(theme = shinytheme("cyborg"),
            titlePanel(h2("Prediction of Marketing Efficiency")),
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
                  tabPanel(
                    "GBM Summary",
                    plotOutput("gbmerr"),
                    verbatimTextOutput("gbm")
                  ),
                  tabPanel(
                    "Random Forest Summary",
                    plotOutput("rferr"),
                    verbatimTextOutput("rf")
                  ),
                  tabPanel(
                    "Neural Network summary",
                    plotOutput("nnerr"),
                    verbatimTextOutput("nn")
                  )
                )
              )
            ))

