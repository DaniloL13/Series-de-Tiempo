#FUNCIONES DE AUTOCORRELACION

#-------------------ST1
st1 = arima.sim(list(order=c(1,0,0),
                ar=0.7),
                n=100)
plot(st1)
par(mfrow=c(1,2))
#Autocorrelacion simple
acf(st1)
#Autocorrelacion Parcial
pacf(st1)
#Tendencia que tiene ACFP hacia 0

#-------------------ST2
st2 = arima.sim(list(order=c(1,0,0),
                       ar=0.99),
                  n=100)
plot(st2)
par(mfrow=c(1,2))
#Autocorrelacion simple
acf(st2,xlim=c(1,15))
#Autocorrelacion Parcial
pacf(st2,xlim=c(1,15))
#Tendencia que tiene ACFP hacia 0

#-------------------ST3
st3 = arima.sim(list(order=c(0,0,1),
                     ma=1.2),
                n=100)
plot(st3)
par(mfrow=c(1,2))
#Autocorrelacion simple
acf(st3,xlim=c(1,20))
#Autocorrelacion Parcial
pacf(st3,xlim=c(1,20))
#Tendencia que tiene ACF hacia 0

#-------------------ST4
st4 = arima.sim(list(order=c(0,0,1),
                     ma=-5.2),
                n=100)
plot(st4)
par(mfrow=c(1,2))
#Autocorrelacion simple
acf(st4,xlim=c(0,20))
#Autocorrelacion Parcial
pacf(st4,xlim=c(0,20))
#Tendencia que tiene ACF hacia 0
