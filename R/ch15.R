library(shiny)
reactiveConsole(TRUE)

# a1 <- a2 <- 10
# a2 <- 20
# a1 # unchanged

# b1 <- b2 <- reactiveValues(x = 10)
# b1$x <- 20
# b2$x

# # Ex 1 ----
# l1 <- reactiveValues(a = 1, b = 2)
# l1$a
# 
# 
# l2 <- list(a = reactiveVal(1), b = reactiveVal(2))
# l2$a
# l2$a()


# # EX 2 ----
# a1 <- b1 <- reactiveVal(10)
# a1()
# b1()
# a1(15)
# b1()


# 15.2.3.1 ----
# reactlog::reactlog_enable()
# shiny::reactlogShow()

# ui <- fluidPage(
#   checkboxInput("error", "error?"),
#   textOutput("result")
# )
# server <- function(input, output, session) {
#   a <- reactive({
#     if (input$error) {
#       stop("Error!")
#     } else {
#       1
#     }
#   })
#   b <- reactive(a() + 1)
#   c <- reactive(b() + 1)
#   output$result <- renderText(c())
# }


# ui <- fluidPage(
#   checkboxInput("error", "error?"),
#   textOutput("result")
# )
# server <- function(input, output, session) {
#   a <- reactive({
#     req(input$error, cancelOutput = TRUE)
#     if (input$error) {
#       stop("Error!")
#     } else {
#       1
#     }
#   })
#   b <- reactive(a() + 1)
#   c <- reactive(b() + 1)
#   output$result <- renderText(c())
# }


# 15.3 ----
# y <- reactiveVal(10)
# observe({
#   message("`y` is ", y())
# })
# #> `y` is 10
# 
# y(5)
# #> `y` is 5
# y(4)
# #> `y` is 4

# x <- reactiveVal(1)
# y <- observe({
#   x()
#   observe(print(x()))
# })
# #> [1] 1
# x(2)
# #> [1] 2
# #> [1] 2
# x(3)
# #> [1] 3
# #> [1] 3
# #> [1] 3
# x(4)


# 15.4.3.1 ----
ui <- fluidPage(
  numericInput("x", "x", value = 50, min = 0, max = 100),
  actionButton("capture", "capture"),
  textOutput("out")
)

server <- function(input, output, session) {

  out <- eventReactive(input$capture, {input$x})

  output$out <- renderText(out())

}


















































shinyApp(ui, server)
