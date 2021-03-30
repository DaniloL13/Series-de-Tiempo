#MODELO DE PROYECCION (HOLTWINTERS)
#LIBRERIAS
library(forecast) #Proyecciones
library(dygraphs) #Graficos
library(highcharter) #Graficos
library(urca) #Contrastes
library(openxlsx)
library(dplyr)
##########################################################################################
#DATA
##########################################################################################
data = read.xlsx("Bases/inventario.xlsx",detectDates = T)

ingresos = ts(as.vector(as.matrix(data[,2]/1000)),
              start=c(2012,1),
              frequency = 12)

hchart(ingresos)%>% hc_add_theme(hc_theme_sandsignika())
##########################################################################################
#EVALUACIÓN DE ESTACIONALIDAD
##########################################################################################
#Contraste de Raiz Unitaria Estacional
monthplot(log(ingresos))

ggseasonplot(log(ingresos),polar = TRUE,main='Análisis de Estacionalidad')

ggseasonplot(log(ingresos),year.labels = TRUE,year.labels.left = TRUE)
##########################################################################################
#PROCESOS HOLTWINTER
##########################################################################################
ggtsdisplay(log(ingresos),main="Serie Original")

holtw = HoltWinters(log(ingresos),
                seasonal = "multiplicative")
holtw
##########################################################################################
#PROYECCION
##########################################################################################
pred =  forecast(holtw,h=24)

ts.plot(ingresos,
        exp(pred$fitted),
        exp(pred$mean),
        col=c('black','red','blue'))

#nivel
#tendencial
#estacional
holtw2 = HoltWinters(log(ingresos),
                     seasonal = "multiplicative",
                     alpha = 0.2,
                     beta=0,
                     gamma = 0.9)
holtw2
pred2 =  forecast(holtw2,
                 h=24)

ts.plot(ingresos,
        exp(pred2$fitted),
        exp(pred2$mean),
        col=c('black','red','blue'))
