# This app calculates summary data for various components of the City of Sacramento budget.

library(shiny)
library(dplyr)
library(ggplot2)

# Acquire the data
if(!file.exists("sacbudget.csv")){
download.file(url="https://opendata.arcgis.com/datasets/00aa04d56178482b8b33248d32a2cd12_0.csv", 
              destfile = "sacbudget.csv")
}

# Read in the data
sacbudget <- read.csv("sacbudget.csv")

# Rename a couple categories to make slightly more sense in English
levels(sacbudget$FUND_SUMMARY)[1:2] <- c("CIRBS","Gas Tax")



# Define UI for application
ui <- fluidPage(
   
   # Application title
   titlePanel("City of Sacramento Budget, FY2015-FY2018"),
   
   # Sidebar with four select boxes for different budget categories 
   sidebarLayout(
      sidebarPanel(h3("Select which budget category you would like to see displayed"),
         selectInput("op_unit",
                     "Operating Unit",
                     choices = c("All", levels(sacbudget$OPERATING_UNIT_DESCRIPTION))),
         selectInput("obj_class",
                     "Object Class",
                     choices = c("All", levels(sacbudget$OJBECT_CLASS))),
         selectInput("fund_summ",
                     "Fund Summary",
                     choices = c("All", levels(sacbudget$FUND_SUMMARY))),
         selectInput("account_cat",
                     "Account Category",
                     choices = c("All", levels(sacbudget$ACCOUNT_CATEGORY)))
      ),
      
      # Main output with two tabs, one with help documentation and the other with the app itself
      mainPanel(
        tabsetPanel(
          
          # First tab: Help documentation
          tabPanel("Help",
          h3("This app displays a few basic pieces of information for specific categories of the City of Sacramento budget for fiscal years 2015-2018."), 
          h3("The data are from the Sacramento Open Data website at data.cityofsacramento.org."),
          h3("The user can select a specific Operating Unit, Object Class, Fund Summary, and/or Account Category"),
          h3("The app displays the total amount budgeted for the selected category or categories, and what percentage of the total budget this represents."), 
          h3("Additionally, since the budget data covers four years, the budget amount for each year is displayed."),
          h3("Not all combinations have money budgeted. The app is most useful exploring one category at a time."),
          h3("For a good example, set 'Operating Unit' to 'Citywide and Community Support' while leaving the other three options set to 'All'. Citywide and Community support account for a sizable portion of the budget.")
          ),
          
          # Second tab: The app proper (output)
          tabPanel("App",
          textOutput("total"),
          textOutput("percent"),
          plotOutput("pie"),
          h4("Here is the budget amount for each year. If the selected budget items total $0, the chart will be empty."),
          tableOutput("annual"),
          plotOutput("yearplot")))
      )
   )
)

# Define server logic
server <- function(input, output) {
   
   # Show the total amount spent on these categories
   output$total <- renderText({
      if(input$op_unit != "All"){
        sacbudget <- sacbudget[sacbudget$OPERATING_UNIT_DESCRIPTION == input$op_unit,]
      }
      if(input$obj_class != "All"){
         sacbudget <- sacbudget[sacbudget$OJBECT_CLASS == input$obj_class,]
       }
       if(input$fund_summ != "All"){
         sacbudget <- sacbudget[sacbudget$FUND_SUMMARY == input$fund_summ,]
      }
       if(input$account_cat != "All"){
         sacbudget <- sacbudget[sacbudget$ACCOUNT_CATEGORY == input$account_cat,]
      }
       paste(c("The City of Sacramento budgeted $", 
               sum(sacbudget$BUDGET_AMOUNT), 
               "for these purposes from 2015-2018."))
     })

   # Show budget amount as a percent of total budget
   output$percent <- renderText({
     if(input$op_unit != "All"){
       sacbudget <- sacbudget[sacbudget$OPERATING_UNIT_DESCRIPTION == input$op_unit,]
     }
     if(input$obj_class != "All"){
       sacbudget <- sacbudget[sacbudget$OJBECT_CLASS == input$obj_class,]
     }
     if(input$fund_summ != "All"){
       sacbudget <- sacbudget[sacbudget$FUND_SUMMARY == input$fund_summ,]
     }
     if(input$account_cat != "All"){
       sacbudget <- sacbudget[sacbudget$ACCOUNT_CATEGORY == input$account_cat,]
     }
     paste(c("These categories accounted for", 
             round(sum(sacbudget$BUDGET_AMOUNT)/71915554.57,2), 
             "% of the Sacramento budget during that period."))
   })
   
   # Show the budget percentage in a pie chart
   output$pie <- renderPlot({
     if(input$op_unit != "All"){
       sacbudget <- sacbudget[sacbudget$OPERATING_UNIT_DESCRIPTION == input$op_unit,]
     }
     if(input$obj_class != "All"){
       sacbudget <- sacbudget[sacbudget$OJBECT_CLASS == input$obj_class,]
     }
     if(input$fund_summ != "All"){
       sacbudget <- sacbudget[sacbudget$FUND_SUMMARY == input$fund_summ,]
     }
     if(input$account_cat != "All"){
       sacbudget <- sacbudget[sacbudget$ACCOUNT_CATEGORY == input$account_cat,]
     }
     pie(c(sum(sacbudget$BUDGET_AMOUNT),(7191555457 - sum(sacbudget$BUDGET_AMOUNT))), col = c("lightblue","whitesmoke"), main = "Percent of Budget", labels = c("Selected Categories","Other"))
   })
   
   # Show the budget amount per year
   output$annual <- renderTable({
     if(input$op_unit != "All"){
       sacbudget <- sacbudget[sacbudget$OPERATING_UNIT_DESCRIPTION == input$op_unit,]
     }
     if(input$obj_class != "All"){
       sacbudget <- sacbudget[sacbudget$OJBECT_CLASS == input$obj_class,]
     }
     if(input$fund_summ != "All"){
       sacbudget <- sacbudget[sacbudget$FUND_SUMMARY == input$fund_summ,]
     }
     if(input$account_cat != "All"){
       sacbudget <- sacbudget[sacbudget$ACCOUNT_CATEGORY == input$account_cat,]
     }
     grouped_budget <- group_by(sacbudget, YEAR)
     annual <- summarise(grouped_budget, sum(BUDGET_AMOUNT))
     names(annual)[2] <- "Yearly Total"
     annual
   })
   
   # Show the annual budget amount as a bar chart
   output$yearplot <- renderPlot({
     if(input$op_unit != "All"){
       sacbudget <- sacbudget[sacbudget$OPERATING_UNIT_DESCRIPTION == input$op_unit,]
     }
     if(input$obj_class != "All"){
       sacbudget <- sacbudget[sacbudget$OJBECT_CLASS == input$obj_class,]
     }
     if(input$fund_summ != "All"){
       sacbudget <- sacbudget[sacbudget$FUND_SUMMARY == input$fund_summ,]
     }
     if(input$account_cat != "All"){
       sacbudget <- sacbudget[sacbudget$ACCOUNT_CATEGORY == input$account_cat,]
     }
     grouped_budget <- group_by(sacbudget, YEAR)
     annual <- summarise(grouped_budget, sum(BUDGET_AMOUNT))
     names(annual)[2] <- "yeartotal"
     annual$yeartotal <- annual$yeartotal/1000000
     ggplot(annual, aes(x = YEAR, y = yeartotal)) + geom_col(aes(fill = annual$YEAR)) + xlab("Fiscal Year") + theme(legend.title = element_blank()) + ggtitle("Budget per Year") + ylab("Budget Amount (Millions)")
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

