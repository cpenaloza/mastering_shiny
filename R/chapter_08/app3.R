
library(shiny)
library(shinyFeedback)

initVal = "initial value"

ui <- fluidPage(
    textInput("box1", "box 1", placeholder = "value 1", value = initVal),
    textInput("box2", "box 2", placeholder = "value 2", value = initVal),
    
    verbatimTextOutput("value"),
)

server <- function(input, output, session) {
   value <- reactiveVal(initVal)
   
    observeEvent(input$box1,{
        value(input$box1)
        updateTextInput(session, "box2", value=value())
    })
   
     observeEvent(input$box2,{
        value(input$box2)
        updateTextInput(session, "box1", value=value())
    })
    
     output$value <- renderText(value())
}

# Run the application 
shinyApp(ui = ui, server = server)
