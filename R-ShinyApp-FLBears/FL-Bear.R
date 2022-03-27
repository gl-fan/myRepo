library(shiny)
library(ggplot2)
library(ggthemes)
library(scales)
library(leaflet)
library(dplyr)
library(lubridate)
library(bslib)
library(DT)
library(leaflet.extras)
library(rsconnect)
library(ggsci)


##### DATA CLEANING & PREPARETION#######
bbcall = read.csv('Black_Bear_Related_Calls_in_Florida.csv') %>%
  filter(ReportDate != '') %>%
  dplyr::select(-c('X','Y','Locale','City','ZipCode','TrackNum','last_edited_date')) %>%
  mutate(
    ReportDate = as.Date(substr(ymd_hms(gsub('\\+00','',ReportDate)),0,10),'%Y-%m-%d'),
    CallNature = ifelse( grepl('other', CallNature, ignore.case=T), 'Other',CallNature),
    CallNature = ifelse( CallNature == " ",'Other', CallNature ),
    Latitude = round(Latitude,4),
    Longitude = round(Longitude,4)
  ) 
bbrel = read.csv('FL_Black_Bear_Release_Locations.csv') %>%
  filter(ReportDate != '') %>%
  dplyr::select(c('OBJECTID','BearID','ReportDate','Region','BMU','County','Latitude','Longitude',
                  'CapReason','NCapReason','CapMethod','FinAction','Sex','AgeClass')) %>%
  mutate(
    ReportDate = as.Date(substr(gsub('\\+00','',ReportDate),0,10)),
    CapReason = ifelse( grepl('other', CapReason, ignore.case=T), 'Other',CapReason),
    CapMethod = ifelse(CapMethod == " ",'Other',CapMethod),
    Year = year(ReportDate),
    Latitude = round(Latitude,4),
    Longitude = round(Longitude,4)
  )

bearicon = makeIcon(iconUrl = 'https://img.icons8.com/external-tulpahn-outline-color-tulpahn/64/000000/external-bear-wild-animals-tulpahn-outline-color-tulpahn.png',
                    iconWidth = 25,
                    iconHeight = 25)

bearurl = "<img src='https://img.icons8.com/external-tulpahn-outline-color-tulpahn/64/000000/external-bear-wild-animals-tulpahn-outline-color-tulpahn.png'
            style='width:23px;height:23px;'> Black Bear"



