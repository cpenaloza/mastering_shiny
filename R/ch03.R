# library(shiny)


# # ex1 
# textInput("name", label = "Your name")


# # ex2
# library(shiny)
# 
# 
# ui <- fluidPage(
# 
# sliderInput("deadline", "When should we deliver?", value = lubridate::ymd("2020-09-17"),
#             timeFormat = "%F", min = lubridate::ymd("2020-09-16"), max = lubridate::ymd("2020-09-23"))
# 
# )
# 
# 
# server <- function(input, output, session) {
# 
# }
# 
# shinyApp(ui, server)


# # ex3
# library(shiny)
# 
# # demoing group support in the `choices` arg
# shinyApp(
#   ui = fluidPage(
#     selectInput("state", "Choose a state:",
#                 list(`East Coast` = list("NY", "NJ", "CT"),
#                      `West Coast` = list("WA", "OR", "CA"),
#                      `Midwest` = list("MN", "WI", "IA"))
#     ),
#     textOutput("state")
#   ),
#   server = function(input, output) {
#     output$state <- renderText({
#       paste("You chose", input$state)
#     })
#   }
# )



# # ex4
# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", "Select Value", value = 5, min = 0, max = 100, step = 5, animate = TRUE),
#   )
# 
# server <- function(input, output, session) {
# }
# 
# shinyApp(ui, server)


# # ex5
# numericInput("number", "Select a value", value = 150, min = 0, max = 1000, step = 50)
# # step provides the intervals allowed for selection. 


# Section 3.3.5
# # ex1
# library(shiny)
# 
# ui <- fluidPage(
#   plotOutput("plot", width = "700px", height = "300px")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
# }
# 
# shinyApp(ui, server)


# # ex2
# ui <- fluidPage(
#   dataTableOutput("table")
# )
# server <- function(input, output, session) {
#   output$table <- renderDataTable(mtcars, options = list(ordering = FALSE, searching = FALSE, filtering = FALSE))
# }
# 
# shinyApp(ui, server)


# # ex3
# library(reactable)
# 
# ui <- fluidPage(
#   reactableOutput("table")
# )
# server <- function(input, output, session) {
#   output$table <- renderReactable({
#     reactable(mtcars)
#   })
# }
# 
# shinyApp(ui, server)


# # 3.4 Layouts
# # 3.4.1
# ui <-  fluidPage(
#   titlePanel("Hello Shiny!"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("obs", "Observations:", min = 0, max = 1000, value = 500)
#     ),
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   output$distPlot <- renderPlot(plot(1:5), res = 96)
# }
# 
# shinyApp(ui, server)


# # 3.4.2 Layouts
# ui <-  fluidPage()
# 
# server <- function(input, output, session) {}
# 
# shinyApp(ui, server)


# theme_demo <- function(theme) {
#   fluidPage(
#     theme = shinythemes::shinytheme(theme),
#     sidebarLayout(
#       sidebarPanel(
#         textInput("txt", "Text input:", "text here"),
#         sliderInput("slider", "Slider input:", 1, 100, 30)
#       ),
#       mainPanel(
#         h1("Header 1"),
#         h2("Header 2"),
#         p("Some text")
#       )
#     )
#   )
# }
# 
# theme_demo("darkly")
# theme_demo("flatly")
# theme_demo("sandstone")
# theme_demo("united")


# # 3.4.2 Layouts
# ui <-  theme_demo("darkly")
# 
# server <- function(input, output, session) {}
# 
# shinyApp(ui, server)



# ui <-  fluidPage(
#   fluidRow(theme_demo("darkly")
#   ),
#   fluidRow(theme_demo("flatly")
# )
# )
# server <- function(input, output, session) {}
# 
# shinyApp(ui, server)


# # 3.4.6
# # ex1
# 
# ui <- fluidPage(
#   fluidRow(
#     column(6,
#            plotOutput("plot")
#     ),
#     column(6, 
#            plotOutput("plot1")
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
#   output$plot1 <- renderPlot(plot(1:5), res = 96)
# }
# 
# shinyApp(ui, server)


# # ex2
# ui <- fluidPage(
#   theme = shinythemes::shinytheme("darkly"),
#   titlePanel("Central limit theorem"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("m", "Number of samples:", 2, min = 1, max = 100)
#     ),
#     mainPanel(
#       plotOutput("hist")
#     ), position = "right",
#   )
# )
# 
# server <- function(input, output, session) {
#   output$hist <- renderPlot({
#     means <- replicate(1e4, mean(runif(input$m)))
#     hist(means, breaks = 20)
#   }, res = 96)
# }
# shinyApp(ui, server)
# 

# https://shiny.rstudio.com/articles/debugging.html
# shinyapps.io free account
