

IdentMat=reshape(IRFelas(:,1,findex),4,4);
Uhat=U;
p=24;
t=439; t=length(kmData)
[K, q]=size(IdentMat);
% Compute structural multipliers
A=  [BETAnc; eye(K*(p-1),K*(p-1)), zeros(K*(p-1),K)];
J=[eye(K,K) zeros(K,K*(p-1))];
IRF=reshape(J*A^0*J'*IdentMat,K^2,1);

for i=1:t-p-1
	IRF=([IRF reshape(J*A^i*J'*IdentMat,K^2,1)]);
end;



% Compute structural shocks Ehat from reduced form shocks Uhat
Ehat=inv(IdentMat)*Uhat(1:q,:);

% Cross-multiply the weights for the effect of a given shock on the real
% oil price (given by the relevant row of IRF) with the structural shock
% in question
yhat1=zeros(t-p,1); yhat2=zeros(t-p,1); yhat3=zeros(t-p,1); yhat4=zeros(t-p,1);
for i=1:t-p
	yhat1(i,:)=dot(IRF(3,1:i),Ehat(1,i:-1:1));
	yhat2(i,:)=dot(IRF(7,1:i),Ehat(2,i:-1:1));
	yhat3(i,:)=dot(IRF(11,1:i),Ehat(3,i:-1:1));  
    yhat4(i,:)=dot(IRF(15,1:i),Ehat(4,i:-1:1));  
end;

time=(1973+2/12+1/12*p):1/12:2009+8/12; %starts at 1975.2


cumshock=yhat1+yhat2+yhat3+yhat4;  


figure;
subplot(3,1,1)
plot(time,yhat1,'b-','linewidth',2);
title('Cumulative Effect of Flow Supply Shock on Real Price of Crude Oil')
axis([1978+6/12 2009+8/12 -100 +100])
line([(1990+7/12) (1990+7/12)], [-100 100],'linewidth',2)
line([(1978+9/12) (1978+9/12)], [-100 100],'linewidth',2)
line([(1980+9/12) (1980+9/12)], [-100 100],'linewidth',2)
line([(2002+11/12) (2002+11/12)], [-100 100],'linewidth',2)
line([(1985+12/12) (1985+12/12)], [-100 100],'linewidth',2)
grid on

subplot(3,1,2)
plot(time,yhat2,'b-','linewidth',2);
title('Cumulative Effect of Flow Demand Shock on Real Price of Crude Oil')
axis([1978+6/12 2009+8/12 -100 +100])
line([(1990+7/12) (1990+7/12)], [-100 100],'linewidth',2)
line([(1978+9/12) (1978+9/12)], [-100 100],'linewidth',2)
line([(1980+9/12) (1980+9/12)], [-100 100],'linewidth',2)
line([(2002+11/12) (2002+11/12)], [-100 100],'linewidth',2)
line([(1985+12/12) (1985+12/12)], [-100 100],'linewidth',2)
grid on

subplot(3,1,3)
plot(time,yhat3,'b-','linewidth',2);
title('Cumulative Effect of Speculative Demand Shock on Real Price of Crude Oil')
axis([1978+6/12 2009+8/12 -100 +100])
line([(1990+7/12) (1990+7/12)], [-100 100],'linewidth',2)
line([(1978+9/12) (1978+9/12)], [-100 100],'linewidth',2)
line([(1980+9/12) (1980+9/12)], [-100 100],'linewidth',2)
line([(2002+11/12) (2002+11/12)], [-100 100],'linewidth',2)
line([(1985+12/12) (1985+12/12)], [-100 100],'linewidth',2)
grid on



