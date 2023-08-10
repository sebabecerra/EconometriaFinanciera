install.packages("tseries")

# cargar librerias
library(quantmod)
library(tseries)
library(lmtest)
library(forecast)
library(lubridate)

#Tutorial Como importar datos de Yahoo Finance a RStudio
mdate="2014-09-17"
BTC_USD_prices=getSymbols('BTC-USD', from=mdate, auto.assign = F)
head(BTC_USD_prices)

mdate="2014-09-17"
BTC_USD_prices_1=getSymbols('BTC-USD', from=mdate, auto.assign = F)[,4]
head(BTC_USD_prices_1)
plot(BTC_USD_prices_1)

# definir la serie de tiempo
#BTC_USD_prices_1 <- ts(BTC_USD_prices_1, start = decimal_date(ymd("2014-09-17")),
#                       frequency = 365)

#Retorno discreto
BTC_USD_prices_1_roc_d=ROC(BTC_USD_prices_1, type='discret')
head(BTC_USD_prices_1_roc_d)
(424.440-457.334)/457.334
plot(BTC_USD_prices_1_roc_d)

#Retorno logaritmico
BTC_USD_prices_1_roc_l=ROC(BTC_USD_prices_1, type='continuous')
log(424.440/457.334)
head(BTC_USD_prices_1_roc_l)
plot(BTC_USD_prices_1_roc_l)

# otro tipo de grafico
chartSeries(BTC_USD_prices_1)
chartSeries(BTC_USD_prices_1, subset ="last 3 months")

# Serie en logaritmo
BTC_USD_log=log(BTC_USD_prices_1)

# Autocorrelacion y autocorrelacion parcial
acf(BTC_USD_prices_1) # Para MA
pacf(BTC_USD_prices_1) # Para AR

# Autocorrelacion y autocorrelacion parcial
acf(BTC_USD_log) # Para MA
pacf(BTC_USD_log) # Para AR

# Modelo AR(1)
modelo_1=arima(BTC_USD_log, order=c(1,0,0))
modelo_1

coeftest(modelo_1)
confint(modelo_1)
AIC(modelo_1)
BIC(modelo_1)

e1=residuals(modelo_1)
summary(e1)
absserr_1=abs(e1)
summary(absserr_1)

modelo_1_pred <-forecast::forecast(modelo_1,h=1500, level=c(99.5))
modelo_1_pred

plot(modelo_1_pred)

# Modelo AR(2)
modelo_2=arima(BTC_USD_log, order=c(2,0,0))
modelo_2
coeftest(modelo_2)
confint(modelo_2)
AIC(modelo_2)
BIC(modelo_2)

e2=residuals(modelo_2)
summary(e2)
absserr_2=abs(e2)
summary(absserr_2)

