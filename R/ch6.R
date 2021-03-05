library(shiny)


# # 6.2.5 ----
# ui <- fluidPage(
#   sliderInput("x", "x", value = 1, min = 0, max = 10),
#   sliderInput("y", "y", value = 2, min = 0, max = 10),
#   sliderInput("z", "z", value = 3, min = 0, max = 10),
#   textOutput("total")
# )
# server <- function(input, output, session) {
#   observeEvent(input$x, {
#     message(glue::glue("Updating y from {input$y} to {input$x * 2}"))
#     updateSliderInput(session, "y", value = input$x * 2)
#   })
#   
#   total <- reactive({
#     total <- input$x + input$y + input$z
#     message(glue::glue("New total is {total}"))
#     total
#   })
#   
#   output$total <- renderText({
#     total()
#   })
# }
# 
# shinyApp(ui, server)


# 6.3.4 ----
# library(xts)
# library(lubridate)
library(shiny)

# # a
# ui <- fluidPage(
#   uiOutput("interaction_slider"),
#   verbatimTextOutput("breaks")
# )
# server <- function(input, output, session) {
#   df <- data.frame(
#     dateTime = c(
#       "2019-08-20 16:00:00",
#       "2019-08-20 16:00:01",
#       "2019-08-20 16:00:02",
#       "2019-08-20 16:00:03",
#       "2019-08-20 16:00:04",
#       "2019-08-20 16:00:05"
#     ),
#     var1 = c(9, 8, 11, 14, 16, 1),
#     var2 = c(3, 4, 15, 12, 11, 19),
#     var3 = c(2, 11, 9, 7, 14, 1)
#   )
# 
#   timeSeries <- as.xts(df[, 2:4],
#                        order.by = strptime(df[, 1], format = "%Y-%m-%d %H:%M:%S")
#   )
#   print(paste(min(time(timeSeries)), is.POSIXt(min(time(timeSeries))), sep = " "))
#   print(paste(max(time(timeSeries)), is.POSIXt(max(time(timeSeries))), sep = " "))
# 
#   output$interaction_slider <- renderUI({
#     sliderInput(
#       "slider",
#       "Select Range:",
#       min = min(time(timeSeries)),
#       max = max(time(timeSeries)),
#       value = c(min, max)
#     )
#   })
# 
#   brks <- reactive({
#     req(input$slider)
#     seq(input$slider[1], input$slider[2], length.out = 10)
#   })
# 
#   output$breaks <- brks
# }

# # b
# datetime <- Sys.time() + (86400 * 0:10)
# 
# server <- function(input, output, session) {
#   output$interaction_slider <- renderUI({
#     sliderInput(
#       "slider",
#       "Select Range:",
#       min   = min(datetime),
#       max   = max(datetime),
#       value = c(min, max)
#     )
#   })
#   
#   brks <- reactive({
#     req(input$slider)
#     seq(input$slider[1], input$slider[2], length.out = 10)
#   })
#   
#   output$breaks <- brks
# }

# c
datetime <- Sys.time() + (86400 * 0:10)

ui <- fluidPage(
  sliderInput("slider",
              "Select Range:",
              min   = min(datetime),
              max   = max(datetime),
              value = range(datetime)
              # value = c(min, max)
  ),
  verbatimTextOutput("breaks")
)

server <- function(input, output, session) {

  brks <- reactive({
    req(input$slider)
    seq(input$slider[1], input$slider[2], length.out = 10)
  })
  
  output$breaks <- brks
}

shinyApp(ui, server)