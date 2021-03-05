library(shiny)
library(dplyr)


# # 10.1.6.1 ----
# ui <- fluidPage(
#   numericInput("year", "year", value = 2020),
#   dateInput("date", "date", value = NULL)
#   
# )
# 
# server <- function(input, output, session) {
#   
#   observeEvent(input$year, {
#     start <- paste0(input$year, "-", format(Sys.Date(), "%m-%d"))
#     updateDateInput(inputId = "date", value = start)
#     })
# }
# 
# shinyApp(ui, server)


# # 10.1.6.1b ----
# ui <- fluidPage(
#   numericInput("year", "year", value = 2020),
#   dateInput("date", "date", value = NULL)
#   
# )
# 
# server <- function(input, output, session) {
#   
#   start <- eventReactive(paste0(input$year, "-", format(Sys.Date(), "%m-%d")))
#   
#   observeEvent(start(), {
#     updateDateInput(inputId = "date", value = start())
#   })
# }
# 
# shinyApp(ui, server)


# # 10.1.6.2 ----
# library(openintro, warn.conflicts = FALSE)
# library(dplyr)
# 
# states <- unique(county$state)
# 
# ui <- fluidPage(
#   selectInput("state", "State", choices = states),
#   selectInput("county", "County", choices = NULL)
# )
# 
# 
# server <- function(input, output, session) {
# 
#   state <- reactive({
#     filter(county, state == input$state)
#   })
# 
#   observeEvent(state(), {
#     choices <- unique(state()$name)
#     label <- if(input$state == "Louisiana") {
#       "Parish"
#     } else if(input$state == "Alaska") {
#       "Borough"
#     } else {
#       "County"
#     }
#     updateSelectInput(inputId = "county", label = label, choices = choices)
#   })
# }
# 
# shinyApp(ui, server)
# #
# # library(dplyr)
# # 
# # state <- filter(county, state == "Alabama")
# # # state <- 
# #   county %>% 
# #   filter(state == "Alabama")

# # 10.1.6.3 ----
# library(gapminder)
# 
# continents <- unique(gapminder$continent)
# 
# ui <- fluidPage(
#   selectInput("continent", "Continent", choices = continents), 
#   selectInput("country", "Country", choices = NULL),
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
# 
#   country <- reactive({
#     filter(gapminder, continent == input$continent)
#   })
# 
#   observeEvent(country(), {
#     choices <- unique(country()$country)
#     updateSelectInput(inputId = "country", choices = choices)
#   })
#   
#   data <- eventReactive(input$country, {
#     filter(country(), country == input$country)
#   })
#   output$data <- renderTable(data())
# }
# 
# shinyApp(ui, server)


# # 10.1.6.4 ----
# library(gapminder)
# 
# continents <- unique(gapminder$continent)
# 
# 
# ui <- fluidPage(
#   selectInput("continent", "Continent", choices = c("All", as.character(continents))), 
#   selectInput("country", "Country", choices = NULL),
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
#   
#   country <- reactive({
#     if(input$continent == "All") {
#       gapminder
#     } else {
#       filter(gapminder, continent == input$continent)
#     }
#   })
#   
#   observeEvent(country(), {
#     choices <- unique(country()$country)
#     updateSelectInput(inputId = "country", choices = choices)
#   })
#   
#   data <- eventReactive(input$country, {
#     filter(country(), country == input$country)
#   })
#   output$data <- renderTable(data())
# }
# 
# shinyApp(ui, server)


