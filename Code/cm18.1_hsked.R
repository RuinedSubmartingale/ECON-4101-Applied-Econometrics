#Exploring Heteroskedasticity
#

#First let's create a model with homoskedastic errors
# just so we can see what is "normal". Later we will 
# look at a similar model with heteroskedastic errors
set.seed(6829)
x <- seq(258,1155,length=40)
y <- 40.8 + 0.13 * x + rnorm(40, 0, 37.8)

#Graphical inspection of the model: note that as the 
# value of x increases, the errors appear to vary by
# the same amount (ie., homoskedastic).
plot(x,y)
mod1 <- lm(y ~ x)
abline(mod1)

#Visually it appears the errors are homoskedastic.
# with mean = 0, and standard deviation close to 
# that specified for the y variable.
e <- mod1$residuals
plot(x, e, pch=2, main="Residual Plot",ylab="")
abline(h=mean(e))
sd(e)
s1 <- sprintf("Mean= %.2f +/- %.2f",mean(e),sd(e))
mtext(s1, 3)

#We can do a little more with this visually.  The idea
# is to separate out the errors above and below the
# mean, then plot each group against their corresponding
# explanatory variable.  Each of the plots should be roughly
# horizontal lines.

#Separate the errors that are above or below the mean error
dfm <- data.frame(x,e)
dfm.ue <- dfm[e>mean(e),]
dfm.le <- dfm[e<mean(e),]

#Add lines to show the mean of the upper and lower errors
mupper <- mean(dfm.ue$e)
abline(h=mupper, col="#cccccc", lty=2)
mlower <- mean(dfm.le$e)
abline(h=mlower, col="#cccccc", lty=2)

#Fit the upper and lower errors, separately, to the
# observations.  The fitted lines should be pretty
# close to the mean of the upper and lower errors, respectively.
mod.ue <- lm(dfm.ue$e ~ dfm.ue$x)
abline(mod.ue, col="#ff0000",lty=4)
mod.le <- lm(dfm.le$e ~ dfm.le$x)
abline(mod.le,col="#ff0000",lty=4)

#==========================================================

#Clean up
rm(list=ls())


#==========================================================
#Now let's look at some real data: weekly food expenditures 
# and income data. These data are from Hill, Griffiths and
# Judge, Undergraduate Economics (2e), Table 3.1, page 50.
dfm.wfe <- read.csv("wfe.csv")
names(dfm.wfe)

income <- dfm.wfe$income
food <- dfm.wfe$food

#Plot then regress food expenditures on income, and
# plot the fitted line.  Note how food expenditures vary
# more with higher levels of income...
plot(income,food,pch=19,main="Food Expenditures vs Income")
mod1 <- lm(food ~ income)
abline(mod1, lty=4,col="red",lwd=3)

#So the mean appears equal to zero, with some standard deviation
#and notice it is similar to the first example we created with
#homoskedastic errors...yet this time the errors are heteroskedastic
e <- mod1$residuals
plot(income, e, pch=2, main="Residual Plot",ylab="",xlab="Income")
abline(h=mean(e))
sd(e)
s1 <- sprintf("Mean= %.2f +/- %.2f",mean(e),sd(e))
mtext(s1, 3)

#Separate out the errors above and below the
# mean, then plot each group against their corresponding
# explanatory variable.  Each of the plots should be roughly
# horizontal lines.

#Separate the errors that are above or below the mean error
dfm <- data.frame(income,e)
dfm.ue <- dfm[e>mean(e),]
dfm.le <- dfm[e<mean(e),]

points(dfm.ue$income,dfm.ue$e, col="blue",bg="blue", pch=24)
points(dfm.le$income,dfm.le$e, col="red", bg="red", pch=24)

#Add lines to show the mean of the upper and lower errors
mupper <- mean(dfm.ue$e)
abline(h=mupper, col="#aaaaff", lty=2)
mlower <- mean(dfm.le$e)
abline(h=mlower, col="#ffaaaa", lty=2)

#Fit the upper and lower errors, separately, to the
# observations.  This time it's pretty obvious the
#errors are increasing as income increases, that is, 
#the errors are heteroskedastic
mod.ue <- lm(dfm.ue$e ~ dfm.ue$income)
abline(mod.ue,lty=4, col="blue")
mod.le <- lm(dfm.le$e ~ dfm.le$income)
abline(mod.le,lty=4, col="red")

#So the question now is...can we formally test for 
#heteroskedasticity (YES; Goldfeld-Quandt Test), and 
#can we update/correct the standard errors so that they
#are reflect the presence of heteroskdedastiocity (YES; via
#White's approximation)...

# ==================================================
# Clean up
rm(dfm,dfm.le,dfm.ue,dfm.wfe,e,mlower,mupper,mod.le,mod.ue,mod1,s1)
# ==================================================