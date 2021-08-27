# Web app to display pet records and keep track of visits, test results, vaccines, etc.

library(shiny)
library(dplyr)
library(stringr)
library(purrr)
library(tibble)
library(timevis)
library(DT)
library(aws.s3)
library(sparkline)
library(magick)
library(RSQLite)
library(lubridate)
library(fs)
library(readxl)
library(ggplot2)



#survey_data <- read_excel("data/Survey Data - July.xlsx",sheet="survey",col_names=TRUE)
survey_data <- read.csv("data/Survey Data - July.csv")
call_data <- read.csv("data/10497683-call-data_2021-07-14-152457.csv")
call_data_clean = subset(call_data, subset = !(CallDriver %in% c(NA,""," ","restart")))
test_mean_summary<-call_data_clean %>% group_by(CallDriver,week(as.Date(Date,"%m/%d/%y")),Summarise=mean(Total.Time))%>%summarise_at(vars("Total.Time"), mean)
call_drivers<-unique(test_mean_summary["CallDriver"])


agents<-unique(survey_data["Name"])
#print(agents)
reference_agent = "Janet Delacruz"

function(input, output, session) {
  output$all_agents <- renderUI({
    selectInput(inputId = "agent",
                 label = "Select agent:",
                 choices = agents)
  })

output$call_drivers <- renderUI({
    selectInput(inputId = "call_driver",
                 label = "Select Call Driver:",
                 choices = call_drivers)
  })


observeEvent(input$agent, {
	output$selected_agent<-renderText({
	paste("Agent Selected:", input$agent, sep = "<br>")
	})
	agent_data = subset(survey_data, subset = Name == input$agent)
	dat <- reactive({
    		agent_data
		print(agent_data)
	})
	output$plot2<-renderPlot({
		#ggplot(agent_data,aes(x=Date,y=CSAT))+geom_point(colour='red'),height = 400,width = 600)
    		ggplot(dat(),aes(x=Date,y=CSAT))+geom_point(colour='red')},height = 400,width = 600)
	output$table<-renderDataTable({dat()})
	csat_reference = subset(survey_data, subset = Name == reference_agent)["CSAT"]
	csat_target =  subset(survey_data, subset = Name == input$agent)["CSAT"]
	tout <-t.test(csat_target,csat_reference)
	
	output$ttest<-renderText({
		paste("t-test: ", tout$statistic,"</br>","p-value: ", tout$p.value, sep = " ")
     })
     
})
	
}