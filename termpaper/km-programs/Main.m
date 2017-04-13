

close all;
clc;
clear;

global xmax

load kmData
% percent change in global oil production, real activity index from Kilian(AER 2009), the log real price of oil, and changes in OECD crude oil inventories

[BETAnc,B,X, SIGMA, U, V]=lsvarcSA(kmData,24);

xmax=17;
jmax=5000000;
randn('state',316)
[IRFaer, K]=VARirf(BETAnc,SIGMA,xmax);


[IRFposs]=IRFsign(BETAnc,SIGMA,xmax,jmax);


[j k l] = size(IRFposs);

load worldprod
ProdMBPM=worldprod(2:end)*30/1000;
OECDCrudeDif=kmData(:,4);


%imposing additional restrictions

index=1;
IRFelas=zeros(4^2,xmax+1);  %will be populated with the admissible IRFs
elasticity=IRFposs(9,1,:)./IRFposs(11,1,:);  %supply elasticity in response to speculative demand shock
ADelas=IRFposs(5,1,:)./IRFposs(7,1,:);  %supply elasticity in response to flow demand shock
elasuse=0;
format short
for i=1:l;
    %%elas in use
    IRprod=IRFposs(1,1,i); IRinv=IRFposs(4,1,i); IRprice=IRFposs(3,1,i);
    FlowNew=ProdMBPM*(1+IRprod/100)-mean(OECDCrudeDif)-IRinv;
    Flow=ProdMBPM-mean(OECDCrudeDif);
    PctChange=100*(FlowNew-Flow)./Flow;
    ElasUseSeries=PctChange/IRprice;
    if elasticity(i)<=.0258 && ADelas(i)<=.0258  && mean(ElasUseSeries)<=0    && min(cumsum(IRFposs(1,1:12,i)))>=0 && min(IRFposs(2,1:12,i))>=0 && max(IRFposs(3,1:12,i))<=0 ;
        IRFelas(:,:,index)=IRFposs(:,:,i); %admissible IRFs
        elasuse(index)=mean(ElasUseSeries);  %elasticity in use
        index=index+1;
    end;
  
end;

load medelasuse
%median of posterior is -.26
distance=abs(elasuse-medelasuse);
%find index of IRF with elasuse closest to -.26
[mindist, findex]=min(distance)  

%Figure 1
Figure1

%Figure 2
Figure2

%Figures 3 through 7
Figures3to7;

%Table 2
Btilda=reshape(IRFelas(:,1,findex),4,4);  %recovering identification matrix
%variance decomp
VDC=zeros(15,4);
VDCrpoil=zeros(15,4);
  for h=1:15;
      [VC, K]=VARdecomp(BETAnc,Btilda,h);
      %inventory change is fourth variable
      VDC(h,:)=VC(4,:);
      VDCrpoil(h,:)=VC(3,:);
  end;

  [VC, K]=VARdecomp(BETAnc,Btilda,600);
  VDCinf=VC(4,:)
  VDCinfrpoil=VC(3,:)

  


