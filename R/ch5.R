library(shiny)
library(tidyverse)
library(vroom)

injuries <- vroom::vroom("../neiss/injuries.tsv.gz")
# injuries
# 
products <- vroom::vroom("../neiss/products.tsv")
# products
# 
population <- vroom::vroom("../neiss/population.tsv")
# population
# 
# selected <- injuries %>% filter(prod_code == 649)
# 
# selected %>% count(location, wt = weight, sort = TRUE)
# selected %>% count(location, sort = TRUE)
# 
# selected %>% count(body_part, wt = weight, sort = TRUE)
# 
# selected %>% count(diag, wt = weight, sort = TRUE)
# 
# summary <- selected %>%
#   count(age, sex, wt = weight)
# summary
# 
# summary %>%
#   ggplot(aes(age, n, colour = sex)) +
#   geom_line() +
#   labs(y = "Estimated number of injuries")
# 
# summary <- selected %>%
#   count(age, sex, wt = weight) %>%
#   left_join(population, by = c("age", "sex")) %>%
#   mutate(rate = n / population * 1e4)
# 
# summary
# 
# summary %>%
#   ggplot(aes(age, rate, colour = sex)) +
#   geom_line(na.rm = TRUE) +
#   labs(y = "Injuries per 10,000 people")
# 
# selected %>%
#   sample_n(10) %>%
#   pull(narrative)
# 
# # Orders categories first, then lumps infrequent categories together
# injuries %>%
#   mutate(diag = fct_lump(fct_infreq(diag), n = 5)) %>%
#   group_by(diag) %>%
#   summarise(n = as.integer(sum(weight)))
#   # summarise(n = n())
# 
# # Ex 2 ----
# # Lumps infrequent categories together first, making this the most common category
# injuries %>%
#   mutate(diag = fct_infreq(fct_lump(diag, n = 5))) %>%
#   group_by(diag) %>%
#   summarise(n = as.integer(sum(weight)))
#   # summarise(n = n())
# 
# injuries %>%
#   mutate(diag = fct_lump(diag, n = 5)) %>%
#   group_by(diag) %>%
#   summarise(n = as.integer(sum(weight))) %>% 
#   arrange(desc(n))
# 
# fct_lump()  
# fct_infreq()
#


# # V1 ----
# prod_codes <- setNames(products$prod_code, products$title)
# 
# 
# ui <- fluidPage(
#   fluidRow(
#     column(6,
#            selectInput("code", "Product", choices = prod_codes)
#     )
#   ),
#   fluidRow(
#     column(4, tableOutput("diag")),
#     column(4, tableOutput("body_part")),
#     column(4, tableOutput("location"))
#   ),
#   fluidRow(
#     column(12, plotOutput("age_sex"))
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   selected <- reactive(injuries %>% filter(prod_code == input$code))
#   
#   output$diag <- renderTable(
#     selected() %>% count(diag, wt = weight, sort = TRUE)
#   )
#   output$body_part <- renderTable(
#     selected() %>% count(body_part, wt = weight, sort = TRUE)
#   )
#   output$location <- renderTable(
#     selected() %>% count(location, wt = weight, sort = TRUE)
#   )
#   
#   summary <- reactive({
#     selected() %>%
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4)
#   })
#   
#   output$age_sex <- renderPlot({
#     summary() %>%
#       ggplot(aes(age, n, colour = sex)) +
#       geom_line() +
#       labs(y = "Estimated number of injuries")
#   }, res = 96)
#   
# }
# 
# shinyApp(ui, server)


# # V2 ----
# prod_codes <- setNames(products$prod_code, products$title)
# 
# count_top <- function(df, var, n = 5) {
#   df %>%
#     mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
#     group_by({{ var }}) %>%
#     summarise(n = as.integer(sum(weight)))
# }
# 
# 
# ui <- fluidPage(
#   fluidRow(
#     column(6,
#            selectInput("code", "Product", choices = prod_codes)
#     )
#   ),
#   fluidRow(
#     column(4, tableOutput("diag")),
#     column(4, tableOutput("body_part")),
#     column(4, tableOutput("location"))
#   ),
#   fluidRow(
#     column(12, plotOutput("age_sex"))
#   ),
#   fluidRow(
#     column(2, actionButton("story", "Tell me a story")),
#     column(10, textOutput("narrative"))
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   selected <- reactive(injuries %>% filter(prod_code == input$code))
#   
#   output$diag <- renderTable(count_top(selected(), diag), width = "100%")
#   output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
#   output$location <- renderTable(count_top(selected(), location), width = "100%")
#   
#   
#   summary <- reactive({
#     selected() %>%
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4)
#   })
#   
#   output$age_sex <- renderPlot({
#     summary() %>%
#       ggplot(aes(age, n, colour = sex)) +
#       geom_line() +
#       labs(y = "Estimated number of injuries")
#   }, res = 96)
# }
# 
# shinyApp(ui, server)


