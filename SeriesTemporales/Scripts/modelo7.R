#MODELO DE PROYECCION (GARCH)
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
library(tseries)
##########################################################################################
#DATA Estudio del Rendimiento de las Series FInancieras
startDate=as.Date("2010-01-01")
endDate=as.Date("2020-12-31")

getSymbols("IBM", from=startDate, to=endDate)
rendIBM=dailyReturn(IBM)
plot(rendIBM)
##########################################################################################
data <- read.xlsx("Bases/ipcRen.xlsx")

ipc = ts(as.vector(as.matrix(data$IPCREND)),
          start=c(2005,1),
          frequency = 12)
plot.ts(ipc)
title("IPC Rendimiento")
hchart(ipc)%>% hc_add_theme(hc_theme_sandsignika())
##########################################################################################
#EVALUACIÓN DE ESTACIONALIDAD
##########################################################################################
#Contraste de Raiz Unitaria Estacional
monthplot(ipc)

ggseasonplot(ipc,polar = TRUE,main='Análisis de Estacionalidad')

ggseasonplot(ipc,year.labels = TRUE,year.labels.left = TRUE)+ylab("ipc")+ggtitle("IPC 2015-2020")+xlab("Meses")

nsdiffs(ipc,
        test = 'ch')
##########################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(ipc,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, la series es estacionaria
##########################################################################################
ndiffs(ipc,
       test = 'pp')
##########################################################################################
#PROCESOS ARMA
##########################################################################################
ggtsdisplay(ipc,main="Serie de Rendimientos")

modelo = auto.arima(ipc)
summary(modelo)

modelo1 = arima(ipc,
                order = c(p=2,d=0,q=2))
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
hchart(res)%>% hc_add_theme(hc_theme_sandsignika())
#---------------------------------------#
ggtsdisplay(res,main="Residuos del Modelo")
#Los correlogramas de los residuales no indican ningún patrón discernible al no
#existir rezagos significativos, por lo que podríamos considerar que el proceso que
#siguen es estacionario. Sin embargo, la gráfica de residuales muestra procesos de
#volatilidad que deben ser examinados.
#---------------------------------------#
#Para ello examinamos los residuales elevados al cuadrado con el fin de examinar
#su varianza:
res.cuad=res^2
hchart(res.cuad)%>% hc_add_theme(hc_theme_sandsignika())
#---------------------------------------#
ggtsdisplay(res.cuad,main="Residuos Cuadrados-Volatilidad")
#Se obvserva tambien que no se comporta como Ruido Blanco
##########################################################################################
#PROCESOS GARCH
##########################################################################################
#1. Estimar el Modelo ARMA
#2. Calular los residuales al cuadrado
#3. Hacer una regresión de los residuales al cuadrado rezagados
#---------------------------------------#
rend.arch <-dynlm(res.cuad~L(res.cuad),
                  data = res)
summary(rend.arch)
#---------------------------------------#
#4. Contraste de Volatilidad
#Ho: No hay Eefectos ARCH=  Los residuales al cuadrado del ARIMA son homocedasticos
#H1: Existe efectos ARCH=   Los residuales al cuadrado del ARIMA son heterocedasticos
#Si valor_p < 0.05 se rechaza Ho. Es decir, hay evidencia de que existe heterocedasticidad
#---------------------------------------#
ArchTest(ipc,lags = 2, demean = T)
#hay evidencia de que existe heterocedasticidad
#---------------------------------------#
arch<-ugarchspec(variance.model=list(model='sGARCH',
                                     garchOrder=c(2,0)),
                 mean.model=list(armaOrder=c(2,2),
                                 include.mean = FALSE, 
                                 arfima = F),
                 distribution.model = "std")

fit.arch=ugarchfit(arch, ipc ,out.sample=12)
plot(fit.arch)
forc.arch=ugarchforecast(fit.arch, n.ahead=12)
plot(forc.arch)
##########################################################################################
#PROCESOS GARCH(1,1)
##########################################################################################
#1.Especificación del modelo GARCH Univariante
#---------------------------------------#
spec = ugarchspec()
spec = ugarchspec(mean.model=list(armaOrder=c(2,2)))
#---------------------------------------#
#2.Estimar el modelo GARCH
#---------------------------------------#
fit = ugarchfit(data = ipc, spec = spec)
fit
plot(fit)
#---------------------------------------#
#Coeficientes
fit@fit$coef 
#---------------------------------------#
#Varianza
fit@fit$var
#---------------------------------------#
#Residuales
res.fit.cuad=(fit@fit$residuals)^2
plot(res.fit.cuad,
     type="l", col="blue")
lines(fit@fit$var , col="red")
#---------------------------------------#
#3.Pronostico ARMA(2,2) GARCH(1,1)
#---------------------------------------#
forc=ugarchforecast(fit, n.ahead=12)
plot(forc)
