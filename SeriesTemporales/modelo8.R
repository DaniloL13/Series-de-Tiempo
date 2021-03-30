#MODELO DE PROYECCION PARA MULTIPLES SERIES TEMPORALES
#LIBRERIAS
library(openxlsx)
library(dplyr)
library(forecast) #Proyecciones
library(urca) #Contrastes
library(ggplot2)#Graficos
#install.packages("feasts")
library(feasts)  # trabaja con tsibble
library(tsibble) # crear series de tiempo tsibble
library(fable) # modelar series de tiempo tsibble
library(tsibbledata) 
library(reshape2)
##########################################################################################
#DATA
##########################################################################################
data <- read.xlsx("Bases/recaudación.xlsx",detectDates = T)

data <- data %>% mutate(fecha=tsibble::yearmonth(fecha)) %>%  
  select(c(fecha,depositos,export,import))

#----------DATA POR VARIABLE EN FORMATO TIBBLE
datos=melt(data,"fecha")

datos=as_tsibble(datos,
                index="fecha",
                key="variable")
#----------GRÁFICO
autoplot(datos)+ 
  xlab("Periodo")+
  ylab("Valores")+
  ggtitle("Multiples Series Temporales")+
  theme(legend.position = "bottom")

#----------DESCOMPOSICIÓN
datos %>%  model(STL(value ~ season(window="periodic"))) %>%  
  components() %>% autoplot()+theme(legend.position = "bottom")
##########################################################################################
#EVALUACIÓN DE ESTACIONALIDAD
##########################################################################################
#Contraste de Raiz Unitaria Estacional
ggsubseriesplot(ts(data$depositos,
                start=c(2009,1),
                frequency=12))

gg_subseries(datos)

gg_season(datos)
##########################################################################################
#EVALUACIÓN DE ESTACIONARIEDAD
##########################################################################################
#Contrastes de Raiz Unitaria Ordinal
#----------Phillips-Perron Unit Root Test
pptest = ur.pp(data$export,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, la series no es estacionaria
##########################################################################################
ndiffs(data$export,
       test = 'pp')
##########################################################################################
#MODELOS
##########################################################################################
datos %>% ACF(value) %>% autoplot()
datos %>% PACF(value) %>% autoplot()

#-------------Modelo Automatico 
if (requireNamespace("fable", quietly = TRUE) && requireNamespace("tsibbledata", quietly = TRUE)){
  library(fable)
  library(tsibbledata)}

modelo <- datos %>%  model(auto.ets= ETS(value))
report(modelo)

#-------------Modelo ETS(M, Ad, A)
modelo1 <- datos %>%  model(auto.ets= ETS(value ~ error("M") + trend("Ad") + season("A")))
report(modelo1)
##########################################################################################
#PROYECCIÓN
##########################################################################################
proy <- modelo %>% forecast(h=12)
proy %>% autoplot(datos)

#---------------------- Multiples Modelos
#Modelo ARIMA Modelo estacional NAIVE(Ingenuo) y ETS (A, A, A) 
modelo2 = datos %>% model(arima= ARIMA(value),
                          ets = ETS(value ~ error("A") + trend("A") + season("A")),
                          snavie = SNAIVE(value))
modelo2  

proy2 = modelo2 %>% forecast(h=12)

proy2 %>% autoplot(datos,level=0.95)+
  ggtitle("Predicción Multiple") +
  xlab("Year") +
  guides(colour = guide_legend(title = "Forecast"))

#Intervalo de confianza
hilo(proy2, level = 95)
#---------------Seleccion
modelo2 %>% filter(variable=="export") %>% 
  select(arima) %>% 
  report

#---------------------- Modelos Mixtos
modelo3 = datos %>% model(arima=ARIMA(value),
                          ets=ETS(value),
                          snaive=SNAIVE(value)) %>% 
  mutate(mixto=(arima+ets+snaive)/3) 

#---------------Seleccion
modelo3 %>% filter(variable=="export") %>% 
  select(mixto) %>% 
  report

proy3=modelo3 %>% forecast(h=12)
proy3 %>% autoplot(datos,level=0.95)
  

