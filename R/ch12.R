library(shiny)
library(dplyr)
library(ggplot2)

# # 12.2.2 ----
# ui <- fluidPage(
#   selectInput("x", "X variable", choices = names(iris)),
#   selectInput("y", "Y variable", choices = names(iris)),
#   plotOutput("plot")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) +
#       geom_point(position = ggforce::position_auto())
#   }, res = 96)
# }
# 
# shinyApp(ui, server)


# # 12.2.2.b ----
# 
# ui <- fluidPage(
#   selectInput("x", "X variable", choices = names(iris)),
#   selectInput("y", "Y variable", choices = names(iris)),
#   selectInput("geom", "geom", c("point", "smooth", "jitter")),
#   plotOutput("plot")
# )
# server <- function(input, output, session) {
#   plot_geom <- reactive({
#     switch(input$geom,
#            point = geom_point(),
#            smooth = geom_smooth(se = FALSE),
#            jitter = geom_jitter()
#     )
#   })
#   
#   output$plot <- renderPlot({
#     ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) +
#       plot_geom()
#   }, res = 96)
# }
# 
# shinyApp(ui, server)


# # 12.2.2c ----
# ui <- fluidPage(
#   selectInput("var", "Select variable", choices = names(mtcars)),
#   sliderInput("min", "Minimum value", 0, min = 0, max = 100),
#   selectInput("sort", "Sort by", choices = names(mtcars)),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   observeEvent(input$var, {
#     rng <- range(mtcars[[input$var]])
#     updateSliderInput(
#       session, "min", 
#       value = rng[[1]], 
#       min = rng[[1]], 
#       max = rng[[2]]
#     )
#   })
#   
#   output$data <- renderTable({
#     mtcars %>% 
#       filter(.data[[input$var]] > input$min) %>% 
#       arrange(.data[[input$sort]])
#   })
# }
# shinyApp(ui, server)


# 12.3 ----
ui <- fluidPage(
  selectInput("vars_g", "Group by", names(mtcars), multiple = TRUE),
  selectInput("vars_s", "Summarise", names(mtcars), multiple = TRUE),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$data <- renderTable({
    mtcars %>% 
      group_by(across(all_of(input$vars_g))) %>% 
      summarise(across(all_of(input$vars_s), mean), n = n())
  })
}

shinyApp(ui, server)


# https://www.youtube.com/channel/UC-2kN-PC3dN7egPQkhyQ-wA

# https://github.com/daattali/shinycssloaders

