
require(R.matlab)
bayesPosterior <- readMat('./termpaper/BayesPosterior.mat'); IRMposs <- bayesPosterior$IRMposs
IRFelas <- readMat('./termpaper/IRFelas.mat'); IRFelas <- IRFelas$IRFelas;
findex <- readMat('./termpaper/findex.mat'); findex <- findex$findex;

# Main
xmax = 17
mindist <- 0.0061

# Figure 1
IRF <- IRFelas[,,findex]
time <- c(0:xmax);
CI <- apply(IRMposs, c(1,2), quantile, probs = c(.16,.84))
# CI=prctile(IRMposs,[16 84],3);
CI1458912=apply(apply(IRMposs, c(1,3), cumsum), c(1,2), quantile, probs = c(.16,.84))
# CI1458912=prctile(cumsum(IRMposs,2),[16 84],3);
for (i in c(1, 4, 5, 8, 9, 12)) {
  CI[, i, ] <- CI1458912[, , i]
}
# CI([1 4 5 8 9 12],:)=CI1458912([1 4 5 8 9 12],:);

CI5 = apply(IRMposs, c(1,2), quantile, probs=c(.025, .975))
# CI5=prctile(IRMposs,[2.5 97.5],3);
CI5_1458912=apply(apply(IRMposs, c(1,3), cumsum), c(1,2), quantile, probs = c(.025, .975));
# CI5_1458912=prctile(cumsum(IRMposs,2),[2.5 97.5],3);
for (i in c(1, 4, 5, 8, 9, 12)) {
  CI5[, i, ] <- CI5_1458912[, , i]
}
# CI5([1 4 5 8 9 12],:)=CI5_1458912([1 4 5 8 9 12],:);

require(ggplot2)
require(gridExtra)
df <- data.frame(Months=time, OilProduction=-cumsum(IRF[1,]), yl=-CI[1,1,], yu=-CI[2,1,])
g1 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=OilProduction), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-2, 2)) +
  ggtitle('Flow Supply Shock')

df <- data.frame(Months=time, RealActivity=-IRF[2,], yl=-CI[1,2,], yu=-CI[2,2,])
g2 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealActivity), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Flow Supply Shock')

df <- data.frame(Months=time, RealPriceOil=-IRF[3,], yl=-CI[1,3,], yu=-CI[2,3,])
g3 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealPriceOil), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Flow Supply Shock')

df <- data.frame(Months=time, Inventories=-cumsum(IRF[4,]), yl=-CI[1,4,], yu=-CI[2,4,])
g4 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=Inventories), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-20, 20)) +
  ggtitle('Flow Supply Shock')

df <- data.frame(Months=time, OilProduction=cumsum(IRF[5,]), yl=CI[1,5,], yu=CI[2,5,])
g5 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=OilProduction), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-2, 2)) +
  ggtitle('Flow Demand Shock')

df <- data.frame(Months=time, RealActivity=IRF[6,], yl=CI[1,6,], yu=CI[2,6,])
g6 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealActivity), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Flow Demand Shock')

df <- data.frame(Months=time, RealPriceOil=IRF[7,], yl=CI[1,7,], yu=CI[2,7,])
g7 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealPriceOil), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Flow Demand Shock')

df <- data.frame(Months=time, Inventories=cumsum(IRF[8,]), yl=CI[1,8,], yu=CI[2,8,])
g8 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=Inventories), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-20, 20)) +
  ggtitle('Flow Demand Shock')

df <- data.frame(Months=time, OilProduction=cumsum(IRF[9,]), yl=CI[1,9,], yu=CI[2,9,])
g9 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=OilProduction), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-2, 2)) +
  ggtitle('Speculative Demand Shock')

df <- data.frame(Months=time, RealActivity=IRF[10,], yl=CI[1,10,], yu=CI[2,10,])
g10 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealActivity), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Speculative Demand Shock')

df <- data.frame(Months=time, RealPriceOil=IRF[11,], yl=CI[1,11,], yu=CI[2,11,])
g11 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=RealPriceOil), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-10, 10)) +
  ggtitle('Speculative Demand Shock')

df <- data.frame(Months=time, Inventories=cumsum(IRF[12,]), yl=CI[1,12,], yu=CI[2,12,])
g12 <- ggplot(df, aes(x=Months)) +
  geom_line(aes(y=Inventories), color='red') +
  geom_line(aes(y=yl), color='blue', linetype='dashed') +
  geom_line(aes(y=yu), color='blue', linetype='dashed') +
  geom_hline(aes(yintercept=0)) +
  scale_y_continuous(limits = c(-20, 20)) +
  ggtitle('Speculative Demand Shock')


globs <- list(g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12)

grid.arrange(grobs=globs, layout_matrix = matrix(1:12, byrow = T,nrow=3))

