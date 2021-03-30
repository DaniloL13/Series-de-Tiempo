#LIBRERIAS
library(openxlsx)
library(reshape2)
library(dplyr)
library(ggplot2)
library(dygraphs)
library(highcharter) 

library(plotly)
library(gganimate)
library(animation)
library(htmlwidgets)

#DATA
data <- read.xlsx("Bases/base.xlsx",
                 sheet = "Hoja1",detectDates = TRUE)

library(zoo)
class(data$PERIODO)

data2 = data %>% select(-"PERIODO") 

periodo=seq(as.Date("2010/1/1"), as.Date("2016/6/30"),"months")

data.z = zoo(x=data2,order.by = periodo)
index(data.z)
View(data.z)

dygraph(data.z)

#GRUP
datagrup <- data %>%
  select(PERIODO,EXPORTACIONES,IMPORTACIONES)

###-------------------------------
mgrup = melt(datagrup, id.vars = c("PERIODO"))
###-------------------------------
ggplot(data = mgrup,
       aes(x=PERIODO,y=value))+
  geom_line()+
  facet_wrap(variable~. ,scales = "free", ncol=2)+
  geom_ma(aes(color="MA(12)"),
          ma_fun = SMA,
          n=12,size=1,
          show.legend = TRUE)+
  scale_x_date(date_labels = "%Y %b", breaks = "3 months")+
  theme(legend.position = "right",
        axis.text.x = element_text(angle=90,
                                   hjust=1,
                                   size=7))+
  labs(title="EXPORTACIÓN E IMPORTACION DE ECUADOR",
       subtitle = "Movimientos En miles de millones",
       caption = "Fuente: BCE")
###-------------------SERIE ANIMATE------------
anim = ggplot(data = mgrup,
              aes(x=PERIODO,y=value))+
  geom_line()+
  facet_wrap(variable ~.,scales = "free",ncol=2)

anim = anim+
  geom_point()+ 
  transition_reveal(along = PERIODO)+
  labs(title = "Mes: {frame_along}")

anim
anim_save(file="Graficos/animacion.gif",animation = last_animation())

###-------------------SERIE realces------------
datagrup <- data %>%
  select(FLORES, FRUTAS,PETROLEO_CRUDO)

tsdatos <- ts(datagrup,start = c(2010,1),frequency = 12)

graficodinamico = dygraph(tsdatos,
                          main="Evolución de Ecuador",
                           xlab ="PERIODO",
                           ylab = "Millones de dolares") %>%
  dyOptions(fillGraph = T,
            fillAlpha = 0.04,
            drawPoints = T,
            pointSize = 3,
            pointShape = "star",
            gridLineColor = "blue")%>%
  dyHighlight(highlightCircleSize = 8,
              highlightSeriesBackgroundAlpha = 1,
              hideOnMouseOut = F,
              highlightSeriesOpts = list(strokeWidth = 3))%>%
  dyRangeSelector()%>%
  dyAnnotation("2012-01-01",text = "PB",tooltip = "Punto Bajo")%>%
  dyShading(from = "2012-06-01", to = "2015-06-01",color = "#99d8c9")%>%
  dyEvent("2014-01-01","puntos altos",labelLoc = "top")%>%
  dyLegend(show="follow")
graficodinamico

saveWidget(graficodinamico,
           file = "graficodinamico.html")


fig = plot_ly(x = ~data$PERIODO, y = ~data$EXPORTACIONES, mode = 'lines')
fig