#######UI########
ui = fluidPage(

  ####Theme####
  theme = bs_theme(bootswatch = "minty"),
  
  ####Title####
  titlePanel(
    fluidRow( 

      column(1,tags$a(href='https://myfwc.com/',
                      tags$img(src='https://myfwc.com/media/10566/logo-fwc.png', height = '120px',width='100px'),
                      target = '_blank')),
      column(10,offset=1,tags$div(tags$h2(strong('Florida Fish and Wildlife Conservation Commission')),
                                  tags$h4(em('Black Bear dashboard'))
                                 )
            )
      ),
    windowTitle = 'FWC Black Bear Exporer'
    ),
  
  tags$hr(),
  ####Tab####
  tabsetPanel( type = 'pills',
               header = tags$div(class='text-muted bg-light',
                                 tags$em('*The map contains locations of calls from the human-black bear interactions in FL.'),
                                 tags$p(em('*The data were limited records obtained from the Wildlife Incident Management System (WIMS) database 
                                                 maintained by the Florida Fish and Wildlife Conservation Commission (FWC)'))
                                 ),
                        tabPanel(title = 'Map',
                                 icon = tags$img(src='https://img.icons8.com/external-those-icons-lineal-those-icons/48/000000/external-map-camping-hiking-those-icons-lineal-those-icons.png',
                                        height = '20px',width='20px'),
                                 #### tab 1####
                                 verticalLayout(
                                    tags$div(class='text-muted',
                                      sidebarLayout(
                                        sidebarPanel(
                                          tags$br(),
                                          tags$br(),
                                          dateRangeInput('calldaterange','Date Range',
                                                         min = min(bbcall$ReportDate),
                                                         max = max(bbcall$ReportDate),
                                                         start = min(bbcall$ReportDate),
                                                         end = max(bbcall$ReportDate)),
                                          selectInput('region','Region',choices=c('All',unique(bbcall$Region)),selected = 'All'),
                                          selectInput('county','County', 
                                                      choices = c('All',unique(bbcall$County)),selected = 'All'),
                                          tags$br(),
                                          tags$br()
                                        ), # sidebarpanel
                                        mainPanel(
                                          leafletOutput('callmap', width = '100%')) # mainbarpanel
                                      )
                                    ),
                                    tags$br(),
                                    dataTableOutput('calldata')
                                  )# verticalLayout
                         ), # tab1
               
               tabPanel(title = 'Released Bear Statistics insights',
                        icon = tags$img(src='https://img.icons8.com/fluency-systems-regular/48/000000/bear.png',
                                        height = '20px',width='20px'),
                        #### tab 2####
                        verticalLayout(
                          tags$br(),
                          sidebarLayout(
                            sidebarPanel(
                              dateRangeInput('reldaterange','Date Range',
                                             min = min(bbrel$ReportDate),
                                             max = max(bbrel$ReportDate),
                                             start = min(bbrel$ReportDate),
                                             end = max(bbrel$ReportDate)),
                              selectInput('bgcolor', 'Color the Background:', choices = colors(), selected = 'transparent'), 
                              selectInput('gridcolor', 'Color the Grid:', choices = colors(), selected = 'grey70'), 
                              selectInput('xaxis','X Variable:', 
                                          choices=c('Sex','AgeClass','CapReason','Region','FinAction'),
                                          selected = 'Sex'),
                              selectInput('fillbar','Fill the bar:', 
                                          choices=c('Sex','AgeClass','CapReason','Region','FinAction'),
                                          selected = 'AgeClass')
                          ), # sidebarpanel
                          mainPanel(
                            plotOutput('relbear',height = '580px')
                          ) # mainbarpanel
                        ),
                        tags$br(),
                        dataTableOutput('reldata')
                        )
                        
               ), # tab2
               tabPanel(title = 'Black Bear Annual Trend',
                        icon = tags$img(src='https://img.icons8.com/metro/52/000000/ratings.png',
                                        height = '20px',width='20px'),
                        #### tab 3####
                        verticalLayout(
                          withTags(
                            div(class='text-center',
                                div(class='text-primary',
                                    em(strong('Black Bear Annual Trend By Sex')))
                              )
                          ),
                          tags$br(),
                          sidebarLayout(
                          sidebarPanel(
                            selectInput('Region_s','Select a Region: ',choices=c('All',unique(bbrel$Region))),
                            selectInput('County_s','Select a County: ',choices=c('All',unique(bbrel$County))),
                            tags$hr(),
                            selectInput('CapReason_s','Select a CapReason: ',choices=c('All',unique(bbrel$CapReason))),
                            selectInput('FinAction_s','Select a FinAction: ',choices=c('All',unique(bbrel$FinAction)))
                          ),#sidebarPanel
                          mainPanel(
                            plotOutput('number_of_bear_sex')
                          )#mainPanel
                        ),# sidebarLayout1
                        tags$br(),
                        tags$br(),
                        withTags(
                          div(class='text-center',
                              div(class='text-primary',
                                  em(strong('Black Bear Annual Trend By Age')))
                          )),
                        tags$br(),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput('Region_a','Select a Region: ',choices=c('All',unique(bbrel$Region))),
                            selectInput('County_a','Select a County: ',choices=c('All',unique(bbrel$County))),
                            tags$hr(),
                            selectInput('CapReason_a','Select a CapReason: ',choices=c('All',unique(bbrel$CapReason))),
                            selectInput('FinAction_a','Select a FinAction: ',choices=c('All',unique(bbrel$FinAction)))
                          ),#sidebarPanel
                          mainPanel(
                            plotOutput('number_of_bear_age')
                          )#mainPanel
                         ) # sidebarLayout2
                        )
                    ) # tab3
               # tabsetpanel
               
    ) # titlepanel
) #ui



