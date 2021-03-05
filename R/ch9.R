library(shiny)
library(dplyr)
# Ch9

# # 9.1.2 ----
# ui <- fluidPage(
#   fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
#   tableOutput("files")
# )
# server <- function(input, output, session) {
#   output$files <- renderTable(input$upload)
# }
# 
# shinyApp(ui, server)



# # 9.1.3 ----
# ui <- fluidPage(
#   fileInput("file", NULL, accept = c(".csv", ".tsv")),
#   numericInput("n", "Rows", value = 5, min = 1, step = 1),
#   tableOutput("head")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     req(input$file)
# 
#     ext <- tools::file_ext(input$file$name)
#     switch(ext,
#            csv = vroom::vroom(input$file$datapath, delim = ",") %>% janitor::clean_names(),
#            tsv = vroom::vroom(input$file$datapath, delim = "\t"),
#            validate("Invalid file; Please upload a .csv or .tsv file")
#     )
#   })
# 
#   output$head <- renderTable({
#     head(data(), input$n)
#   })
# }
# shinyApp(ui, server)


# # 9.1.4 ----
# ui <- fluidPage(
#   selectInput("dataset", "Pick a dataset", ls("package:datasets")),
#   tableOutput("preview"),
#   downloadButton("download", "Download .tsv")
# )
# 
# server <- function(input, output, session) {
#   data <- reactive({
#     out <- get(input$dataset, "package:datasets")
#     if (!is.data.frame(out)) {
#       validate(paste0("'", input$dataset, "' is not a data frame"))
#     }
#     out
#   })
#   
#   output$preview <- renderTable({
#     head(data())
#   })
#   
#   output$download <- downloadHandler(
#     filename = function() {
#       paste0(input$dataset, ".tsv")
#     },
#     content = function(file) {
#       vroom::vroom_write(data(), file)
#     }
#   )
# }
# 
# shinyApp(ui, server)


# # 9.2.3 ----
# ui <- fluidPage(
#   sliderInput("n", "Number of points", 1, 100, 50),
#   downloadButton("report", "Generate report")
# )
# 
# server <- function(input, output, session) {
#   output$report <- downloadHandler(
#     filename = "report.html",
#     content = function(file) {
#       params <- list(n = input$n)
#       
#       id <- showNotification(
#         "Rendering report...", 
#         duration = NULL, 
#         closeButton = FALSE
#       )
#       on.exit(removeNotification(id), add = TRUE)
#       
#       rmarkdown::render("report.Rmd", 
#                         output_file = file,
#                         params = params,
#                         envir = new.env(parent = globalenv())
#       )
#     }
#   )
# }
# 
# shinyApp(ui, server)


# # 9.3 ----
# ui_upload <- sidebarLayout(
#   sidebarPanel(
#     fileInput("file", "Data", buttonLabel = "Upload..."),
#     textInput("delim", "Delimiter (leave blank to guess)", ""),
#     numericInput("skip", "Rows to skip", 0, min = 0),
#     numericInput("rows", "Rows to preview", 10, min = 1)
#   ),
#   mainPanel(
#     h3("Raw data"),
#     tableOutput("preview1")
#   )
# )
# 
# ui_clean <- sidebarLayout(
#   sidebarPanel(
#     checkboxInput("snake", "Rename columns to snake case?"),
#     checkboxInput("constant", "Remove constant columns?"),
#     checkboxInput("empty", "Remove empty cols?")
#   ),
#   mainPanel(
#     h3("Cleaner data"),
#     tableOutput("preview2")
#   )
# )
# 
# ui_download <- fluidRow(
#   column(width = 12, downloadButton("download", class = "btn-block"))
# )
# 
# ui <- fluidPage(
#   ui_upload,
#   ui_clean,
#   ui_download
# )
# 
# server <- function(input, output, session) {
#   # Upload ---------------------------------------------------------
#   raw <- reactive({
#     req(input$file)
#     delim <- if (input$delim == "") NULL else input$delim
#     vroom::vroom(input$file$datapath, delim = delim, skip = input$skip)
#   })
#   output$preview1 <- renderTable(head(raw(), input$rows))
#   
#   # Clean ----------------------------------------------------------
#   tidied <- reactive({
#     out <- raw()
#     if (input$snake) {
#       names(out) <- janitor::make_clean_names(names(out))
#     }
#     if (input$empty) {
#       out <- janitor::remove_empty(out, "cols")
#     }
#     if (input$constant) {
#       out <- janitor::remove_constant(out)
#     }
#     
#     out
#   })
#   output$preview2 <- renderTable(head(tidied(), input$rows))
#   
#   # Download -------------------------------------------------------
#   output$download <- downloadHandler(
#     filename = function() {
#       paste0(tools::file_path_sans_ext(input$file$name), ".tsv")
#     },
#     content = function(file) {
#       vroom::vroom_write(tidied(), file)
#     }
#   )
# }
# 
# shinyApp(ui, server)


# # 9.4 Exercises ----
# # 1. ----
# # Use the ambient package by Thomas Lin Pedersen to generate worley noise
# # and download a PNG of it.
# library(ambient)
# 
# ui <- fluidPage(
#   sliderInput("dim", "Select dimension for noise generation",
#               min = 250, max = 1000,
#               step = 50, value = 500),
#   selectInput("perturbation", "Select type of perturbation",
#               choices = list("none", "normal", "fractal")),
#   sliderInput("pert_amp", "Select amplitude of perturbation",
#               min = 1, max = 50, step = 5, value = 1),
#   plotOutput("noise"),
#   downloadButton("download", "Download .png")
# )
# 
# server <- function(input, output, session) {
#   
#   simplex <- reactive({
#     noise_simplex(c(input$dim, input$dim),
#                   pertubation = input$perturbation,
#                   pertubation_amplitude = input$pert_amp)
#   })
#   
# 
#   output$noise <- renderPlot({
#     plot(as.raster(normalise(simplex())))
#   })
#   
#   
#   output$download <- downloadHandler(
#     filename = function() {
#       paste0("ambient_noise_", Sys.Date(), ".png")
#     },
#     content = function(file) {
#       png(file)
#       print(plot(as.raster(normalize(simplex()))))
#       dev.off()
#     }
#   )
# }
# 
# shinyApp(ui, server)


