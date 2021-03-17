
library(shiny)
library(arules)
library(dplyr)
library(shinyWidgets)

ui <- fluidPage(
  
  titlePanel("Recommendations based on your shopping cart!"),
  
  fluidRow(
    column(3,
           selectInput(inputId = "select1",
                label = "your first produce product",
                choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))),
#    actionLink(inputId = "cart1", label = "Add to cart", 
#               icon = icon("shopping-cart")) 
           ),
    column(3, 
           selectInput(inputId = "select2",
                       label = "your first produce product",
                       choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))),
#           actionLink(inputId = "cart2", label = "Add to cart", 
#                      icon = icon("shopping-cart"))  
    )

    ),
  
    br(),
  
    mainPanel(
textOutput("text1")
)
    
)

server <- function(input, output) {
  
  options(shiny.maxRequestSize = 30*1024^2)
  
  
#  input_data_upload = reactive({
    
#    inFile <- input$file1
    
#    if (is.null(inFile)) {
#      input_data_upload <- read.csv("https://raw.githubusercontent.com/ML1000-GroupB/Project/main/orders_TRAIN_products_MERGED_subset for association rule.csv",
#                                    stringsAsFactors = T,header = T)
#      input_data_upload=as.data.frame(input_data_upload)
      
#      input_data_upload$order_id=as.factor(input_data_upload$order_id)
#      input_data_upload$product_id=as.factor(input_data_upload$product_id)
      
#      input_data_upload[,1] = as.factor(input_data_upload[,1])
#      input_data_upload[,2] = as.factor(input_data_upload[,2])
#      input_data_upload
#    }
#  })
  

  X_apri_rule=readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/trained_rules.rds?raw=true"))

  
  rhs1 = reactive ({
    
#    if (is.null(input_data_upload())) {return()} else {
    
#    Order_by_product <- split(input_data_upload()$product_name, input_data_upload()$order_id)
#  X1_trans <- as(Order_by_product, "transactions")
#  X_apri_rule=apriori(X1_trans,parameter=list(supp=0.0015, conf=0.4), control=list(verbose = FALSE))
 
   dynamicrule=subset(X_apri_rule, lhs %in% input$select1)
  rhs1=unique(dynamicrule@rhs@itemInfo$labels[dynamicrule@rhs@data@i+1])

#    }
    
  })
  
  
 output$text1<-renderPrint(print(rhs1()))

 
}



# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server )