#######Server######
server = function(input,output,session){

  ######observe######  
  observe({
    
    selectrow = T
    if(input$region != 'All'){selectrow = selectrow & bbcall$Region == input$region}
    call1 = bbcall[selectrow,]
    
    updateSelectInput(session,'county','County',
                      choices = c('All',unique(call1$County)))
  }) 
  
  ######update map######  
  updatecall = reactive({
    selectrow = T
    if(input$region != 'All'){selectrow = selectrow & bbcall$Region == input$region}
    if(input$county != 'All'){selectrow = selectrow & bbcall$County == input$county}
    
    bbcall[selectrow,-1] %>%
      filter(ReportDate >= input$calldaterange[1] & ReportDate <= input$calldaterange[2])
  }) 
  
  ######update release plot###### 
  updaterel = reactive({
    rows = T
    bbrel[rows,-c(1,5,7,8,10,15)] %>%
      filter(ReportDate >= input$reldaterange[1] & ReportDate <= input$reldaterange[2])
  })
  
  ######update sex plot###### 
   plotsex = reactive({
    rowsex = T
    if(input$County_s != 'All'){rowsex=rowsex & bbrel$County == input$County_s}
    if(input$Region_s != 'All'){rowsex=rowsex & bbrel$Region == input$Region_s}
    if(input$CapReason_s != 'All'){rowsex=rowsex & bbrel$CapReason == input$CapReason_s}
    if(input$FinAction_s != 'All'){rowsex=rowsex & bbrel$FinAction == input$FinAction_s}
     
    bbrel[rowsex,-1] 
    })
   
   ######update age plot###### 
   plotage = reactive({
     rowage = T
     if(input$County_a != 'All'){rowage=rowage & bbrel$County == input$County_a}
     if(input$Region_a != 'All'){rowage=rowage & bbrel$Region == input$Region_a}
     if(input$CapReason_a != 'All'){rowage=rowage & bbrel$CapReason == input$CapReason_a}
     if(input$FinAction_a != 'All'){rowage=rowage & bbrel$FinAction == input$FinAction_a}
      
     bbrel[rowage,-1] 
   })
  
  #####tab 1: Map & datatable#####
  output$callmap = renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldImagery,
                       group = "Esri World Imagery",
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addProviderTiles(providers$OpenStreetMap.Mapnik,
                       group = "Open Street Map",
                       options = providerTileOptions(noWrap = TRUE)) %>% 
      addMarkers(data = updatecall(),
                 popup = ~paste('IncidentID','CallNature'),
                 icon = ~bearicon,
                 clusterOptions = markerClusterOptions()) %>%
      addControl(html=bearurl,position = 'topright') %>%
      addFullscreenControl() %>%
      addLayersControl(
        baseGroups = c("Esri World Imagery","Open Street Map"),
        position = c("topleft"),
        options = layersControlOptions(collapsed = TRUE)
      )
  }) 
  output$calldata = DT::renderDataTable(updatecall(), filter = "top",options = list(pageLength =10)) # call table
  

  
  #####tab 2: release plot#####
  output$relbear = renderPlot(
      ggplot(updaterel(),aes_string(x=input$xaxis, fill=input$fillbar)) +
        geom_bar(position = "stack")+
        scale_fill_ucscgb(palette = 'default',alpha=0.7)+
        theme_bw()+
        theme(panel.background = element_rect(fill = input$bgcolor,
                                            colour = input$gridcolor,
                                            size = 0.5, 
                                            linetype = "solid")
            )
      )
   output$reldata =  DT::renderDataTable(updaterel(),filter = "top",options = list(pageLength =10))
   
   
  
   #####tab 3: sex plot & age plot#####
   output$number_of_bear_sex = renderPlot(
     
     ggplot(plotsex(),aes_string(x='Year',fill = 'Sex'))+
       geom_bar(size=0.7,width=.75) +
       scale_x_continuous(limits=c(1980, 2020), breaks=seq(1980,2020,2))+
       scale_y_continuous(name="Number of Bears")+
       guides(fill=guide_legend(title = 'Sex'))+
       theme_bw()+
       theme(axis.text.x = element_text(angle = -45),
             plot.title = element_text(hjust = 0.5),
             )+
       scale_fill_startrek(palette = 'uniform' ,alpha=0.7)
   )
   
   output$number_of_bear_age = renderPlot(
     
     ggplot(plotage(),aes_string(x='Year',fill='AgeClass'))+
       geom_bar(size=0.7,width=.75) +
       scale_x_continuous(limits=c(1980, 2020), breaks=seq(1980,2020,2))+
       scale_y_continuous(name="Number of Bears")+
       guides(fill=guide_legend(title = 'Age'))+
       theme_bw()+
       theme(
             axis.text.x = element_text(angle = -45),
             plot.title = element_text(hjust = 0.5),
       )+
       scale_fill_uchicago(palette = 'default' ,alpha=0.7)
   )
}

######shiny######
shinyApp(ui,server)
