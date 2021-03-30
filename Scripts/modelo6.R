#MODELO DE PROYECCION (ARCH)
#LIBRERIAS
library(openxlsx)
library(dplyr)
library(forecast) #Proyecciones
library(urca) #Contrastes
library(ggplot2)#Graficos
library(highcharter) 
#install.packages("rugarch")
library(rugarch)#Garch Model
library(rmgarch)#Garch Model
library(aTSA)
library(FinTS)# Arch Test
library(parallel)
library(quantmod)
library(dynlm) #Uso de retornos en el modelo
library(pdfetch)
library(BatchGetSymbols) 
library(tseries)
##########################################################################################
#DATA
##########################################################################################
# Definimos las variables necesarias.  
#acciones <- c('MSFT', 'AAPL', 'TSLA', 'GPRO')  # Vector con las acciones que se quiere descargar 
data <-  pdfetch_YAHOO(fields = "close", c("TSLA"))
plot(data)

rend= ts(log(data),
              start=c(2010,29),
              frequency = 365)

plot.ts(rend)
title("TS de TSLA precios de cierre bursatil")
hchart(log(data))%>% hc_add_theme(hc_theme_sandsignika())
##########################################################################################
#EVALUACIÓN DE ESTACIONALIDAD
##########################################################################################
#Contraste de Raiz Unitaria Estacional
nsdiffs(rend)
####################################################################################################################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(rend,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.
##########################################################################################
ndiffs(rend,
       test = 'pp')
##########################################################################################
#DIFERENCIA
##########################################################################################
drend=diff(rend,1)
plot(drend)
title("Rendimiento de TSLA: Primera Diferencia")
ggtsdisplay(drend,main="Diferencia Típica",lag.max = 20)
##########################################################################################
#PROCESOS ARIMA
##########################################################################################
ggtsdisplay(rend,main="Serie Original",lag.max = 20)

modelo = auto.arima(rend)
summary(modelo)

modelo1 = arima(drend,
                order = c(p=0,d=0,q=6),
                fixed = c(0,0,0,0,0,NA,NA))
summary(modelo1)
##########################################################################################
#RESIDUOS
##########################################################################################
checkresiduals(modelo1)
#Contrastes de Autocorrelacion
#---------------------------------------#
Box.test(modelo1$residuals,
         lag=1,
         type='Ljung-Box')
#Se tiene evidencia estadistica de que los residuos son independientes
#---------------------------------------#
res = modelo1$residuals
#---------------------------------------#
ggtsdisplay(res,main="Residuos", lag.max = 20)
#Los correlogramas de los residuales no indican ningún patrón discernible al no
#existir rezagos significativos, por lo que podríamos considerar que el proceso que
#siguen es estacionario. Sin embargo, la gráfica de residuales muestra procesos de
#volatilidad que deben ser examinados.
#---------------------------------------#
#Para ello examinamos los residuales elevados al cuadrado con el fin de examinar
#su varianza:
res.cuad=res^2
#---------------------------------------#
ggtsdisplay(res.cuad,main="Residuos Cuadrados-Volatilidad",lag.max = 20)
##########################################################################################
#PROCESOS ARCH
##########################################################################################
#1. Estimar el Modelo
#2. Calular los residuales alcuadrado
#3. Hacer una regresión de los residuales al cuadrado rezagados
#---------------------------------------#
rend.arch <-dynlm(res.cuad~L(res.cuad),
                 data = rend)
summary(rend.arch)
#---------------------------------------#
#4. Contraste de Volatilidad
#Ho: No hay Eefectos ARCH=  Los residuales al cuadrado del ARIMA son homocedasticos
#H1: Existe efectos ARCH=   Los residuales al cuadrado del ARIMA son heterocedasticos
#Si valor_p < 0.05 se rechaza Ho. Es decir, hay evidencia de que existe heterocedasticidad
#---------------------------------------#
ArchTest(modelo1$residuals,lags = 1, demean = T)
#---------------------------------------#
# El modelo escogido ARCH(1)
#Primer Componente es el efecto garch y el segundo es el efecto arch
m.arch <-garch(modelo1$residuals,
               order=c(0,1),
               control = garch.control(maxiter = 500,
                                       grad = "numerical")) 
summary(m.arch)
#---------------------------------------#
arch<-ugarchspec(variance.model=list(model='sGARCH',
                                    garchOrder=c(1,0)),
                   mean.model=list(armaOrder=c(0,6),
                                   include.mean = FALSE, arfima = F),
                   distribution.model = "std")


fit1=ugarchfit(arch, data = drend ,out.sample=20)
forc=ugarchforecast(fit1, n.ahead=20)
plot(forc)
##########################################################################################
#PROCESOS GARCH
##########################################################################################
spec = ugarchspec()
fit = ugarchfit(data= drend, spec = spec)
fit

#De los resultados se obtiene que los residuales no presentan autocorrelación
#serial y tampoco hay proceso ARCH en los residuales elevados al cuadrado, por lo
#que se puede plantear que la modelación fue adecuada.

fit = ugarchfit(data = data, 
                spec = spec,
                out.sample=12) 
plot(fit)

forc=ugarchforecast(fit, n.ahead=12)
plot(forc)