# # 10.2.1 ----
# parameter_tabs <- tabsetPanel(
#   id = "params",
#   type = "hidden",
#   tabPanel("normal",
#            numericInput("mean", "mean", value = 1),
#            numericInput("sd", "standard deviation", min = 0, value = 1)
#   ),
#   tabPanel("uniform", 
#            numericInput("min", "min", value = 0),
#            numericInput("max", "max", value = 1)
#   ),
#   tabPanel("exponential",
#            numericInput("rate", "rate", value = 1, min = 0),
#   )
# )
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("dist", "Distribution", 
#                   choices = c("normal", "uniform", "exponential")
#       ),
#       numericInput("n", "Number of samples", value = 100),
#       parameter_tabs,
#     ),
#     mainPanel(
#       plotOutput("hist")
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   observeEvent(input$dist, {
#     updateTabsetPanel(inputId = "params", selected = input$dist)
#   }) 
#   
#   sample <- reactive({
#     switch(input$dist,
#            normal = rnorm(input$n, input$mean, input$sd),
#            uniform = runif(input$n, input$min, input$max),
#            exponential = rexp(input$n, input$rate)
#     )
#   })
#   output$hist <- renderPlot(hist(sample()), res = 96)
# }
# 
# shinyApp(ui, server)


# # 10.3.1 ----
# ui <- fluidPage(
#   textInput("label", "label"),
#   selectInput("type", "type", c("slider", "numeric")),
#   uiOutput("numeric")
# )
# server <- function(input, output, session) {
#   output$numeric <- renderUI({
#     value <- isolate(input$dynamic)
#     if (input$type == "slider") {
#       sliderInput("dynamic", input$label, value = value, min = 0, max = 10)
#     } else {
#       numericInput("dynamic", input$label, value = value, min = 0, max = 10) 
#     }
#   })
# }
# shinyApp(ui, server)


# # 10.3.2 ----
# library(purrr)
# 
# ui <- fluidPage(
#   numericInput("n", "Number of colours", value = 5, min = 1),
#   uiOutput("col"),
#   textOutput("palette")
# )
# 
# server <- function(input, output, session) {
#   col_names <- reactive(paste0("col", seq_len(input$n)))
#   
#   output$col <- renderUI({
#     map(col_names(), ~ textInput(.x, NULL))
#   })
#   
#   output$palette <- renderText({
#     map_chr(col_names(), ~ input[[.x]] %||% "")
#   })
# }
# 
# shinyApp(ui, server)

# # 10.3.2b ----
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("n", "Number of colours", value = 5, min = 1),
#       uiOutput("col"),
#     ),
#     mainPanel(
#       plotOutput("plot")  
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   col_names <- reactive(paste0("col", seq_len(input$n)))
#   
#   output$col <- renderUI({
#     map(col_names(), ~ textInput(.x, NULL, value = isolate(input[[.x]])))
#   })
#   
#   output$plot <- renderPlot({
#     cols <- map_chr(col_names(), ~ input[[.x]] %||% "")
#     # convert empty inputs to transparent
#     cols[cols == ""] <- NA
#     
#     barplot(
#       rep(1, length(cols)), 
#       col = cols,
#       space = 0, 
#       axes = FALSE
#     )
#   }, res = 96)
# }
# 
# shinyApp(ui, server)



# # 10.3. ----
# 
# make_ui <- function(x, var) {
#   if (is.numeric(x)) {
#     rng <- range(x, na.rm = TRUE)
#     sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
#   } else if (is.factor(x)) {
#     levs <- levels(x)
#     selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
#   } else {
#     # Not supported
#     NULL
#   }
# }
# 
# filter_var <- function(x, val) {
#   if (is.numeric(x)) {
#     !is.na(x) & x >= val[1] & x <= val[2]
#   } else if (is.factor(x)) {
#     x %in% val
#   } else {
#     # No control, so don't filter
#     TRUE
#   }
# }
# 
# # # a
# # ui <- fluidPage(
# #   sidebarLayout(
# #     sidebarPanel(
# #       make_ui(iris$Sepal.Length, "Sepal.Length"),
# #       make_ui(iris$Sepal.Width, "Sepal.Width"),
# #       make_ui(iris$Species, "Species")
# #     ),
# #     mainPanel(
# #       tableOutput("data")
# #     )
# #   )
# # )
# # server <- function(input, output, session) {
# #   selected <- reactive({
# #     filter_var(iris$Sepal.Length, input$Sepal.Length) &
# #       filter_var(iris$Sepal.Width, input$Sepal.Width) &
# #       filter_var(iris$Species, input$Species)
# #   })
# #   
# #   output$data <- renderTable(head(iris[selected(), ], 12))
# # }
# 
# 
# # b
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       map(names(iris), ~ make_ui(iris[[.x]], .x))
#     ),
#     mainPanel(
#       tableOutput("data")
#     )
#   )
# )
# server <- function(input, output, session) {
#   selected <- reactive({
#     each_var <- map(names(iris), ~ filter_var(iris[[.x]], input[[.x]]))
#     reduce(each_var, ~ .x & .y)
#   })
#   
#   output$data <- renderTable(head(iris[selected(), ], 12))
# }
# shinyApp(ui, server)


# # 10.3.3.3 ----
# 
# make_ui <- function(x, var) {
#   if (is.numeric(x)) {
#     rng <- range(x, na.rm = TRUE)
#     sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
#   } else if (is.factor(x)) {
#     levs <- levels(x)
#     selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
#   } else {
#     # Not supported
#     NULL
#   }
# }
# 
# filter_var <- function(x, val) {
#   if (is.numeric(x)) {
#     !is.na(x) & x >= val[1] & x <= val[2]
#   } else if (is.factor(x)) {
#     x %in% val
#   } else {
#     # No control, so don't filter
#     TRUE
#   }
# }
# dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets")))
# 
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("dataset", label = "Dataset", choices = dfs),
#       uiOutput("filter")
#     ),
#     mainPanel(
#       tableOutput("data")
#     )
#   )
# )
# server <- function(input, output, session) {
#   data <- reactive({
#     get(input$dataset, "package:datasets")
#   })
#   vars <- reactive(names(data()))
#   
#   output$filter <- renderUI(
#     map(vars(), ~ make_ui(data()[[.x]], .x))
#   )
#   
#   selected <- reactive({
#     each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
#     reduce(each_var, `&`)
#   })
#   
#   output$data <- renderTable(head(data()[selected(), ], 12))
# }
# shinyApp(ui, server)


# # 10.3.5.2 ----
# ui <- fluidPage(
#   actionButton("go", "Enter password"),
#   textOutput("text")
# )
# server <- function(input, output, session) {
#   observeEvent(input$go, {
#     showModal(modalDialog(
#       passwordInput("password", NULL),
#       title = "Please enter your password"
#     ))
#   })
#   
#   output$text <- renderText({
#     if (!isTruthy(input$password)) {
#       "No password"
#     } else {
#       "Password entered"
#     }
#   })
# }
# 
# shinyApp(ui, server)


# 10.3.5.4 ----
# Add support for date and date-time columns make_ui() and filter_var().
shinyApp(ui, server)

