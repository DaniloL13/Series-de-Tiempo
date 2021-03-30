#MODELO DE PROYECCION2

#LIBRERIAS
library(forecast) #Proyecciones
library(dygraphs) #Graficos
library(highcharter) #Graficos
library(urca) #Contrastes
##########################################################################################
#DATA
##########################################################################################
data2 = read.table(file = "Bases/Ventas.txt")

tsdata2 = ts(as.vector(as.matrix(data2/1000)),
             start=c(2010,1),
             frequency = 12)

#GRAFICAR
hchart(tsdata2)
##########################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#Ho: Raiz Unitaria = No estacionaria
#Ha: No raiz unitaria = Estacionaria

#Si el valor calculado en valor absoluto es mayor que el valor critico se rechaza Ho
#Se tiene evidencia estadistica de que  no existe raiz unitaria
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(tsdata2,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.
##########################################################################################
#DIFERENCIAR
##########################################################################################
ndiffs(tsdata2,
       test = 'adf')

ndiffs(tsdata2,
       test = 'pp')

dtsdata2=diff(tsdata2,1)
hchart(dtsdata2)
##########################################################################################
#PROCESOS (ARMA) (ARIMA)
##########################################################################################
Acf(dtsdata2)
Pacf(dtsdata2)

modelo1 = Arima(tsdata2,
                order = c(p=6,d=1,q=6),
                fixed=c(0,0,NA,0,0,NA,
                        0,0,NA,0,0,NA))
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
0.3465/0.4999 #El coeficiente es 0
0.2968/0.5198 
0.2011/0.5093
0.0111/0.4852
modelo2= Arima(tsdata2,
               order = c(p=6,d=1,q=6),
               fixed=c(0,0,0,0,0,NA,
                       0,0,0,0,0,NA))
summary(modelo2)

modelo3= Arima(tsdata2,
               order = c(p=3,d=1,q=3),
               fixed=c(0,0,NA,
                       0,0,NA))
summary(modelo3)
#--------------------Evaluar La capacidad--------------------#
#Medidas de precisión para un modelo de pronóstico
accuracy(modelo3)
#--------------------Evaluar Residuos(AUTOCORRELACION)--------------------#
plot(modelo3$residuals)
abline(h=0)
#---------------------------------------#
Acf(modelo3$residuals)
Pacf(modelo3$residuals)
#---------------------------------------#
#Contrastes de Autocorrelacion
#Ho: Residuos Independientes 
#Ha: Residuos Dependientes

#Si el valor p es Menor a 0.05 se rechaza Ho
#Se tiene evidencia estadistica de que los residuos son dependientes
#---------------------------------------#
Box.test(modelo3$residuals,
         lag=1,
         type='Ljung-Box')
##########################################################################################
#PROYECCION
##########################################################################################
proy2<-  forecast(modelo3,
                 h=12,
                 level = 95)
hchart(proy2)

ts.plot(tsdata2,
        proy2$fitted,
        proy2$mean,
        col=c('black','red','blue'))
