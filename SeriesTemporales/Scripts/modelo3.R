#MODELO DE PROYECCION3

#LIBRERIAS
library(forecast) #Proyecciones
library(dygraphs) #Graficos
library(highcharter) #Graficos
library(urca) #Contrastes
##########################################################################################
#DATA
##########################################################################################
data = read.table(file = "Bases/PIB.txt")
tsdata = ts(as.vector(as.matrix(data)),
             start=c(2006,1),
             frequency = 4)


data2 = read.table(file = "Bases/Ventas.txt")
tsdata2 = ts(as.vector(as.matrix(log(data2/1000))),
             start=c(2010,1),
             frequency = 12)
##########################################################################################
#Modelo Automatico
##########################################################################################
modeloa1=auto.arima(tsdata)
summary(modeloa1)
proya1= forecast(modeloa1,
                   h=4,
                   level = 95)
hchart(proya1)

modeloa2= auto.arima(tsdata2)
summary(modeloa2)

proya2<-  forecast(modeloa2,
                   h=12,
                   level = 95)
hchart(proya2)