# # V3 ----
# 
# count_top <- function(df, var, n = 5) {
#   df %>%
#     mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
#     group_by({{ var }}) %>%
#     summarise(n = as.integer(sum(weight)))
# }
# 
# 
# ui <- fluidPage(
#   fluidRow(
#     column(8,
#            selectInput("code", "Product",
#                        choices = setNames(products$prod_code, products$title),
#                        width = "100%"
#            )
#     ),
#     column(2, selectInput("y", "Y axis", c("rate", "count")))
#   ),
#   fluidRow(
#     column(4, tableOutput("diag")),
#     column(4, tableOutput("body_part")),
#     column(4, tableOutput("location"))
#   ),
#   fluidRow(
#     column(12, plotOutput("age_sex"))
#   ),
#   fluidRow(
#     column(2, actionButton("story", "Tell me a story")),
#     column(10, textOutput("narrative"))
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   selected <- reactive(injuries %>% filter(prod_code == input$code))
#   
#   output$diag <- renderTable(count_top(selected(), diag), width = "100%")
#   output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
#   output$location <- renderTable(count_top(selected(), location), width = "100%")
#   
#   
#   summary <- reactive({
#     selected() %>%
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4)
#   })
#   
#   output$age_sex <- renderPlot({
#     if (input$y == "count") {
#       summary() %>%
#         ggplot(aes(age, n, colour = sex)) +
#         geom_line() +
#         labs(y = "Estimated number of injuries")
#     } else {
#       summary() %>%
#         ggplot(aes(age, rate, colour = sex)) +
#         geom_line(na.rm = TRUE) +
#         labs(y = "Injuries per 10,000 people")
#     }
#   }, res = 96)
#   }
# 
# shinyApp(ui, server)


# # V4 ----
# 
# count_top <- function(df, var, n = 5) {
#   df %>%
#     mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
#     group_by({{ var }}) %>%
#     summarise(n = as.integer(sum(weight)))
# }
# 
# 
# ui <- fluidPage(
#   fluidRow(
#     column(8,
#            selectInput("code", "Product",
#                        choices = setNames(products$prod_code, products$title),
#                        width = "100%"
#            )
#     ),
#     column(2, selectInput("y", "Y axis", c("rate", "count"))),
#     # column(2, sliderInput("length_table", "Table Length", min = 1L, max = 20L, value = 5L, step = 1L))
#     column(2, selectInput("length_table", "Table Length", choices = 1:10, selected = 5))
#   ),
#   fluidRow(
#     column(4, tableOutput("diag")),
#     column(4, tableOutput("body_part")),
#     column(4, tableOutput("location"))
#   ),
#   fluidRow(
#     column(12, plotOutput("age_sex"))
#   ),
#   fluidRow(
#     column(2, actionButton("story", "Tell me a story")),
#     column(10, textOutput("narrative"))
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   
#   selected <- reactive(injuries %>% filter(prod_code == input$code))
# 
#   table_length <- reactiveVal()
#   
#   # Works with selectInput dropdown
#   observeEvent(input$length_table, {
#     table_length(as.numeric(input$length_table))
#   })
# 
#   # # Works with sliderInput
#     # observeEvent(input$length_table, {
#   #   table_length(input$length_table)
#   # })
#   
#   output$diag <- renderTable(count_top(selected(), diag, n = table_length()), width = "100%")
#   output$body_part <- renderTable(count_top(selected(), body_part, n = table_length()), width = "100%")
#   output$location <- renderTable(count_top(selected(), location, n = table_length()), width = "100%")
#   
#   
#   summary <- reactive({
#     selected() %>%
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4)
#   })
#   
#   output$age_sex <- renderPlot({
#     if (input$y == "count") {
#       summary() %>%
#         ggplot(aes(age, n, colour = sex)) +
#         geom_line() +
#         labs(y = "Estimated number of injuries")
#     } else {
#       summary() %>%
#         ggplot(aes(age, rate, colour = sex)) +
#         geom_line(na.rm = TRUE) +
#         labs(y = "Injuries per 10,000 people")
#     }
#   }, res = 96)
#   
#   narrative_sample <- eventReactive(
#     list(input$story, selected()),
#     selected() %>% pull(narrative) %>% sample(1)
#   )
#   output$narrative <- renderText(narrative_sample())
#   
# }
# 
# shinyApp(ui, server)



# Ex 1 ----
# Ex 2 ----


# Ex 3 ----

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}


ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count"))),
    column(2, sliderInput("length_table", "Table Length", min = 1L, max = 20L, value = 5L, step = 1L))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
)


server <- function(input, output, session) {
  
  selected <- reactive(injuries %>% filter(prod_code == input$code))

  table_length <- reactive(input$length_table)

  output$diag <- renderTable(count_top(selected(), diag, n = table_length()), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, n = table_length()), width = "100%")
  output$location <- renderTable(count_top(selected(), location, n = table_length()), width = "100%")
  
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)
  
  narrative_sample <- eventReactive(
    list(input$story, selected()),
    selected() %>% pull(narrative) %>% sample(1)
  )
  output$narrative <- renderText(narrative_sample())
  
}

shinyApp(ui, server)



# Ex 4a ----
# Provide a way to step through every narrative systematically with forward and backward buttons



# Ex 4b ----
# Make the list of narratives “circular” so that advancing forward from the last narrative takes you to the first.