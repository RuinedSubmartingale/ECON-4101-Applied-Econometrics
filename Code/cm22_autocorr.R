#Autocorrelation - Detection, Correction, and Estimation

#Data: 34 Years of Annual Bangladesh Sugarcane Acreage
#Hill,Griffiths, and Judge. Undergraduate Econometrics (2e). p.259
dfm <- read.csv("http://evansresearch.us/DSC/Spring2017/ECMT/Data/sugarcane.csv")


#We are interested in price elasticity so use a log-log model
y <- log(dfm$area)
x <- log(dfm$price)

plot(y, type='o')

#Plot
plot(x,y,main="Annual Bangladesh Sugarcane", ylab="log(Acres)", xlab="log(Price)", pch=19)
mtext("Elasticity: 0.971 (via OLS)",3,col="#cccccc")

#Ordinary Least Squares and confidence intervals of estimators
mod1 <- lm(y ~ x)
abline(mod1, lty=4, col="red")

summary(mod1)
confint(mod1)

#Time series data often have correlated errors, consequences are:
# 1. The least squares estimator is still linear unbiased, but no longer BLUE
# 2. Standard errors are incorrect, therefore confidence intervals, and inference may be misleading
#

#Extract residuals and predicted values
e <- mod1$residuals
yhat <- mod1$fitted.values
n <- length(e)


#Durbin-Watson Test for Autocorrelation
#
# Ho: errors are uncorrelated
# Ha: errors are not uncorrelated  (autocorrelation)
#
# DW == 2 : no autocorrelation
# DW  < 2 : positive autocorrelation
# DW  > 2 : negative autocorrelation
#

#Create a subset of the data based on the number of lags
#
k = 1 #number of lags
e.11 <- e[1:(n-k)]
e.12 <- e[(1+k):n]

#Autocorrelation coefficient: the correlation between the 
# two errors that are k periods apart
ac1 <- cor(e.11, e.12) ; ac1 

#Durbin-Watson statistic
# DW=1.29 < 2 suggests we have positive autocorrelation
dw1 <- sum((e.11 - e.12)^2)/sum(e^2) ; dw1

#Durbin-Watson Test
# Using the lmtest package we can get the p-value for the test
# The result, P < 0.05, allows us to reject the null hypothesis
# in favor of the alternative hypothesis that there is order one
# autocorrelation, AR(1); later we will examine higher orders.
library(lmtest)
dwtest(mod1)


#One way to deal with autocorrelation is simply to keep the coefficients
# but use better (ie., robust) standard errors; notice the lower t-values.
# Arguably our strategy should be to use a better estimation procedure
# which we look at afterward with generalized least squares. For now...
library(sandwich)
coeftest(mod1) # for comparison here is the summary for the original model
coeftest(mod1,  vcov=vcovHAC) # and here we have robust standard errors
coefci(mod1, vcov=vcovHAC) #confidence intervals


#Generalized Least Squares (nlme package)
# Notice how much more precise are the GLS standard errors, which even so 
# are larger than the OLS estimates, yet we know that because of autocorrelation
# that the OLS standard errors were incorrect
#
# Also note that elasticity is greater than one now, indicating that a one
# percent increase in the price of sugarcane results in a 1.016% increase in
# the number of acres of planted sugar cane.
#
library(nlme)
#Generalized Least Squares to correct for AR(1)
# Note: for MA(1) use q=1; MA(2) use q=2
mod.gls <- gls(y ~ x, correlation = corARMA(p=1,q=0))
summary(mod.gls)

#Add the GLS result to the plot
abline(mod.gls, col="blue")

mtext("Elasticity: 0.971 (via OLS)",3, col="white")
mtext("Elasticity: 1.02 (via GLS)",3, col="black")

# ==========================================================================


ac <- acf(e, lag.max = 10, plot = F)
ac1 <- ac$acf[2] # first-order autocorrelation coefficient

b0 <- mod.gls$coefficients[1]
b1 <- mod.gls$coefficients[2]
eT <- mod.gls$residuals[length(mod.gls$residuals)]
xtp1 <- log(0.4) # given: x_{T+1} = x_35 = x_{T+2} = x_36 = log(.4)

yhat35 <- b0 + b1*xtp1 + ac1*eT; yhat35
yhat36 <- b0 + b1*xtp1 + ac1^2*eT; yhat36

# estimate of acres planted
exp(yhat35) # first year beyond sample
exp(yhat36) # second year beyond sample
# ==========================================================================

# Autocorrelation of Different Orders
# Breusch-Godfrey Test
for(i in 1:10) {
  bg <- bgtest(mod1, order=i)
  s <- sprintf("Breusch-Godfrey Test: AR(%d) P=%0.4f", i, bg$p.value)
  print(s)
}

# ==========================================================================
# Attempt to account for autocorrelation by adding time variable
t <- dfm$year
mod2 <- lm(y ~ x + t)
summary(mod2)
bgtest(mod2, order=1) 
# The coefficient for t variable fails the t-test, suggesting it's not gonna help us. 
# We see from the Breusch-Godfrey that we still have autocorrelation of order 1. 
# i.e. including time trend didn't remove the autocorrelation
