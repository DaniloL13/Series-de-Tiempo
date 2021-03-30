# Análisis de Series Temporales con R

Table of Contents
=================

* [Introducción](#introducción)
* [Análisis de series temporales univariantes](#análisis-de-series-temporales-univariantes)
* [Enfoques](#enfoques)
* [Enfoque clásico (descomposición)](#enfoque-clásico)
* [Enfoque de los Alisados o Suavizados](#enfoque-de-los-alisados-o-suavizados)
* [ARIMA](#arima-(autoregresive-integrated-moving-average))
* [SARIMA](#sarima-(seasonal-autoregresive-integrated-moving-average))
* [Enfoque Box-Jenkins](#enfoque-box-jenkins-1)

* [Manejo de datos perdidos en series temporales](#manejo-de-datos-perdidos-en-series-temporales)
* [Series temporales con R](#series-temporales-con-r)
* [Series temporales con alisados, arima, etc. con R](#series-temporales-con-alisados-arima-etc-con-r)
* [Paquetes R para el análisis y tratamiento de Series Temporales:](#paquetes-r-para-el-análisis-y-tratamiento-de-series-temporales)
* [Análisis gráfico de series temporales](#análisis-gráfico-de-series-temporales)

* [Bibliografía](#bibliografía)

## Introducción

Una serie temporal se define como una colección de datos sucesivos que se recopilan, observan o registran cronológicamente en intervalos de tiempo regulares (diario, semanal, semestral, anual, entre otros).

![image](https://user-images.githubusercontent.com/51028737/113069131-e4786600-917c-11eb-99a7-843da08390d5.png)

Las series temporales son un caso particular de los procesos estocásticos, ya que un proceso estocástico es una secuencia de variables aleatorias, ordenadas y equidistantes cronológicamente referidas a una característica observable en diferentes momentos.

Algunos ejemplos de series temporales vienen de campos como la economía (producto interior bruto anual, tasa de inflación, tasa de desempleo, ...),  la demografía (nacimientos anuales, tasa de dependencia, ...), la meteorología (temperaturas máximas, medias o mínimas, precipitaciones diarias, ...), etc.

![STexample](https://datascienceplus.com/wp-content/uploads/2015/08/gtemp-490x301.png)

El objetivo de una serie temporal reside en estudiar los cambios en esa variable con respeto al tiempo (descripción), y en predecir sus valores futuros (predicción). Por lo tanto, el análisis de series temporales presenta un conjunto de técnicas estadísticas que permiten extraer las regularidades que se observan en el comportamiento pasado de la variable, para tratar de predecir el comportamiento futuro.

Una serie temporal se representa mediante un gráfico temporal, con el valor de la serie en el eje de ordenadas y los tiempos en el eje de abscisas. Esta es la forma más sencilla de comenzar el análisis de una serie temporal y permite detectar las características y componentes más importantes de una serie. 
