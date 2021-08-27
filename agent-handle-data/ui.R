# Web app to display pet records and keep track of visits, test results, vaccines, etc.

library(shiny)
library(shinythemes)
library(sparkline)
library(timevis)
library(DT)
library(shinycssloaders)
library(fontawesome)

ui <- fluidPage(
  titlePanel("Agent Summary"),

  sidebarLayout(
    sidebarPanel("Individual Agent Data",
		width = 2,
                 # display options for pet selection ####
                 uiOutput("all_agents"),
		uiOutput("selected_agent"),HTML("</br>"),
		uiOutput("call_drivers")
		),
		
    mainPanel("All Agent Data",width =10, 
		tabsetPanel(type = "tabs",
			   tabPanel("Individual Agent", plotOutput("plot2")),
			   tabPanel("Agent Table", dataTableOutput("table")),
			   tabPanel("Comparison to Reference", uiOutput("ttest"))
		)
	
	     )
	)
)
