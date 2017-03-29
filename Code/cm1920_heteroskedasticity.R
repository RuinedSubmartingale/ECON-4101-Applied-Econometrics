#Heteroskedasticity - Identification, Error Correction, and GLS
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

# ==================================================
rm(dfm,dfm.le,dfm.ue,dfm.wfe,e,mlower,mupper,mod.le,mod.ue,mod1,s1)




# ==================================================
# Goldfeld-Quandt Test for Heteroskedasticity
# Partition the data such that observations with higher
# variance are in one sample, and observations with lower
# variance are in another sample.
#
# Ho: Homoskedastic Errors (sigsq_1 = SIGSQ)
# Ha: Heteroskedastic Errors (sigsq_1 = SIGSQ * x)
#
# 5% significance level for 95% level of confidence
#
#                       Variance of Partition 1
# Test Statistic: GQ = -------------------------
#                       Variance of Partition 2
#
# Reject Ho if GQ > F ~ 5%, df1=n1-2, df2=n2-2, where
# n1 and n2 are the number of observations in each
# partition, respectively. 
#
#

#Based on prior visual inspection, it appeared that
# variance was higher with higher levels of income. 
# So, the hypothesis will be that the variance is higher
# for income above the median...
midinc <- median(income)

#We will not assume the data are in any particular order,
# and will sort it by income just to be safe...
dfm2 <- data.frame(income, food)
dfm2 <- dfm2[order(income),]

#Upper Partition: n1=20, variance = 2285.94
dfm2a <- dfm2[dfm2$income > midinc,]   #data: income > median 
mod2a <- lm(dfm2a$food ~ dfm2a$income) #Linear model
var1 <- (summary(mod2a)$sigma)^2       #Variance of upper parition

#Lower partition: n2=20, variance = 682.46
dfm2b <- dfm2[dfm2$income <= midinc,] 
mod2b <- lm(dfm2b$food ~ dfm2b$income)
var2 <- (summary(mod2b)$sigma)^2       #Variance of upper parition

#Calculate the Goldfeld-Quandt test statistic:
gq <- var1 / var2; gq

#Critical value of F is 2.22, therefore reject the null
#hypothesis that the variance is homoskedastic
fcrit <- qf(0.05, 18,18, lower.tail = F); fcrit

#Compute the p-value for the test.  
pf(gq, 18,18, lower.tail = F)

#There are easier ways...
#install.packages("lmtest")
library(lmtest)
gqtest(food ~ income)

#Now that we have formally tested for, and found evidence
# of that heteroskedasticity exists, we can no longer use the
# standard errors of the estimated coefficiencts, and
# confidence intervals are incorrect

#Let's look at the uncorrected standard errors, which
#are in the second column here...
mod1 <- lm(food ~ income)
confint(mod1)
summary(mod1)$coefficients

#Standard errors originate from the variamnce-covariance 
#matrix for the coefficients:
vcov(mod1)

#The variance estimates are on the diagonal
diag(vcov(mod1))

#Standard errors...which just confirms the second
#column above via summary(mod1)$coefficients
sqrt(diag(vcov(mod1)))

#Create confidence intervals for the estimators
se0 <- sqrt(diag(vcov(mod1)))[1]
se1 <- sqrt(diag(vcov(mod1)))[2] 

b0 <-mod1$coefficients[1]
b1 <-mod1$coefficients[2]

b0lower <- b0 - qt(.975,df=38) * se0
b0upper <- b0 + qt(.975,df=38) * se0

b1lower <- b1 - qt(.975,df=38) * se1
b1upper <- b1 + qt(.975,df=38) * se1

#Present them in the same matric as the confint function...
matrix(c(b0lower,b0upper, b1lower, b1upper),ncol=2, byrow=T)

#and here is the confint function...
confint(mod1)

#The reason we did this was because we will want to
#compute confidence intervals with the corrected 
#standard errors...so here we go:


#White's Approximation using the 'car' package
#install.packages("car") #install once
library(car)            #call once

#White's-Corrected Covariance Matrix
# replace vcov with hccm, then you get
#the corrected standard errors:
hvcm <- sqrt(diag(hccm(mod1, type="hc0")));hvcm

#Assigns each White's Standard error to a variable
wcse0 <- hvcm[1]
wcse1 <- hvcm[2]

#
b0lower <- b0 - qt(.975,df=38) * wcse0
b0upper <- b0 + qt(.975,df=38) * wcse0
b1lower <- b1 - qt(.975,df=38) * wcse1
b1upper <- b1 + qt(.975,df=38) * wcse1

