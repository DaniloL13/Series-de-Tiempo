#MODELO DE PROYECCION (SARIMA)
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

nsdiffs(log(ingresos),
        test = 'ch')
##########################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#Ho: Raiz Unitaria = No estacionaria
#Ha: No raiz unitaria = Estacionaria

#Si el valor calculado en valor absoluto es mayor que el valor critico se rechaza Ho
#Se tiene evidencia estadistica de que  no existe raiz unitaria
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(log(ingresos),
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.
##########################################################################################
#DIFERENCIAR
##########################################################################################
ndiffs(log(ingresos),
       test = 'pp')
##########################################################################################
#PROCESOS SARIMA
##########################################################################################
Acf(log(ingresos))
Pacf(log(ingresos))

modelo1 = arima(log(ingresos),
                order = c(p=1,d=0,q=1),
                seasonal = list(order=c(P=1,D=0,Q=1)))
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
#--------------------Evaluar La capacidad--------------------#
#Medidas de precisión para un modelo de pronóstico
accuracy(modelo1)
#--------------------Evaluar Residuos(AUTOCORRELACION)--------------------#
plot(modelo1$residuals)
abline(h=0)
#---------------------------------------#
Acf(modelo1$residuals)
Pacf(modelo1$residuals)
#---------------------------------------#
#Contrastes de Autocorrelacion
#Ho: Residuos Independientes 
#Ha: Residuos Dependientes

#Si el valor p es Menor a 0.05 se rechaza Ho
#Se tiene evidencia estadistica de que los residuos son dependientes
#---------------------------------------#
Box.test(modelo1$residuals,
         lag=1,
         type='Ljung-Box')
##########################################################################################
#PROYECCION
##########################################################################################
pred =  forecast(modelo1,
                  h=36,
                  level = 95)
hchart(pred)

ts.plot(ingresos,
        exp(pred$fitted),
        exp(pred$mean),
        col=c('black','red','blue'))
