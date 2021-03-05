library(shiny)
library(ggplot2)

# # 7.1.1 ----
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   verbatimTextOutput("info")
# )
# 
# server <- function(input, output) {
#   output$plot <- renderPlot({
#     plot(mtcars$wt, mtcars$mpg)
#   }, res = 96)
#   
#   output$info <- renderPrint({
#     req(input$plot_click)
#     x <- round(input$plot_click$x, 2)
#     y <- round(input$plot_click$y, 2)
#     cat("[", x, ", ", y, "]", sep = "")
#   })
# }
# 
# shinyApp(ui, server)


# 7.1.2 ----

# # BaseR
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     plot(mtcars$wt, mtcars$mpg)
#   }, res = 96)
#   
#   output$data <- renderTable({
#     nearPoints(mtcars, input$plot_click, xvar = "wt", yvar = "mpg")
#   })
# }
# 
# shinyApp(ui, server)


# # ggplot2
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + 
#       geom_point() + 
#       theme(panel.grid = element_blank())
#   }, res = 96)
#   
#   output$data <- renderTable({
#     req(input$plot_click)
#     nearPoints(mtcars, input$plot_click)
#   })
# }
# 
# shinyApp(ui, server)


# # 7.1.4 ----
# 
# ui <- fluidPage(
#   plotOutput("plot", brush = "plot_brush"),
#   tableOutput("data")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + geom_point()
#   }, res = 96)
#   
#   output$data <- renderTable({
#     brushedPoints(mtcars, input$plot_brush)
#   })
# }
# 
# shinyApp(ui, server)


# 7.1.5 ----
# # 1
# set.seed(1014)
# df <- data.frame(x = rnorm(100), y = rnorm(100))
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click", )
# )
# 
# server <- function(input, output, session) {
#   dist <- reactiveVal(rep(1, nrow(df)))
#   observeEvent(input$plot_click,
#                dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)  
#   )
#   
#   output$plot <- renderPlot({
#     df$dist <- dist()
#     ggplot(df, aes(x, y, size = dist)) + 
#       geom_point() + 
#       scale_size_area(limits = c(0, 1000), max_size = 10, guide = NULL)
#   }, res = 96)
# }
# 
# shinyApp(ui, server)


# # 2
# ui <- fluidPage(
#   plotOutput("plot", brush = "plot_brush", dblclick = "plot_reset"), 
#   tableOutput("table")
#   )
# 
# 
# server <- function(input, output, session) {
#   selected <- reactiveVal(rep(FALSE, nrow(mtcars)))
#   
#   observeEvent(input$plot_brush, {
#     # brushed <- brushedPoints(mtcars, input$plot_brush)$selected_
#     brushed <- brushedPoints(mtcars, input$plot_brush, allRows = TRUE)$selected_
#     selected(brushed | selected())
#   })
#   observeEvent(input$plot_reset, {
#     selected(rep(FALSE, nrow(mtcars)))
#   })
#   
#   output$plot <- renderPlot({
#     mtcars$sel <- selected()
#     ggplot(mtcars, aes(wt, mpg)) + 
#       geom_point(aes(colour = sel)) +
#       scale_colour_discrete(limits = c("TRUE", "FALSE"))
#   }, res = 96)
#   
#   output$table <- renderTable({
#     mtcars[selected(), ]
#   })
# }
# 
# shinyApp(ui, server)


# 7.1.7 ----
# 1
# # Ex 2 ----
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   tableOutput("data")
# )
# 
# server <- function(input, output, session) {
# 
#     output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) +
#       geom_point() +
#       theme(panel.grid = element_blank())
#   }, res = 96)
# 
#   output$data <- renderTable({
#     nearPoints(mtcars, input$plot_click, allRows = TRUE)
#   })
# }
# 
# shinyApp(ui, server)


# # Ex3 ----
# 
# options <- list(
#   autoWidth = FALSE,
#   searching = FALSE,
#   ordering = FALSE,
#   lengthChange = FALSE,
#   lengthMenu = FALSE,
#   pageLength = 5, # Only show 5 rows per page.
#   paging = TRUE, # Enable pagination. Must be set for pageLength to work.
#   info = FALSE
# )
# 
# ui <- fluidPage(
#     sidebarLayout(
#       sidebarPanel(width = 6,
#         
#         h4("Selected Points"),
#         dataTableOutput("click"), br(),
#         
#         h4("Double Clicked Points"), 
#         dataTableOutput("dbl"), br(), 
#         
#         h4("Hovered Points"),
#         dataTableOutput("hover"), br(),
#         
#         h4("Brushed Points"), 
#         dataTableOutput("brush")
#         
#     ),
#     mainPanel(width = 6, 
#               
#         plotOutput("plot", 
#                    click = "click", 
#                    dblclick = "dbl",
#                    hover = "hover", 
#                    brush = "brush")
#     )
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   
#   output$plot <- renderPlot({
#     ggplot(mtcars, aes(wt, mpg)) + geom_point()
#   }, res = 96)
# 
#   output$click <- renderDataTable(
#     # req(input$plot_click)
#     nearPoints(mtcars, input$click), options = options
#   )
#   
#   output$dbl <- renderDataTable(
#     # req(input$dbl)
#     nearPoints(mtcars, input$dbl), options = options
#   )
#   output$hover <- renderDataTable(
#     # req(input$hover)
#     nearPoints(mtcars, input$hover), options = options
#   )
#   
#   output$brush <- renderDataTable(
#     brushedPoints(mtcars, input$brush), options = options
#   )
# }
# 
# shinyApp(ui, server)


