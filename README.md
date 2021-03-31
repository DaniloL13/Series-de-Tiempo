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

Una serie temporal se define como una colección de datos sucesivos que se recopilan, observan o registran cronológicamente en intervalos de tiempo regulares (diario, semanal, semestral, anual, entre otros).Una serie temporal se representa mediante un gráfico temporal, con el valor de la serie en el eje de ordenadas y los tiempos en el eje de abscisas como se muestra a continuación.

![image](https://user-images.githubusercontent.com/51028737/113069131-e4786600-917c-11eb-99a7-843da08390d5.png)

Las series temporales son un caso particular de los procesos estocásticos, ya que un proceso estocástico es una secuencia de variables aleatorias, ordenadas y equidistantes cronológicamente referidas a una característica observable en diferentes momentos.

Algunos ejemplos de series temporales vienen de campos como la economía (producto interior bruto anual, tasa de inflación, tasa de desempleo, ...),  la demografía (nacimientos anuales, tasa de dependencia, ...), la meteorología (temperaturas máximas, medias o mínimas, precipitaciones diarias, ...), etc.

El objetivo central de una serie temporal reside en estudiar los cambios en esa variable con respeto al tiempo. De manera que, se pueda predecir sus valores futuros (predicción o proyecciones). Por lo tanto, el análisis de series temporales presenta un conjunto de técnicas estadísticas que permiten construir el comportamiento pasado de la variable, para tratar de predecir el comportamiento futuro para la toma de decisiones.

**Componentes de una serie temporal**

Los componentes que forman una serie temporal son los siguientes:

- Tendencia: Se puede definir como un cambio a largo plazo que se produce en relación al nivel medio, o el cambio a largo plazo de la media. La tendencia se identifica con un movimiento suave de la serie a largo plazo.

![image](https://user-images.githubusercontent.com/51028737/113071715-90708000-9182-11eb-83d1-aca5b977a295.png)

- Estacionalidad: Se la  identifica como un movimiento suave de la serie a largo plazo, es decir, es el comportamiento recursivo o patrón  que responde a las mismas fechas en el tiempo, durante  algunos periodos.

![image](https://user-images.githubusercontent.com/51028737/113071742-9e260580-9182-11eb-8d18-1256b2c4610a.png)


- Ciclo: Es la fluctuación en forma de onda alrededor de la tendencia.Se caracteriza porque su duración es irregular.

![image](https://user-images.githubusercontent.com/51028737/113071770-aed67b80-9182-11eb-868c-ceff1b3ba2c0.png)


- Irregular: Esta componente no responde a ningún patrón o comportamiento sistemático sino que es el resultado de cuestiones  fortuitas implícitas de la serie.

![image](https://user-images.githubusercontent.com/51028737/113071115-55218180-9181-11eb-80b2-a56f7f33a414.png)


### Procesos Estocásticos

Un proceso estocástico \((𝒙_𝒕)\) es una sucesión de variables  aleatorias ordenadas en el tiempo (en el caso de series temporales). Por lo que, las series temporales se definen como un caso particular de los procesos estocásticos.

Lo ideal es tener una serie de tiempo con media y varianza (más o menos) constante.

**Tipos de series temporales**

Las series temporales se pueden dividir en:

- Estacionarias: es aquella en la que las propiedades estadísticas de la serie son estables, no varían con el tiempo, más en concreto su media, varianza y covarianza se mantienen constantes a lo lardo del tiempo. Si una serie temporal tiene una media constante a lo largo del tiempo, decimos que es estacionaria con respecto a la media. Si tiene varianza constante con respecto al tiempo, decimos que es estacionaria en varianza.

- No estacionarias: son aquellas en las que las propiedades estadísticas de la serie sí varían con el tiempo. Estas series pueden mostrar cambio de varianza, tendencia o efectos estacionales a lo largo del tiempo. Una serie es no estacionaria en media cuando muestra una tendencia, y una serie es no estacionaria en varianza cuando la variabilidad de los datos es diferente a lo largo de la serie.

La importancia de esta división reside en que la estacionaridad (en media y en varianza) es un requisito que debe cumplirse para poder aplicar modelos paramétricos de análisis y predicción de series de datos. Ya que con series estacionarias podemos obtener predicciones fácilmente, debido a que como la media es constante se puede estimar con todos los datos y utilizar este valor para predecir una nueva observación. Y también permite obtener intervalos de confianza para las predicciones. 

### Procesos Estocásticos Estacionarios

Un proceso estocástico \((𝒙_𝒕)\) es estacionario en sentido débil cuando su distribución de probabilidad varía de forma más o menos constante a lo largo de cierto periodo de tiempo.

Un tipo especial de serie estacionaria es la serie denominada **ruido blanco**. Un ruido blanco es una serie estacionaria tal que ninguna observación influye sobre las siguientes, es decir, donde los valores son independientes e idénticamente distribuidos a lo largo del tiempo con media y covarianza cero e igual varianza.

![image](https://user-images.githubusercontent.com/51028737/113071563-3ff92280-9182-11eb-8e04-ef9191c282df.png)

Otro tipo especial de serie temporal es la llamada **camino aleatorio**, una serie es un camino aleatorio si la primera diferenciación de la serie es un ruido blanco.

Las series temporales también se pueden dividir según cuántas variables se observan o según su variabilidad:

- Univariante: la serie temporal es un conjunto de observaciones sobre una única caracteristica o variable.
- Multivariante: (o vectorial): la serie temporal es un conjunto de observaciones de varias variables. <br>
<br>
- Homocedástica: una serie es homocedástica si su variabilidad se mantiene constante a lo largo de la serie.
- Heterocedástica: una serie es heterocedástica cuando la variabilidad de la serie aumenta o disminuye a lo largo del tiempo.

Por otro lado, la variable que se observa en una serie temporal puede ser de tipo:

- Flujo: variable cuya cantidad es acumulada a lo largo del tiempo, por ejemplo: inversión, ahorro, etc.
- Stock: variable cuya cantidad se mide en un determinado momento del tiempo, por ejemplo: población, nº parados, etc.


