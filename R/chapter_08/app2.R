library(shiny)

shinyApp(
    ui = fluidPage(
        tags$head(
            tags$style(
                HTML(".shiny-notification-success {
             color: #31708f;
             background-color: #d9edf7;
             border: 1px solid #bce8f1;
             }")
            )
        ),
        # .shiny-notification-message {
        #     color: #31708f;
        #         background-color: #d9edf7;
        #         border: 1px solid #bce8f1;
        # }
        
        # tags$head(
        #     tags$style(
        #         HTML(".shiny-notification {
        #      position:fixed;
        #      bottom: calc(20%);
        #      left: calc(50%);
        #      right: calc(2%);
        #      }")
        #     )
        # ),
        # tags$head(
        #     tags$style(
        #         HTML(".shiny-notification-wide {
        #      position:fixed;
        #      bottom: calc(2%);
        #      left: calc(2%);
        #      right: calc(2%);
        #      }")
        #     )
        # ),
        textInput("txt", "Content", "Text of message"),
        radioButtons("duration", "Seconds before fading out",
                     choices = c("2", "5", "10", "Never"),
                     inline = TRUE
        ),
        radioButtons("type", "Type",
                     choices = c("default", "message", "warning", "error", "success"),
                     inline = TRUE
        ),
        checkboxInput("close", "Close button?", TRUE),
        actionButton("show", "Show"),
        actionButton("remove", "Remove most recent")
    ),
    server = function(input, output) {
        id <- NULL
        
        observeEvent(input$show, {
            if (input$duration == "Never")
                duration <- NA
            else 
                duration <- as.numeric(input$duration)
            
            type <- input$type
            if (is.null(type)) type <- NULL
            
            id <<- showNotification(
                input$txt,
                duration = duration, 
                closeButton = input$close,
                type = type
            )
            id2 <<- showNotification(
                "This is the wide one.",
                duration = duration, 
                closeButton = input$close,
                type = type
            )
        })
        
        observeEvent(input$remove, {
            removeNotification(id)
            removeNotification(id2)
        })
    }
)