%Bayes draws for reduced form parameters of the VAR.

close all;
clc;
clear;

global xmax

load kmData

load worldprod
ProdMBPM=worldprod(2:end)*30/1000;
OECDCrudeDif=kmData(:,4);

xmax=17;    %horizon
jmax=5000000;  %number of draws for sign restrictions
rdraws=50;   %posterior draws

randn('state',1112)


tic;
[IRFposs ]=BAYESsign(kmData,xmax,4,24,rdraws,jmax,ProdMBPM,OECDCrudeDif);
%save IRFpossBayes IRFposs 
%load IRFpossBayes
toc;

%saving for constructing error bands
IRMposs=IRFposs;
save BayesPosterior IRMposs
%for use in Main.m (Figure 1)

[j k l] = size(IRFposs);

elasuse=zeros(1,l);
elasprod=zeros(l,1);
for i=1:l;
    IRprod=IRFposs(1,1,i); IRinv=IRFposs(4,1,i); IRprice=IRFposs(3,1,i);
    FlowNew=ProdMBPM*(1+IRprod/100)-mean(OECDCrudeDif)-IRinv;
    Flow=ProdMBPM-mean(OECDCrudeDif);
    PctChange=100*(FlowNew-Flow)./Flow;
    ElasUseSeries=PctChange/IRprice;
    elasuse(i)=mean(ElasUseSeries);
    elasprod(i)=IRFposs(1,1,i)./IRFposs(3,1,i);
end;

%obtain the median elasticity in use
 medelasuse=median(elasuse)
	save medelasuse medelasuse; %called by Main.m

elasusepctile=prctile(elasuse,[16 50 84])
elasprodpctile=prctile(elasprod,[16 50 84])

std(elasusepctile)
std(elasprodpctile)