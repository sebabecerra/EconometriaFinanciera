* ETH-USD
clear all
set mem 400m
insheet using "C:\Users\Rodrigo\Dropbox\Profesor cursos\UAI\Econometría Financiera\Clases Rodrigo\Clase 5\STATA/BTC-USD.csv"
cd "C:\Users\Rodrigo\Dropbox\Profesor cursos\UAI\Econometría Financiera\Clases Rodrigo\Clase 5\STATA\imagenes"
*************************************************************************
rename date date2
rename close precio_BTC_USD
****************************************************************
set obs 2865
generate date = td(17Sep2014) + _n-1
tsset  date, daily
****************************************************************
* 1 rezago
gen Lprecio_BTC_USD=L.precio_BTC_USD
sum precio_BTC_USD
* logaritmo
gen lprecio_BTC_USD=ln(precio_BTC_USD)
* Primera diferencia del logaritmo
gen Dlnprecio_BTC_USD=D.precio_BTC_USD
tsline precio_BTC_USD, name(serie) title(17Sep2014 al 21jul2022 - BTC-USD diario)
graph export BTC-USD.tif, replace
tsline Dlnprecio_BTC_USD, name(lnserie) title(17Sep2014 al 21jul2022 - BTC-USD diario)
graph export dlnBTC-USD.tif, replace

* Autocorrelación y autocorrelación parcial
ac precio_BTC_USD
pac precio_BTC_USD

ac lprecio_BTC_USD
pac lprecio_BTC_USD

****************************************************************
*  Modelo AR(1)
arima lprecio_BTC_USD, arima(1,0,0)
predict lprecio_BTC_USD_p, y
tsline lprecio_BTC_USD lprecio_BTC_USD_p, name(prediccion_1)

est store AIC1
estimates stats AIC1

predict e1, residuals
gen absserr_1=abs(e1)
summ absserr_1

tsline e1, name(Error_1)
graph combine prediccion_1 Error_1, col(1) iscale(0.6) ysize(6.5) xsize(8.5) title(2009-2015 - ALL - Prediction & Error AR(1))

* Modelo AR(2)
arima lprecio_BTC_USD, arima(2,0,0)
est store AIC2
estimates stats AIC2

predict e2, residuals
gen absserr_2=abs(e2)
summ absserr_2

arima lprecio_BTC_USD, arima(0,0,1)
est store AIC3
predict e3, residuals
gen absserr_3=abs(e3)
summ absserr_3

arima lprecio_BTC_USD, arima(0,0,2)
est store AIC4
predict e4, residuals
gen absserr_4=abs(e4)
summ absserr_4

arima lprecio_BTC_USD, arima(1,0,1) noconstant 
est store AIC5
predict e5, residuals
gen absserr_5=abs(e5)
summ absserr_5

arima lprecio_BTC_USD, arima(2,0,1) 
est store AIC6
predict e6, residuals
gen absserr_6=abs(e6)
summ absserr_6

arima lprecio_BTC_USD, arima(2,0,2) noconstant 
est store AIC7
predict e7, residuals
gen absserr_7=abs(e7)
summ absserr_7

estimates stats AIC1 AIC2 AIC3 AIC4 AIC5 AIC6 AIC7
