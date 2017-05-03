#Univariate Forecasting

cm26 <- read.csv("http://evansresearch.us/DSC/Spring2017/ECMT/Data/cm26.csv")
x <- ts(cm26$sales, start=c(2001,1),frequency=4)

#Getting seasonally-adjusted data
dcx <- decompose(x, type="mult") #default is type="additive"
plot(dcx)

library(forecast)
xsa <- seasadj(dcx, col=4)
ts.plot(x, xsa)

#Seasonal indices (automatically adjusted so mean=1 for each period)
si <- dcx$figure;si  # (ie., quarterly multiplicative)

#Simple Exponential Series
mod.ses <- ses(xsa, h=4)
fcast.ses <- forecast(mod.ses, 4) ; fcast.ses
plot(fcast.ses)
lines(fcast.ses$fitted, col="red")

# Predictions of seasonally adjusted data
xsa.2008 <- predict(mod.ses, n.ahead=4); xsa.2008

# Adjusted for seasonality
x.2008 <- si * xsa.2008$mean; x.2008

#Alpha is buried quite deeply...
a <- mod.ses$model[7]$fit$par[1];a


#-----------------------------------------------------------
#Holt and Holt-Winters Forecasting
# with seasonally adjusted data, set gamma=FALSE
# and let the function find optimal exponential (alpha)
# and trend (beta) parameters...
mod.hw <- HoltWinters(xsa, gamma=FALSE)
a <- mod.hw$alpha
b <- mod.hw$beta
mod.hw$alpha; mod.hw$beta; mod.hw$gamma

# Predictions of seasonally adjusted data
xsa.2008 <- predict(mod.hw, n.ahead=4); xsa.2008

# Adjusted for seasonality
x.2008 <- si * xsa.2008; x.2008

# Plot original series and forecasts
xpf <- ts(c(x,x.2008), start=c(2001,1),frequency=4)
plot(xpf, main="Quarterly Sales + 2008 Projections", type="o",pch=19)
grid()
str <- sprintf("Holt's alpha=%.4f, beta=%.4f",a,b)
mtext(str,3,col="red")
abline(v=c(2008,2008.25,2008.5,2008.75), lty=4, col="red")

#Returning to the original data, we let HoltWinters
# handle the seasonality component

#Holt-Winters (seasonal="additive" is default)
mod.hw <- HoltWinters(x, seasonal="multiplicative")
fcast.hw <- forecast(mod.hw, 4) ; fcast.hw
plot(fcast.hw)
mod.hw$alpha; mod.hw$beta; mod.hw$gamma

#ARIMA (AR,DIF,MA)(sAR,sDIF,sMA)[period]
mod.arima <- auto.arima(x,stepwise=FALSE)
fcast.arima <- forecast(mod.arima, 4) ; fcast.arima
plot(fcast.arima)
mod.arima

#State-space ARIMA
# Advantages: Easily handles structural breaks, missing data,
#  multiple seasonalities, irregularly-spaced data, etc.
# Disadvanatges: very black-boxy
library(smooth)
mod.ssarima <- auto.ssarima(x, h=4, initial="optimal",stepwise=FALSE)
fcast.ssarima <- forecast(mod.ssarima, 4) ; fcast.ssarima
plot(fcast.ssarima)


#The forecast package also implements Holt, and Holt-Winters
# (we'll need to use these to obtain accuracy measures)
modF.holt <- holt(x); modF.holt
modF.hw <- hw(x)

#Measures of Model Fitness
# ME   = mean error
# RMSE = root mean square error  ...sqrt(sum(e^2)/n)
# MAE  = mean absolute error  ...very popular
# MPE  = mean percent error
# MAPE = mean absolute percentage error
# MASE = mean absolute scale error   ...used to compare forecasts across datasets
# ACF1 = first order autocorrelation coefficient
accuracy(mod.ses)
accuracy(modF.holt)
accuracy(modF.hw)
accuracy(mod.arima)
accuracy(fcast.ssarima) 


#A table of information criteria (AIC, AICc, and BIC)
cb1 <- cbind(AIC(mod.ses$model),AICc(mod.ses$model),BIC(mod.ses$model))
cb2 <- cbind(AIC(modF.holt$model),AICc(modF.holt$model),BIC(modF.holt$model))
cb3 <- cbind(AIC(modF.hw$model),AICc(modF.hw$model),BIC(modF.hw$model))
cb4 <- cbind(AIC(mod.arima),AICc(mod.arima),BIC(mod.arima))
cb5 <- cbind(AIC(mod.ssarima),AICc(mod.ssarima),BIC(mod.ssarima))
tab1 <- as.table(rbind(cb1,cb2,cb3,cb4,cb5))
row.names(tab1) <- c("Exponential","Holt", "Holt-Winters","ARIMA","SSARIMA")
colnames(tab1) <- c("AIC", "AICc", "BIC")
tab1

#--------------------------------------------------------------------
#There are others...
# ets - exponential state spce model
# rwf - random walk forecast
# thetaf -theta forecast 
#--------------------------------------------------------------------