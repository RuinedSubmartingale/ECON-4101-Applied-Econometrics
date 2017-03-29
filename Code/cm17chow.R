#Chow Test - another example of a restriction tes
# Ho: Models are the same (data can be pooled)
# Ha: Models are not the same (data should not be pooled)
#
# Significance = 5% for 95% confidence level
#
#                (SSEr - SSEu) / J
# Test Stat: F = ------------------ ~ F df=J,N-K-1
#                 SSEu / (N-K-1)
#
# J = number of restrictions
# N = number of observations
# K = number of independent variables (unrestricted model)
#
# Reject Ho if F > Fcrit
#
# F >= Fcrit: Reject Ho: there is sufficient statistical
# evidence at the stated level of significance to reject
# the null hypothesis that the models are the same. The
# data should be split into separate groups, and estimated
# separately.
#
# F < Fcrit: Fail to Reject Ho: there is insufficient 
# statistical evidence at the stated level of significance 
# to reject the null hypothesis that the models are the same.
# The data can be safely pooled and estimated as one group.
# 
# 

#Management has given us data from two different
#operations. One is for short-range flights defined
#as less than 5 hours.  And long-range flights defined
#as 5 or more hours.  They have provided the data grouped
#together (chow.csv)

dfm <- read.csv("chow.csv")
fnm <- dfm$fnm       #fuel per nautical mile (lbs)
hours <- dfm$hours   #flight time (hours)

#Plot fuel usage on time, with red for flights less than 5 hours
plot(hours,fnm, col=ifelse(hours<5,"red","blue"),pch=16,main="Fuel per NM vs Hours")
grid(col="#cccccc")
#abline(v=5, lty=4)

#Get data for the following plots
dfm.short <- dfm[hours < 5,]
dfm.long <- dfm[hours >= 5,]

#--------------------------------------------------

#Plot Short flights (<5 hours)
y <- dfm.short$fnm
x <- dfm.short$hours
lm(y ~ x) # from this we get the intercept and slope terms

x1 <- 0; y1 <- 63.069
x2 <- 5; y2 <- 63.069 - 5.242 * 5
segments(x1,y1,x2,y2,col="red")

#--------------------------------------------------
#Plot Long flights (>= 5 hours)
y <- dfm.long$fnm
x <- dfm.long$hours
lm(y ~ x) # from this we get the intercept and slope terms

x1 <- 5; y1 <- 46.4571 -0.6375 * 5
x2 <- 20; y2 <- 46.4571 - 0.6375 * 20
segments(x1,y1,x2,y2,col="blue")

#we will see later this is a restricted model
mod.r <- lm(fnm ~ hours)
abline(mod.r)

# ----------------------------------------------
# Time for a Chow Test
# ----------------------------------------------
