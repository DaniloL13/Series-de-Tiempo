#SERIES TEMPORALES

#Cargar Librerias

#install.packages("forecast")
#install.packages("foreign")
#install.packages("dygraph")
#install.packages("highcharter")
#install.packages("urca")

library(forecast) #Proyecciones
library(foreign) #Bases de Datos
library(dygraphs) #Graficos
library(highcharter) #Graficos
library(urca) #Contrastes

#Serie Temporal
plot(AirPassengers)

#Descomposición
stl(AirPassengers,
    s.window="period")

plot(stl(AirPassengers,s.window="period"))

#Proceso Estocastico
ts.plot(AirPassengers)
abline(v=1949)
abline(v=1953)
abline(v=1957)
abline(v=1961)

#No Estacionariedad
p1 = window(AirPassengers,
             start=c(1949,1),
             end=c(1952,12))

p2 = window(AirPassengers,
             start=c(1953,1),
             end=c(1956,12))
#Media
mean(p1)
mean(p2)

#Varianza
(sd(p1)^2)
(sd(p2)^2)

#Serie Estacionaria
plot(diff(AirPassengers,1))

datadiff = diff(AirPassengers,1)

p3 = window(datadiff,
            start=c(1949,2),
            end=c(1952,12))

p4 = window(datadiff,
            start=c(1953,1),
            end=c(1956,12))

#Media
mean(p3)
mean(p4)

#Varianza
(sd(p3)^2)
(sd(p4)^2)

#Ejemplo
data = read.table(file = "Bases/PIB.txt")

ts.plot(data)

tsdata <- ts(as.vector(as.matrix(data)),
             start=c(2000,1),
             end=c(2013,3),
             frequency = 4)

ts.plot(tsdata)
abline(v=2004)
abline(v=2008)
abline(v=2012)

#library(highcharter)
hchart(tsdata)


ts.plot(tsdata/1000,
        main="Producto Interno Bruto",
        sub="Fuente: BCE",
        ylab="PIB En Millones",
        xlab="Periodo en trimestres",
        col="blue")

descop = stl(tsdata,
    s.window = "period")

plot(descop)

plot(diff(tsdata,1))
