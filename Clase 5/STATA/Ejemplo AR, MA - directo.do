* BTC-USD
clear all
set mem 400m

ssc install getsymbols
help getsymbols

getsymbols BTC-USD, ya fy(2014)

cd "/Users/rodrigoortiz/Dropbox/Profesor cursos/UAI/Econometría Financiera/Clases Rodrigo/III T 2022/Clase 5/STATA/imagenes"
*************************************************************************
rename close_BTC_USD precio_BTC_USD
****************************************************************
set obs 2978
generate date = td(17Sep2014) + _n-1
tsset  date, daily
gen t=_n
****************************************************************
* 1 rezago
gen Lprecio_BTC_USD=L.precio_BTC_USD
sum precio_BTC_USD
* logaritmo
gen lprecio_BTC_USD=ln(precio_BTC_USD)
* Primera diferencia del logaritmo
gen Dlnprecio_BTC_USD=D.precio_BTC_USD
tsline precio_BTC_USD, name(serie) title(17Sep2014 al 10nov2022 - BTC-USD diario)
graph export BTC-USD.tif, replace
tsline Dlnprecio_BTC_USD, name(lnserie) title(17Sep2014 al 10nov2022 - BTC-USD diario)
graph export dlnBTC-USD.tif, replace

* Autocorrelación y autocorrelación parcial
ac precio_BTC_USD 
* Para MA
pac precio_BTC_USD
* Para AR

ac lprecio_BTC_USD
* Para MA
pac lprecio_BTC_USD
* Para AR

****************************************************************
*  Modelo AR(1)
arima lprecio_BTC_USD, arima(1,0,0)
predict lprecio_BTC_USD_p, y
tsline lprecio_BTC_USD lprecio_BTC_USD_p, name(prediccion_1)
tsline lprecio_BTC_USD lprecio_BTC_USD_p if t>2946, name(prediccion_2)

* para 30 días más
set obs `=_N+30'
replace date = td(17Sep2014) + _n-1
tsset  date, daily
bro 
replace t=_n
predict lprecio_BTC_USD_p2, y

tsline lprecio_BTC_USD lprecio_BTC_USD_p2 if t>2946, name(prediccion_3)

graph combine prediccion_1 prediccion_2 prediccion_3 , col(1) iscale(0.6) ysize(6.5) xsize(8.5) title(17Sep2014 al 10nov2022 - BTC-USD diario - Prediction & Error AR(1))
graph export proBTC-USD.tif, replace

est store AIC1
estimates stats AIC1

predict e1, residuals
gen absserr_1=abs(e1)
summ absserr_1

tsline e1, name(Error_1)
graph combine prediccion_1 Error_1, col(1) iscale(0.6) ysize(6.5) xsize(8.5) title(17Sep2014 al 10nov2022 - BTC-USD - Prediction & Error AR(1))

* Modelo AR(2)
arima lprecio_BTC_USD, arima(2,0,0)
est store AIC2
estimates stats AIC2

predict e2, residuals


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