# # 2. ----
# # Create an app that lets you upload a csv file, select a variable, and then
# # perform a t.test() on that variable. After the user has uploaded the csv file,
# # you’ll need to use updateSelectInput() to fill in the available variables. See
# # Section 10.1 for details.
# 
# 
# ui_upload <- sidebarLayout(
#   sidebarPanel(
#     fileInput("file", "Upload CSV", accept = ".csv"),
#     numericInput("n", "Rows", value = 5, min = 1, step = 1)
#   ),
#   mainPanel(
#     h3("Data Preview"), 
#     tableOutput("head")
#   )
# )
# 
# ui_ttest <- sidebarLayout(
#   sidebarPanel(
#     selectInput("variable", "Choose a variable for t-test", choices = NULL),
#     actionButton("run_test", "Run T-test")
#   ),
#   mainPanel(verbatimTextOutput("ttest"))
# )
# 
# 
# ui <- fluidPage(
#   ui_upload, 
#   ui_ttest
# )
# 
# 
# server <- function(input, output, session) {
#   
#   # Upload ----  
#   data <- reactive({
#     
#     req(input$file)
#     
#     ext <- tools::file_ext(input$file$name)
#     validate(need(ext == "csv", "Invalid file; Please upload a .csv"))
#     
#     dataset <- vroom::vroom(input$file$datapath, delim = ",") %>% janitor::clean_names()
#     
#     validate(need(ncol(dplyr::select_if(dataset, is.numeric)) != 0, 
#                        "This dataset has no numeric columns."))
#     
#     dataset
#   })
#     
#     
#   # data <- reactive({
#   #   
#   #   req(input$file)
#   #   
#   #   ext <- tools::file_ext(input$file$name)
#   #   switch(ext,
#   #          csv = vroom::vroom(input$file$datapath, delim = ",") %>% janitor::clean_names(),
#   #          validate("Invalid file; Please upload a .csv")
#   #          
#   #   )
#   # })
#   
#   output$head <- renderTable({
#     head(data(), input$n)
#     
#   })
#   
#   observeEvent(input$file, {
#     updateSelectInput(inputId = "variable", choices = names(data()))
#     })
#   
#   
#   # T-test ----
# 
#   output$ttest <- renderPrint({
#     if(!is.null(input$variable))
#       t.test(data() %>% select(input$variable))
#   })
#   
# }
# 
# shinyApp(ui, server)


# 3. ----
# Create an app that lets the user upload a csv file, select one variable, 
# draw a histogram, and then download the histogram. For an additional challenge, 
# allow the user to select from .png, .pdf, and .svg output formats.


ui_upload <- sidebarLayout(
  sidebarPanel(
    fileInput("file", "Upload CSV", accept = ".csv"),
    numericInput("n", "Rows", value = 5, min = 1, step = 1)
  ),
  mainPanel(
    h3("Data Preview"),
    tableOutput("head")
  )
)

ui_ttest <- sidebarLayout(
  sidebarPanel(
    selectInput("variable", "Choose a variable for t-test", choices = NULL),
    actionButton("run_test", "Run T-test")
  ),
  mainPanel(verbatimTextOutput("ttest"))
)


ui <- fluidPage(
  ui_upload,
  ui_ttest
)


server <- function(input, output, session) {

  # Upload ----
  data <- reactive({

    req(input$file)

    ext <- tools::file_ext(input$file$name)
    validate(need(ext == "csv", "Invalid file; Please upload a .csv"))

    dataset <- vroom::vroom(input$file$datapath, delim = ",") %>% janitor::clean_names()

    validate(need(ncol(dplyr::select_if(dataset, is.numeric)) != 0,
                       "This dataset has no numeric columns."))

    dataset
  })


  # data <- reactive({
  #
  #   req(input$file)
  #
  #   ext <- tools::file_ext(input$file$name)
  #   switch(ext,
  #          csv = vroom::vroom(input$file$datapath, delim = ",") %>% janitor::clean_names(),
  #          validate("Invalid file; Please upload a .csv")
  #
  #   )
  # })

  output$head <- renderTable({
    head(data(), input$n)

  })

  observeEvent(input$file, {
    updateSelectInput(inputId = "variable", choices = names(data()))
    })


  # T-test ----

  output$ttest <- renderPrint({
    if(!is.null(input$variable))
      t.test(data() %>% select(input$variable))
  })

}

shinyApp(ui, server)









# 4. ----
# Write an app that allows the user to create a Lego mosaic from any .png 
# file using Ryan Timpe’s brickr package. Once you’ve completed the basics, add 
# controls to allow the user to select the size of the mosaic (in bricks), and 
# choose whether to use “universal” or “generic” colour palettes.

# 5. ----
# The final app in Section 9.3 contains this one large reactive:
# Break it up into multiple pieces so that (e.g.) janitor::make_clean_names() 
# is not re-run when input$empty changes.
# 
# tidied <- reactive({
#   out <- raw()
#   if (input$snake) {
#     names(out) <- janitor::make_clean_names(names(out))
#   }
#   if (input$empty) {
#     out <- janitor::remove_empty(out, "cols")
#   }
#   if (input$constant) {
#     out <- janitor::remove_constant(out)
#   }
#   
#   out
# })