#Notice how the confidence intervals, after correcting 
#for heteroskedasticity, are wider...
matrix(c(b0lower,b0upper, b1lower, b1upper),ncol=2, byrow=T)

#
#
#

#
#
#
#
#Robust Standard Errors with the sandwich package
#install.packages("sandwich")
library(sandwich)
 
#The following computes estimators with non-robust errors
# that is, no correction for heteroskedasticity...same results
# here as with: summary(mod1)
coeftest(mod1) #non-robust

#Model that incorporates White's Approximation
#followed by corresonding confidence interval of parameter estimates
coeftest(mod1, vcov = vcovHC(mod1,"HC0")) #Robust, White
coefci(mod1, vcov = vcovHC(mod1,"HC0"))

#Other robust errors, such as HC1, HC2, etc. are possible...
#See http://evansresearch.us/DSC/Spring2017/ECMT/HCandHAC.pdf
#Example...
#coeftest(mod1, vcov = vcovHC(mod1,"HC1")) #Robust, HC1
#coefci(mod1,vcov = vcovHC(mod1,"HC1")) #Robust, HC1

## ==========================================================
rm(list=ls()) #clean up and start over...

dfm.wfe <- read.csv("wfe.csv")
income <- dfm.wfe$income
food <- dfm.wfe$food



#How to estimate a model with heteroskedasticity such
#that it will have homoskedasticty?  Transform the variables
#then use OLS as usual.  The transformation is 1/sqrt(x)
#
# Original specification: y = b0 + b1 * x + e
mod1 <- lm(food ~ income)
summary(mod1)
plot(income, mod1$residuals)
library(lmtest)

# Generalized Least Squares Estimator (GLS; theoretically BLUE)
# Estimate y*w = b0*w + b1 * x*w + e*w, where w = 1/sqrt(x)
w <- 1/sqrt(income)
food.w <- food * w
income.w <- income * w
const.w <- w
mod1.w <- lm(food.w ~ 0 + const.w + income.w) #intercept explicitly modeled
summary(mod1.w)

#Alternatively, use lm with the weights option
# (note the squared term !)
mod2 <- lm(food ~ income, weights = w^2);summary(mod2)

#install.packages("nlme")
#library(nlme)
#gls(food ~ income, weights=varFixed(w^2))



#Here is another example of GLS, but using transforms based on
#the errors of two partitions - this is also called
#weighted least squares...
#
# 1. Estimate food ~ income for each partition
# 2. Save the errors from each regression
# 3. Calculate the standard deviation of the errors of each partition
# 4. Transform the variables with the appropriate standard deviation of errors
# 5. Use OLS on the transformed variables...

#First partition (lower variance was previously identified)
y <- food[1:20]
x <- income[1:20]
mod1 <- lm(y ~ x)
e1.sd <- sd( mod1$residuals )
food.1 <- y/e1.sd
income.1 <- x/e1.sd

#Second partition (higher variance was previously identified)
y <- food[21:40]
x <- income[21:40]
mod1 <- lm(y ~ x)
e2.sd <- sd( mod1$residuals )
food.2 <- y/e2.sd
income.2 <- x/e2.sd

#Put the data back together so we can estimate both 
#partitions in aggregate...
food.12 <- c(food.1,food.2)
income.12 <- c(income.1,income.2)

#Create the vector for the constant...
const.12 <- c(rep(1/e1.sd,20), rep(1/e2.sd, 20) )

#Generalized Least Squares via OLS...
mod.12 <-lm(food.12 ~ 0 + const.12 + income.12)
summary(mod.12)
confint(mod.12)

#Altenatively (and equivalently), though it still requires
#construction of the weights vector.  Look at the results and 
#notice how the residual standard error is equal to 1 
#This is expected. Why?
mod.12w <- lm(food ~ income, weights = const.12^2); summary(mod.12w)



## Feasible GLS Procedure for Multiple Regression
mod1 <- lm(food ~ income)     #run the heteroskedastic regression
e <- mod1$residuals           #save the residuals
le2 <- log(e^2)               #square and log the residuals
mod2 <- lm(le2 ~ income)      #regress the squared and logged errors on the independent variable(s)
ghat <- mod2$fitted.values    #extract the yhats
hhat <- exp(ghat)             #and exponentiate them  

w <- 1 / sqrt(hhat)           #weights for WLS (and the constant vector)
const.gls <- w

food.gls <- food * w
income.gls <- income * w
mod.gls <- lm(food.gls ~ 0 + const.gls + income.gls); summary(mod.gls)


# Video on heteroskedasticity
# https://www.youtube.com/watch?v=hFoDDwTF4KY

