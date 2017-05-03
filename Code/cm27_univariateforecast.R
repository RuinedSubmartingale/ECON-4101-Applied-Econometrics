#This is quarterly sales data for 7 years
x <- c(897,476,376,509,967,529,407,371,884,407,310,338,900,448,344,274,740,261,289,319,1036,602,536,349,1050,633,435,415)

dfm <- read.csv("http://evansresearch.us/DSC/Spring2017/ECMT/Data/cm26.csv")

x <- dfm$sales
t <- 1:length(x)
plot(x, type="o", main="Quarterly Sales")

#The following shows the global trend of
#these data...
mod1 <- lm(x ~ t)
abline(mod1, lty=5, lwd=3, col="yellow")

#This removes the seasonality, but the moving
#average is centered between quarters 2 and 3, ie.,  at quarter 2.5
f <- rep(1/4,4)
tc2.5 <- filter(x,f,sides=2)
lines(t,tc2.5,col="gray",lty=1)


#Averaging the Q2 and Q3 averages centers the 
#moving average on Q3...this is the trend-cycle component
f <- rep(1/2,2)
tc3 <- filter(tc2.5,f,sides=1) #note the side
lines(t,tc3,col="blue")

#Create seasonal indices
si <- x / tc3

#Viewing the data
cbind(x,tc3,si)


##Find the median seasonal index for each quarter

#Sequences that refer to months for each quarter
#For example, the first sequence, 1 5 9 13 17 21 25, 
#are the months that correspond to the first quarter
sq1 <- seq(1,28,4);sq1
sq2 <- seq(2,28,4);sq2
sq3 <- seq(3,28,4);sq3
sq4 <- seq(4,28,4);sq4

#Quarterly medians
sq1mid <- median(si[sq1],na.rm=T)
sq2mid <- median(si[sq2],na.rm=T)
sq3mid <- median(si[sq3],na.rm=T)
sq4mid <- median(si[sq4],na.rm=T)

#Quarterly indices should average to one
# and this makes that minor correction...
cfac <- 4 / sum(c(sq1mid,sq2mid,sq3mid,sq4mid))
sqi1 <- sq1mid * cfac
sqi2 <- sq2mid * cfac
sqi3 <- sq3mid * cfac
sqi4 <- sq4mid * cfac

#Compute seasonally adjusted data, xsa
xsa <- x / c(sqi1,sqi2,sqi3,sqi4)
cbind(x,xsa)
lines(t,xsa,col="red",lwd=2)  #seasonally adjusted data

#Forecast 4 periods ahead for a seasonally
#adjusted projection of 632.8841...

#Year 8 Q1
632.8841 * sqi1
#Year 8 Q2
632.8841 * sqi2
#Year 8 Q2
632.8841 * sqi3
#Year 8 Q2
632.8841 * sqi4


#======================================================================
#------------ Simple Exponential Smoothing
a = 0.3
L = array(as.numeric())
for(i in 1:length(xsa)){
  if(i == 1){
    L[i] = xsa[i]
  }else{
    L[i] = a * xsa[i] + (1-a) * L[i-1]
  } 
}
plot(t,xsa,lwd=2,col="red",type="l",main="Seasonally Adjusted Sales")
lines(t,L,lwd=2,col="blue",type="l")


#Create a time series object - it wil be needed for
#the HoltWinters function...
ts.xsa <- ts(xsa, start=c(2001,1),frequency=4)
ts.xsa

#-------------Present Holt' Winter's Linear Trend Algorithm
mod.hw <- HoltWinters(ts.xsa, alpha=0.3, beta=0.1, gamma=FALSE)
plot(mod.hw)

#HoltWinters with alpha constrained, and beta determined
mod.hw <- HoltWinters(ts.xsa, alpha=0.3, gamma=FALSE)
plot(mod.hw)
mod.hw

#HoltWinters, automatic alpha and beta
mod.hw <- HoltWinters(ts.xsa, gamma=FALSE)
plot(mod.hw)
mod.hw

#forecast of seasonally adjusted values in 2008
fcast <- forecast(mod.hw,4) ; fcast

plot(fcast)

#2008 Q1-Q4 Forecasts
fcast$mean[1] * sq1mid 
fcast$mean[2] * sq2mid
fcast$mean[3] * sq3mid
fcast$mean[4] * sq4mid

#But HoltWinters can handle seasonality too:
ts.x <- ts(x, start=c(2001,1),frequency=4)
mod.hw <- HoltWinters(ts.x)
plot(mod.hw)
fcast <- forecast(mod.hw,4) ; fcast
plot(fcast)
