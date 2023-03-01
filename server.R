library(shiny)
library(datasets)

shinyServer(function(input, output, session) {
  
  
  #welcome
  # for display of mtcars dataset in the "Data Page"
  output$data <- renderTable({
    mtcars
  })
  
  # for display of histogram in the "Widget & Sidepar page"
  output$plot <- renderPlot({
    hist(mtcars$mpg, col ="blue", breaks=input$b )
  })
  
  # for display of mtcars dataset summary statistics in the "Menu item A page"
  output$summary <- renderPrint({
    summary(mtcars)
  })
  
  #end of welcome
  
  
  
  #data management
  
  
  
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  
  
  #start of iris
  
  x <- reactive({
    iris[,as.numeric(input$var1)]
  })
  # x contains all the observations of the y variable selected by the user. Y is a reactive function
  y <- reactive({
    iris[,as.numeric(input$var2)]
    
  })
  # xl contains the x variable or column name of the iris dataset selected by the user
  xl <- reactive({
    names(iris[as.numeric(input$var1)])
  })
  # yl contains the y variable or column name of the iris dataset selected by the user
  yl <- reactive({
    names(iris[as.numeric(input$var2)])
  })
  
  # render the plot so could be used to display the plot in the mainPanel
  output$dplot <- renderPlot({
    plot(x=x(), y=y(), main = "iris dataset plot", xlab = xl(), ylab = yl())
    
  })
  
  # downloadHandler contains 2 arguments as functions, namely filename, content
  output$down <- downloadHandler(
    filename =  function() {
      paste("iris", input$var3, sep=".")
    },
    # content is a function with argument file. content writes the plot to the device
    content = function(file) {
      if(input$var3 == "png")
        png(file) # open the png device
      else
        pdf(file) # open the pdf device
      plot(x=x(), y=y(), main = "iris dataset plot", xlab = xl(), ylab = yl()) # draw the plot
      dev.off()  # turn the device off
      
    } 
  )
  
  
  #HAI
  
  ###### Reactive function to fetch the dataset observations based on the user's choice ---- > this will be used in the renderTable ###
  datasetInput <- reactive({
    # Fetch the appropriate data object, depending on the value of input$dataset - the dataset selected by the user
    # switch(expression, list of alternatives .. )  switch evaluates EXPR and accordingly chooses one of the further arguments 
    #     If EXPR evaluates to a character string then that string is matched (exactly)to the names of the elements in the alternatives.... 
    #     If there is a match then that element is evaluated
    switch(input$dataset,
           "iris" = iris,
           "mtcars" = mtcars,
           "trees" = trees)
  })
  
  ##### A reactive function for the file extension ---- > this reactive function will be used by download handler ######
  fileext <- reactive({
    switch(input$type,
           "Excel (CSV)" = "csv", "Text (TSV)" = "txt","Text (Space Separated)" = "txt", "Doc" = "doc")
    
  })
  
  ### Output of renderTable will be used in the mainPanel of ui.R to display the dataset observations in the table
  output$table <- renderTable({
    datasetInput()
    
  })
  
  ############ Download handler for the download button ####################
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste(input$dataset, fileext(), sep = ".") # example : iris.csv, iris.doc, iris.txt 
      
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$type, "Excel (CSV)" = ",", "Text (TSV)" = "\t","Text (Space Separated)" = " ", "Doc" = " ")
      
      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
  output$dataname <- renderText({
    paste("Structure of the dataset", input$dataset)
    
  })
  
  #microbio
  sliderValues <- reactive({
    
    data.frame(
      Name = c("Integer",
               "Decimal",
               "Range",
               "Custom Format",
               "Animation"),
      Value = as.character(c(input$integer,
                             input$decimal,
                             paste(input$range, collapse = " "),
                             input$format,
                             input$animation)),
      stringsAsFactors = FALSE)
    
  })
  
  # Show the values in an HTML table ----
  output$values <- renderTable({
    sliderValues()
  })
  
  
  
  
  
  #AFM
  
  dataset <- reactive({
    diamonds[sample(nrow(diamonds), input$sampleSize),]
  })
  
  output$fplot <- renderPlot({
    p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth()
    
    print(p)
  })
  
})