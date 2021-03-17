
library(shiny)
library(DT)
library(collapse)
library(shinyBS)
library(stringi)
library(rlang)
ui <- navbarPage("Smart Cart",
                 tabPanel("Home",
                          
                          fluidRow(
                            column(12,
                                   div(img(src='https://raw.githubusercontent.com/ML1000-GroupB/Project/main/www/g2.png?raw=true',height = 300, width = 670),style="text-align: center;")
                            )),
                          tabsetPanel(
                            type="tabs",
                            tabPanel("Top Selling",
                                     # mainPanel(DTOutput('table'))),
                                     
                                     mainPanel(
                                       # actionButton("p1Button", "Produce"),
                                       # actionButton("p2Button","Frozen"),
                                       # actionButton("p3Button","Personal Care"),
                                       bsCollapse(id = "collapseExample", open = "Panel 2",
                                                  bsCollapsePanel("Produce", selectInput(inputId = "select1",
                                                                                         label = "your first produce product",
                                                                                         choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))),
                                                                  actionLink(inputId = "cart1", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                                  selectInput(inputId = "select2",
                                                                              label = "your second produce product",
                                                                              choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))),
                                                                  actionLink(inputId = "cart2", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                                  selectInput(inputId = "select3",
                                                                              label = "your third produce product",
                                                                              choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))),
                                                                  actionLink(inputId = "cart3", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                              #     DTOutput('table1'),
                                                                  style = "info"),
                                                  
                                                  bsCollapsePanel("Dairy Eggs", 
                                                                  selectInput(inputId = "select4",
                                                                                            label = "your dairy or egg product",
                                                                                            choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table2.rds?raw=true"))),
                                                                  
                                                                  actionLink(inputId = "cart4", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                               #   DTOutput('table2'),
                                                                  style = "success"),
                                                  
                                                  bsCollapsePanel("Beverages", selectInput(inputId = "select5",
                                                                                           label = "your beverage product",
                                                                                           choices = "Sparkling Water Grapefruit"),
                                                                  
                                                                  actionLink(inputId = "cart5", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                              #    DTOutput('table3'), 
                                                                  style = "info"),
                                                  
                                                  bsCollapsePanel("Deli", selectInput(inputId = "select6",
                                                                                      label = "your deli product",
                                                                                      choices = "Original Hummus"),
                                                                  
                                                                  actionLink(inputId = "cart6", label = "Add to cart", 
                                                                             icon = icon("shopping-cart")),
                                                                  
                                                                 # DTOutput('table4'), 
                                                                  style = "success")
                                       ))),
                            tabPanel("Orders",
                                     verbatimTextOutput("text1"),
                                     verbatimTextOutput("text2"),
                                     verbatimTextOutput("text3"),
                                     verbatimTextOutput("text4"),
                                     verbatimTextOutput("text5"),
                                     verbatimTextOutput("text6"),
                                     verbatimTextOutput("text7")
                                     ),
                            tabPanel("Confirmation")
                            
                          )
                 ),
                 tabPanel("About Us",
                          h3("Why to associate with Smart cart?"),
                          br(),
                          h5("Smart Cart is a tool that will help with your online grocery orders.","Smart cart recommends you with products based on purchase history.","Never come home from shopping just to realize that you forgot to buy pancake mix, olive oil and first aid. ")),
                 tabPanel("Contact Us",
                          a(actionButton(inputId = "email1", label = "Send Email", 
                                         icon = icon("envelope", lib = "font-awesome")),
                            href="mailto:admin@smartcart.com"))
)


server <- function(input, output) {
  
  options(shiny.maxRequestSize = 30*1024^2)
  
  X_apri_rule=readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/trained_rules.rds?raw=true"))
  

    rhs1 = reactive ({
      
        dynamicrule1=subset(X_apri_rule, lhs %in% input$select1)
        rhs1=unique(dynamicrule1@rhs@itemInfo$labels[dynamicrule1@rhs@data@i+1])

    })
  

  rhs2 = reactive ({
    
    dynamicrule2=subset(X_apri_rule, lhs %in% input$select2)
    rhs2=unique(dynamicrule2@rhs@itemInfo$labels[dynamicrule2@rhs@data@i+1])
    
  })
  
  
  rhs3 = reactive ({
    
    dynamicrule3=subset(X_apri_rule, lhs %in% input$select3)
    rhs3=unique(dynamicrule3@rhs@itemInfo$labels[dynamicrule3@rhs@data@i+1])
    
  })
  
  rhs4 = reactive ({
    
    dynamicrule4=subset(X_apri_rule, lhs %in% input$select4)
    rhs4=unique(dynamicrule4@rhs@itemInfo$labels[dynamicrule4@rhs@data@i+1])
    
  })
  
  
  rhs5 = reactive ({
    
    dynamicrule5=subset(X_apri_rule, lhs %in% input$select5)
    rhs5=unique(dynamicrule5@rhs@itemInfo$labels[dynamicrule5@rhs@data@i+1])
    
  })  
  
  rhs6 = reactive ({
    
    dynamicrule6=subset(X_apri_rule, lhs %in% input$select6)
    rhs6=unique(dynamicrule6@rhs@itemInfo$labels[dynamicrule6@rhs@data@i+1])
    
  })   
  
  
  text1 <- eventReactive(input$cart1, {
    if (is_empty(rhs1())==FALSE)
    print(rhs1()) 
  })
  

 text2 <-eventReactive(input$cart2, {
   if (is_empty(rhs2())==FALSE)
   print(rhs2())
 })
 
 
 text3 <-eventReactive(input$cart3, {
   if (is_empty(rhs3())==FALSE)
   print(rhs3())
 })
 
 text4 <-eventReactive(input$cart4, {
   if (is_empty(rhs4())==FALSE)
   print(rhs4())
 })
 
 text5 <-eventReactive(input$cart5, {
   if (is_empty(rhs5())==FALSE)
   print(rhs5())
 })
 
 text6 <-eventReactive(input$cart6, {
  if (is_empty(rhs6())==FALSE) {
    print(rhs6())
  }
 })
 
 
  output$text1 <-renderPrint(text1())
  output$text2 <-renderPrint(text2())
  output$text3 <-renderPrint(text3())
  output$text4 <-renderPrint(text4())
  output$text5 <-renderPrint(text5())
  output$text6 <-renderPrint(text6())


text7 <-reactive({
    
  cat("These items are frequently bought with the products in your cart: ",
      paste0(stri_unique(c(text1(),text2(),text3(),text4(),text5(),text6())),sep=",")
      
  )
}
)
  
  
  output$text7 <-renderPrint(text7())
  

  
  
  output$table1 <- renderDT(readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true")))
  output$table2 <- renderDT(readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table2.rds?raw=true")))
  output$table3 <- renderDT(readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table3.rds?raw=true")))
  output$table4 <- renderDT(readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table4.rds?raw=true")))
}



# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server )


