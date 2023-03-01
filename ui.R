library(shiny)
library(ggplot2)
dataset <- diamonds
shinyUI(navbarPage(title <- tags$a(href='https://www.google.com',
                                                    tags$img(src="img/cmcLogo.png", height = '50', width = '50'),
                                                    'CHRISTIAN MEDICAL COLLEGE', target="_blank"),
                   theme = 'css/main.css',
                   
                   footer = includeHTML('footer.html'),
                   
                   tabPanel("welcome", 
                            includeHTML('index.html'),
                            
                   ),
                   
                   
                   tabPanel("Data Management", sidebarLayout(
                     
                     # Sidebar panel for inputs ----
                     sidebarPanel(
                       
                       # Input: Select a file ----
                       fileInput("file1", "Choose CSV File",
                                 multiple = FALSE,
                                 accept = c("text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")),
                       
                       # Horizontal line ----
                       tags$hr(),
                       
                       # Input: Checkbox if file has header ----
                       checkboxInput("header", "Header", TRUE),
                       
                       # Input: Select separator ----
                       radioButtons("sep", "Separator",
                                    choices = c(Comma = ",",
                                                Semicolon = ";",
                                                Tab = "\t"),
                                    selected = ","),
                       
                       # Input: Select quotes ----
                       radioButtons("quote", "Quote",
                                    choices = c(None = "",
                                                "Double Quote" = '"',
                                                "Single Quote" = "'"),
                                    selected = '"'),
                       
                       # Horizontal line ----
                       tags$hr(),
                       
                       # Input: Select number of rows to display ----
                       radioButtons("disp", "Display",
                                    choices = c(Head = "head",
                                                All = "all"),
                                    selected = "head")
                       
                     ),
                     
                     # Main panel for displaying outputs ----
                     mainPanel(
                       
                       # Output: Data file ----
                       tableOutput("contents")
                       
                     )
                     
                   )),
                   
                   
                   tabPanel("overview",
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("b", "Select no. of BINs", min = 5, max = 20,value = 10)
                              ),
                              mainPanel(
                                plotOutput("plot")
                              )
                            )
                   ),
                   
                   
                   
                   
                   tabPanel("follow up", sidebarLayout(
                     sidebarPanel(
                       selectInput(inputId = "var1", label = "Select the X variable", choices = c("Sepal.Length" = 1, "Sepal.Width" = 2, "Petal.Length" = 3, "Petal.Width" = 4)),
                       selectInput(inputId = "var2", label = "Select the Y variable", choices = c("Sepal.Length" = 1, "Sepal.Width" = 2, "Petal.Length" = 3, "Petal.Width" = 4), selected = 2),
                       radioButtons(inputId = "var3", label = "Select the file type", choices = list("png", "pdf"))
                     ),
                     mainPanel(
                       plotOutput("dplot"),
                       downloadButton(outputId = "down", label = "Download the plot")
                     )
                   )),
                   tabPanel("HAI", sidebarLayout(
                     sidebarPanel(
                       selectInput("dataset", "Select the dataset", choices = c("iris", "mtcars", "trees")),
                       br(),
                       helpText(" Select the download format"),
                       radioButtons("type", "Format type:",
                                    choices = c("Excel (CSV)", "Text (TSV)","Text (Space Separated)", "Doc")),
                       br(),
                       helpText(" Click on the download button to download the dataset observations"),
                       downloadButton('downloadData', 'Download')
                       
                     ),
                     mainPanel(
                       
                       tableOutput('table')
                     )
                   )),
                   tabPanel("Microbiology", sidebarLayout(
                     
                     # Sidebar to demonstrate various slider options ----
                     sidebarPanel(
                       
                       # Input: Simple integer interval ----
                       sliderInput("integer", "Integer:",
                                   min = 0, max = 1000,
                                   value = 500),
                       
                       # Input: Decimal interval with step value ----
                       sliderInput("decimal", "Decimal:",
                                   min = 0, max = 1,
                                   value = 0.5, step = 0.1),
                       
                       # Input: Specification of range within an interval ----
                       sliderInput("range", "Range:",
                                   min = 1, max = 1000,
                                   value = c(200,500)),
                       
                       # Input: Custom currency format for with basic animation ----
                       sliderInput("format", "Custom Format:",
                                   min = 0, max = 10000,
                                   value = 0, step = 2500,
                                   pre = "$", sep = ",",
                                   animate = TRUE),
                       
                       # Input: Animation with custom interval (in ms) ----
                       # to control speed, plus looping
                       sliderInput("animation", "Looping Animation:",
                                   min = 1, max = 2000,
                                   value = 1, step = 10,
                                   animate =
                                     animationOptions(interval = 300, loop = TRUE))
                       
                     ),
                     
                     # Main panel for displaying outputs ----
                     mainPanel(
                       
                       # Output: Table summarizing the values entered ----
                       tableOutput("values")
                       
                     )
                   )),
                   tabPanel("AMR",fluidRow(
                     # column allocation for widgets
                     column(4,
                            
                            sliderInput('sampleSize', 'Sample Size', 
                                        min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
                                        step=500, round=0),
                            br(),
                            checkboxInput('jitter', 'Jitter'),
                            checkboxInput('smooth', 'Smooth')
                     ),
                     column(4,
                            selectInput('x', 'X', names(dataset)),
                            selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
                            selectInput('color', 'Color', c('None', names(dataset)))
                     ),
                     column(4,
                            selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
                            selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
                     )
                   ), ## End of the fluidRow and grid
                   hr(),
                   plotOutput("fplot")),
                   tabPanel("FAQ", includeHTML('faq.html')),
                   
))