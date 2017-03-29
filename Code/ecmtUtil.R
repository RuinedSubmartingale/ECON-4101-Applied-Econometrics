#addCIPI2Plot(x, y, confidence_level)
# by Garen Evans, Wright School of Business (2017)
#
# This function adds confidence and prediction intervals
# to a scatter plot, where x = independent variable, and
# y = dependent variable.
#
# Example:
# x <- seq(1, 7)
# y <- 3.4 + 1.5*x + rnorm(length(x), mean=0, sd=2)
# plot(x,y)
# addCIPI2Plot(x,y,0.95) #95% confidence
#

addCIPI2Plot <- function(x, y, confid.level=0.95){

  #Verify number of observations is equal
  nx <- length(x)
  ny <- length(y)
  if(nx != ny){
    message("Unequal vector lengths, x and y")
    return
  }

  #Create a sequence of numbers that
  #includes the minimum and maximum of
  #the independent variable
  sqx <- seq(min(x),max(x),length=nx)
  sqx.dfm <- data.frame(x=sqx)

  plot(y ~ x)

  #Regression
  lmyx <- lm(y~x)

  #Create confidence interval and add lines to plot
  ci <- predict(lmyx,sqx.dfm,interval="confidence",level=confid.level)
  lines(sqx,ci[,2],col="red", lty=3)
  lines(sqx,ci[,3],col="red", lty=3)

  #Create prediction intervals and add lines to plot
  pi <- predict(lmyx,sqx.dfm,interval="prediction",level=confid.level)
  lines(sqx,pi[,2],col="black",lty=4)
  lines(sqx,pi[,3],col="black",lty=4)

}
