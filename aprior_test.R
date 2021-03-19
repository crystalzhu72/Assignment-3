


library(shiny)
library(DT)
library(collapse)
library(shinyBS)
library(stringi)
library(rlang)
library(shinythemes)
library(Matrix)
library(dplyr)
library(rsparse)
library(arules)

table1<-readRDS("table1.rds")
table2<-readRDS("table2.rds")
table3<-readRDS("table3.rds")
table4<-readRDS("table4.rds")
table5<-readRDS("table5.rds")
table6<-readRDS("table6.rds")
products<-readRDS("products.rds")
mcname<-readRDS("mcname.rds")
model<-readRDS("model.rds")


shinyApp(ui <- navbarPage(
  "Smart Cart",
  tabPanel("HOME",icon=icon("home"),
           
           fluidRow(
             column(12,
                    img(src='./g2.png')
             )),
           tabsetPanel(
             id = "tabs",
             type="tabs",
             tabPanel("TOP SELLING",
                      mainPanel(
                        bsCollapse(id = "collapseExample", open = "Panel 2",
                                   bsCollapsePanel("Produce", selectInput(inputId = "select1",
                                                                          label = "Item1:",
                                                                          choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table6.rds?raw=true"))[,1]),
                                          #         actionLink(inputId = "cart1", label = "Add to cart", 
                                          #                   icon = icon("shopping-cart")),

                                                   selectInput(inputId = "select2",
                                                               label = "Item2:",
                                                               choices =readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table6.rds?raw=true"))[,1] ),
                                          #         actionLink(inputId = "cart2", label = "Add to cart", 
                                          #                    icon = icon("shopping-cart")),
                                                   
                                                   selectInput(inputId = "select3",
                                                               label = "Item3:",
                                                               choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table6.rds?raw=true"))[,1]),
                                         #          actionLink(inputId = "cart3", label = "Add to cart", 
                                        #                      icon = icon("shopping-cart")),
                                                   style = "info"),
                                   
                                   bsCollapsePanel("Dairy/Eggs", 
                                                   selectInput(inputId = "select4",
                                                               label = "Item1:",
                                                               choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table3.rds?raw=true"))[,1]),
                                                   
                                          #         actionLink(inputId = "cart4", label = "Add to cart", 
                                           #                   icon = icon("shopping-cart")),
                                                   style = "success"),
                                   
                                   bsCollapsePanel("Beverages", selectInput(inputId = "select5",
                                                                            label = "Item1:",
                                                                            choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table2.rds?raw=true"))[,1]),
                                                   
                                           #        actionLink(inputId = "cart5", label = "Add to cart", 
                                          #                    icon = icon("shopping-cart")),
                                                   style = "info"),
                                   
                                   bsCollapsePanel("Deli", selectInput(inputId = "select6",
                                                                       label = "Item1:",
                                                                       choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table4.rds?raw=true"))[,1]),
                                                   
                                          #         actionLink(inputId = "cart6", label = "Add to cart", 
                                          #                    icon = icon("shopping-cart")),
                                                   
                                                   style = "success"),
                                   
                                   bsCollapsePanel("Bakery", selectInput(inputId = "select7",
                                                                         label = "Item1:",
                                                                         choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table1.rds?raw=true"))[,1]),
                                                   
                                             #      actionLink(inputId = "cart7", label = "Add to cart", 
                                            #                  icon = icon("shopping-cart")),
                                                   style = "info"),
                                   
                                   bsCollapsePanel("Frozen", selectInput(inputId = "select8",
                                                                         label = "Item1:",
                                                                         choices = readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/table5.rds?raw=true"))[,1]),
                                                   
                                            #       actionLink(inputId = "cart8", label = "Add to cart", 
                                            #                  icon = icon("shopping-cart")),
                                                   style = "info")
                                   
                        ),
                        actionButton("buynow", "ADD TO BAG",class = "btn-primary")
                        
                      )),
             tabPanel("SHOPPING BAG",
                      h3("You have added below items "),
                      verbatimTextOutput("text10"),
                      br(),
                      br(),
           #           dataTableOutput("tableorder"),
                      br(),
                      h3("You May Also Like"),
                      verbatimTextOutput("text9"),
                      
                      actionButton("paynow", "CHECK OUT",class = "btn-primary")
             ),
           tabPanel("ORDERS",
                    h3("You have checked out below items"),
                    #                     verbatimTextOutput("text10"),
                    br(),
                    br(),
                    dataTableOutput("tableconfirm"),
                    br(),
                    h3("Shoppers Also Viewed "),
                    br(),
                    br(),
                    dataTableOutput("tablepred"),
                    actionButton("confirmnow", "PLACE ORDER",class = "btn-primary"),
                    br(),
                    br(),
                    bsModal(id="pop",title="Thank You !!",trigger="confirmnow",size="medium",
                            verbatimTextOutput("thank")))
           
           )
             
           
  ),
  tabPanel("ABOUT US",icon=icon("tags"),
           h3("Why to associate with Smart cart?"),
           br(),
           h5("Smart Cart is a tool that will help with your online grocery orders.","Smart cart recommends you with products based on purchase history.","Never come home from shopping just to realize that you forgot to buy pancake mix, olive oil and first aid. ")),
  tabPanel("CONTACT US",icon=icon("envelope"),
           a(actionButton(inputId = "email1", label = "Send Email", 
                          icon = icon("envelope", lib = "font-awesome")),
             href="mailto:admin@smartcart.com"))
),

server <- function(input, output,session) {
  
  # options(shiny.maxRequestSize = 30*1024^2)
  
  
  
  X_apri_rule=readRDS(url("https://github.com/ML1000-GroupB/Project/blob/main/trained_rules_prior.rds?raw=true"))
  
  observeEvent(
    input$buynow, 
    {
      updateTabsetPanel(session = session, inputId = "tabs", selected = "SHOPPING BAG")
      
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
      
      rhs7 = reactive ({
        
        dynamicrule7=subset(X_apri_rule, lhs %in% input$select7)
        rhs7=unique(dynamicrule7@rhs@itemInfo$labels[dynamicrule7@rhs@data@i+1])
        
      })   
      
      rhs8 = reactive ({
        
        dynamicrule8=subset(X_apri_rule, lhs %in% input$select8)
        rhs8=unique(dynamicrule8@rhs@itemInfo$labels[dynamicrule8@rhs@data@i+1])
        
      })   
      
      
      text1 <- reactive(
        
        {
          if (is_empty(rhs1())==FALSE)
            rhs1() 
        }
      ) 
      
      
      text2 <-reactive(
        {
          if (is_empty(rhs2())==FALSE)
           rhs2()
        } 
      ) 
      
      
      text3 <-reactive(
        {
          if (is_empty(rhs3())==FALSE)
            rhs3()
        } 
      ) 
      
      text4 <- reactive(
        {
          if (is_empty(rhs4())==FALSE)
            rhs4()
        }  
      ) 
      
      text5 <-reactive(
        {
          if (is_empty(rhs5())==FALSE)
            rhs5()
        }    
      ) 
      
      text6 <- reactive(
        {
          if (is_empty(rhs6())==FALSE) {
            rhs6()
          }
        }
      )
      
      
      text7 <- reactive(
        {
          if (is_empty(rhs7())==FALSE) {
            rhs7()
          }
        }
      )
      
      
      text8 <- reactive(
        {
          if (is_empty(rhs8())==FALSE) {
            rhs8()
          }
        }
      )
      
      
      
      text9 <-reactive( {
        
        cat("These items are frequently bought with the products in your cart: ",
            paste0(stri_unique(c(text1(),text2(),text3(),text4(),text5(),text6(),text7(),text8())),sep=",")
            
        )
      }
      )
      
      output$text9 <-renderPrint(text9())
      
      text10 <- reactive({
        
            c(input$select1, input$select2, input$select3, input$select4,input$select5, input$select6,input$select7, input$select8 )
#        print(input$select1)
      }
      )
      
      output$text10 <-renderPrint(text10())
      

      
      
      
      observeEvent(input$paynow, {
        
        #dataframe based on user inputs
        products_select<-rbind(input$select1,input$select2,input$select3,input$select4,input$select5,input$select6)
        products_select<-as.data.frame(products_select)
        names(products_select)<-c("product_name")
        products_select$product_id<-products_select %>% 
          left_join(products,by="product_name") %>% 
          select(product_id) 
        
        
        users <- data.frame(user_id = c("13726"))
        prod<-data.frame(product_id =mcname)
        #ord<-data.frame(user_id = c("13726"),product_id=c("196","130","13176"))
        
        
        
        #dataframe with column numbers
        ord$RowIdx <- match(ord$user_id, users$user_id)
        ord$ColIdx <- match(ord$product_id, prod$product_id)
        
        
        
        
        
        #create sparse matrix for model input
        # matSparse3 <- sparseMatrix(
        #   i = ord$RowIdx,
        #   j = ord$ColIdx,
        #   x = 1L,
        #   dims = c(nrow(users), nrow(prod)),
        #   dimnames = list(users$user_id, prod$product_id)
        # )
        
        
        # new_user_predictions <- model$predict(matSparse3, k =3)
        # top_list <- as(new_user_predictions, "list")
        # 
        # table_recom<-products %>%
        #   filter(product_id %in% top_list) %>%
        #   select(product_id,product_name)
        # table_recom
        
        
        output$tablepred<-renderDataTable({
          datatable(
            table_recom %>% 
              select(product_name),
            colnames=c("Product Name"))
          
        })
        
      })
      
      
      
      
      
      
      
      observeEvent(input$buynow, {
        updateTabsetPanel(session = session, inputId = "tabs", selected = "SHOPPING BAG")
        
        
        products_select<-rbind(input$select1,input$select2,input$select3,input$select4,input$select5,input$select6)
        products_select<-as.data.frame(products_select)
        names(products_select)<-c("product_name")
        products_select$product_id<-products_select %>% 
          left_join(products,by="product_name") %>% 
          select(product_id)    
        
        
        output$tableorder <- renderDataTable({
          datatable(
            products_select %>% 
              select(product_name),
            colnames=c("Serial","Product Name"))
          
        })
        
        output$tableconfirm <- renderDataTable({
          datatable(
            products_select %>% 
              select(product_name),
            colnames=c("Serial","Product Name"))
          
        })
        
        
      })
      
      observeEvent(input$paynow, {
        updateTabsetPanel(session = session, inputId = "tabs", selected = "ORDERS")
      })
      
      
      
      
      
      thanks<-eventReactive(input$confirmnow,
                            {print("Your order is being processed. Your support is invaluable !!")}
      )
      
      output$thank<-renderText(thanks())
      
      
      
  
 
  
  
  
  
  

  
  
}
)


# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server )


