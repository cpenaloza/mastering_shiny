#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFeedback)

ui <- fluidPage(
    shinyFeedback::useShinyFeedback(),
    numericInput("n", "n", value = 10),
    textOutput("half")
)

server <- function(input, output, session) {
    observeEvent(input$n,
                 shinyFeedback::feedbackWarning(
                     "n",
                     input$n %% 2 != 0,
                     "Please select an even number"
                 )
    )
    output$half <- renderText(input$n / 2)
}



# library(sortable)
# library(shinyFeedback)
# source('/Users/ieclabau/git/shiny_BioLockJ/shiny_app/biolockj.R')
# source('/Users/ieclabau/git/shiny_BioLockJ/shiny_app/biolockj_gui_bridge.R')
# 
# ui <-  fluidPage(    
#     h2("BioModule Run Order"),
#     fluidRow(
#         column(5,selectInput("AddBioModule", 
#                              "Select new BioModule", 
#                              names(moduleInfo), 
#                              selected = "GenMod",
#                              width = '100%')),
#         column(1, "AS", style = "margin-top: 30px;"),
#         column(4, textInput("newAlias", "", 
#                             placeholder = "alternative alias",
#                             width = '100%')),
#         column(2, actionButton("AddModuleButton", style = "margin-top: 20px;", "add to pipeline", class = "btn-success"))),
#     uiOutput("manageModules"),
#     actionButton("emptyModuleTrash", "Empty Trash", class = "btn-danger")
# )
# 
# server <- function(input, output, session){
#     values <- reactiveValues(moduleList=list(), customProps=list(), removedModules=list())
#     
#     # Modules
#     output$manageModules <- renderUI({
#         bucket_list(
#             header="",
#             add_rank_list(
#                 text = "Drag and drop to re-order",
#                 labels = c(LETTERS),#values$moduleList,
#                 input_id = "orderModules",
#                 options = sortable_options(multiDrag = TRUE)),
#             add_rank_list(
#                 text="trash",
#                 labels = c(),#values$removedModules,
#                 input_id = "trashModules",
#                 options = sortable_options(multiDrag = TRUE)),
#             group_name="allModules",
#             orientation="vertical")
#     })
#     
#     # Buttons
#     observeEvent(input$AddModuleButton, {
#         runLine = makeRunLine(input$AddBioModule, input$newAlias)
#         msg = capture.output({
#             goodAlias = isValidAlias(aliasFromRunline(runLine), aliases())
#         }, type="message")
#         shinyFeedback::feedbackDanger("newAlias", !goodAlias, msg)
#         req(goodAlias)
#         values$moduleList <- c(isolate(input$orderModules), runLine)
#         updateTextInput(session, "newAlias", value = "")
#     })
#     
#     observeEvent(input$emptyModuleTrash, {
#         message("you are trying to trash some modules")
#         message("Current modules in trash are: ", input$trashModules)
#     })
# }
# 

# Run the application 
shinyApp(ui = ui, server = server, options=list(display.mode="showcase"))