# Ex 4 ----
#  Compute the limits of the distance scale using the size of the plot.

set.seed(1014)
df <- data.frame(x = rnorm(100), y = rnorm(100))

ui <- fluidPage(
  plotOutput("plot", click = "plot_click", ),
  verbatimTextOutput("size")
)

server <- function(input, output, session) {

  output_size <- function(id) {
  reactive(c(
    session$clientData[[paste0("output_", id, "_width")]],
    session$clientData[[paste0("output_", id, "_height")]]
  ))
}

  dist <- reactiveVal(rep(1, nrow(df)))
  observeEvent(input$plot_click,
               dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
  )

  output$plot <- renderPlot({
    df$dist <- dist()
    ggplot(df, aes(x, y, size = dist)) +
      geom_point() +
      scale_size_area(limits = c(0, 1000), max_size = 10, guide = NULL)
  }, res = 96)

  output$size <- renderText(
    output_size(plot)
  )
}

shinyApp(ui, server)


# library(shiny)
# library(ggplot2)
# 
# df <- data.frame(x = rnorm(100), y = rnorm(100))
# 
# ui <- fluidPage(
#   plotOutput("plot", click = "plot_click"),
#   textOutput("width"),
#   textOutput("height"),
#   textOutput("scale")
# )
# 
# server <- function(input, output, session) {
#   
#   # Save the plot's widht and height.
#   width <- reactive(session$clientData[["output_plot_width"]])
#   height <- reactive(session$clientData[["output_plot_height"]])
#   
#   # Print the plot's width, the plot's height, and the suggested scale limits.
#   output$width <- renderText(paste0("Plot's width: ", width()))
#   output$height <- renderText(paste0("Plot's height: ", height()))
#   output$scale <- renderText({
#     paste0("Recommended limits: (0, ", max(height(), width()), ")")
#   })
#   
#   # Store the distance computed by the click event.
#   dist <- reactiveVal(rep(1, nrow(df)))
#   
#   # Update the dist reactive as needed.
#   observeEvent(input$plot_click, {
#     req(input$plot_click)
#     dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
#   })
#   
#   output$plot <- renderPlot({
#     df$dist <- dist()
#     ggplot(df, aes(x, y, size = dist)) +
#       geom_point()
#   })
# }
# 
# shinyApp(ui, server)

# # 7.2 ----
# library(thematic)
# thematic_on(bg = "#222222", fg = "#FFFFD4", accent = "orange")
# # thematic_on(bg = "#222222", fg = "white", accent = "#0CE3AC")
# 
# library(ggplot2)
# ggplot(mtcars, aes(wt, mpg)) +
#   geom_point() +
#   geom_smooth()
# 
# thematic::thematic_off()


# # 7.3 ----
# 
# ui <- fluidPage(
#   sliderInput("height", "height", min = 100, max = 500, value = 250),
#   sliderInput("width", "width", min = 100, max = 500, value = 250),
#   plotOutput("plot", width = 250, height = 250)
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot(
#     width = function() input$width,
#     height = function() input$height,
#     res = 96,
#     {
#       plot(rnorm(20), rnorm(20))
#     }
#   )
# }
# shinyApp(ui, server)

# 7.4 ----
puppies <- tibble::tribble(
  ~breed, ~ id, ~author, 
  "corgi", "eoqnr8ikwFE","alvannee",
  "labrador", "KCdYn0xu2fU", "shaneguymon",
  "spaniel", "TzjMd7i5WQI", "_redo_"
)

ui <- fluidPage(
  selectInput("id", "Pick a breed", choices = setNames(puppies$id, puppies$breed)),
  htmlOutput("source"),
  imageOutput("photo")
)
server <- function(input, output, session) {
  output$photo <- renderImage({
    list(
      src = file.path("puppy-photos", paste0(input$id, ".jpg")),
      contentType = "image/jpeg",
      width = 500,
      height = 650
    )
  }, deleteFile = FALSE)
  
  output$source <- renderUI({
    info <- puppies[puppies$id == input$id, , drop = FALSE]
    HTML(glue::glue("<p>
      <a href='https://unsplash.com/photos/{info$id}'>original</a> by
      <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
    </p>"))
  })
}
shinyApp(ui, server)