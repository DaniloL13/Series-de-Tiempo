#PRUEBAS DE ESTACIONARIEDAD
library(urca) #Contrastes

#Data
data = read.table(file = "Bases/PIB.txt")

ts.plot(data)

tsdata = ts(as.vector(as.matrix(data)),
             start=c(2000,1),
             frequency = 4)

ts.plot(diff(tsdata),1)
#---------------------------------------#
#Contrastes de Raiz Unitaria Ordinal
#Ho: Raiz Unitaria = No estacionaria
#Ha: No raiz unitaria = Estacionaria

#Si el valor calculado en valor absoluto es mayor que el valor critico se rechaza Ho
#Se tiene evidencia estadistica de que  no existe raiz unitaria
#---------------------------------------#

#----------Contraste de Dickey Fuller
adftest = ur.df(tsdata, 
                type = c("trend"),
                selectlags = c("BIC"))
summary(adftest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria.

#----------Phillips-Perron Unit Root Test
pptest = ur.pp(tsdata,
               type = c("Z-tau"),
               model = c("trend"),
               lags = c("short"))
summary(pptest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria

#Alta Potencia: quiebres estructurales
#----------Elliott, Rothenberg \& Stock Unit Root Test
erstest = ur.ers(tsdata,
                 type = "DF-GLS",
                 model = "trend",
                 lag.max = 4)
summary(erstest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria

#----------Zivot \& Andrews Unit Root Test
zatest = ur.za(tsdata, 
               model = "both", 
               lag = NULL)
summary(zatest)
#En este caso, no se rechaza la Ho, es decir, hay raiz unitaria

#-----------------------------------------#
#Contrastes de Raiz Unitaria Ordinal
#Ho: Estacionaria= No Raiz Unitaria
#Ha: No Estacionaria= Raiz Unitaria 
#----------Kwiatkowski et al. Unit Root Test
kpsstest = ur.kpss(tsdata,
                   type = "tau",
                   lags = "short")
summary(kpsstest)
#En este caso se rechaza Ho. Es decir, No es estacionaria. Es decir hay raiz unitaria.
