#MODELO DE PROYECCION

#LIBRERIAS
library(forecast) #Proyecciones
library(foreign) #Bases de Datos
library(dygraphs) #Graficos
library(highcharter) #Graficos
library(urca) #Contrastes
##########################################################################################
#DATA
##########################################################################################
data = read.table(file = "Bases/PIB.txt")
plot(data)

tsdata <- ts(as.vector(as.matrix(data)),
             start=c(2006,1),
             frequency = 4)

#GRAFICAR
dygraph(tsdata,ylab = 'Consumo', xlab = 'Time')
plot(tsdata)
hchart(tsdata)
##########################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#Ho: Raiz Unitaria = No estacionaria
#Ha: No raiz unitaria = Estacionaria

#Si el valor calculado en valor absoluto es mayor que el valor critico se rechaza Ho
#Se tiene evidencia estadistica de que  no existe raiz unitaria
#---------------------------------------#
#----------Contraste de Dickey Fuller
adftest = ur.df(tsdata, 
                type = c("trend"),
                selectlags = c("AIC"))
summary(adftest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(tsdata,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.
##########################################################################################
#DIFERENCIAR
##########################################################################################
ndiffs(tsdata,
       test = 'adf')

ndiffs(tsdata,
       test = 'pp')

dtsdata=diff(tsdata,1)
hchart(dtsdata)
plot(dtsdata)
##########################################################################################
#PROCESOS (ARMA) (ARIMA)
##########################################################################################
acf(dtsdata)
pacf(dtsdata)

modelo1 = Arima(tsdata,
                order = c(p=1,d=1,q=1))
summary(modelo1)
##########################################################################################
#EVALUAR EL MODELO
##########################################################################################
#Contrastes de Coeficientes
#Ho: Coeficiente = 0
#Ha: Coeficiente =! 0

#Si el valor (c/e) calculado es mayor a 2 se rechaza Ho
#Se tiene evidencia estadistica de que  el coeficiente es diferente de cero 
#---------------------------------------#
0.3379/0.1964 #El coeficiente es 0
0.8892/0.0881 #El coeficiente es diferente de 0

modelo2= Arima(tsdata,
               order = c(p=1,d=1,q=0))
summary(modelo2)

0.7412/0.0919 #El coeficiente es diferente de 0

#--------------------Evaluar La capacidad--------------------#
#Medidas de precisión para un modelo de pronóstico
accuracy(modelo2)
#--------------------Evaluar Residuos(AUTOCORRELACION)--------------------#
plot(modelo2$residuals)
abline(h=0)
#---------------------------------------#
acf(modelo2$residuals)
pacf(modelo2$residuals)
#---------------------------------------#
#Contrastes de Autocorrelacion
#Ho: Residuos Independientes 
#Ha: Residuos Dependientes

#Si el valor p es Menor a 0.05 se rechaza Ho
#Se tiene evidencia estadistica de que los residuos son dependientes
#---------------------------------------#
Box.test(modelo2$residuals,
         lag=2,
         type='Ljung-Box')

#Se rechaza Ho
#Se considera que la autocerralcion no es tan importante.
##########################################################################################
#PROYECCION
##########################################################################################
proy<-  forecast(modelo2,
                h=8,
                level = 95)
hchart(proy)

ts.plot(tsdata,
        proy$fitted,
        col='blue','black')
