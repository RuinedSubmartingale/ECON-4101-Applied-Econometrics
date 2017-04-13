
IdentMat=reshape(IRFelas(:,1,findex),4,4);
Uhat=U;
p=24;
t=439;
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
	yhat1(i,:)=dot(IRF(4,1:i),Ehat(1,i:-1:1));
	yhat2(i,:)=dot(IRF(8,1:i),Ehat(2,i:-1:1));
	yhat3(i,:)=dot(IRF(12,1:i),Ehat(3,i:-1:1)); 
    yhat4(i,:)=dot(IRF(16,1:i),Ehat(4,i:-1:1)); 
end;
Phat1=zeros(t-p,1); Phat2=zeros(t-p,1); Phat3=zeros(t-p,1); Phat4=zeros(t-p,1);
for i=1:t-p
	Phat1(i,:)=dot(IRF(3,1:i),Ehat(1,i:-1:1));
	Phat2(i,:)=dot(IRF(7,1:i),Ehat(2,i:-1:1));
	Phat3(i,:)=dot(IRF(11,1:i),Ehat(3,i:-1:1));  
    Phat4(i,:)=dot(IRF(15,1:i),Ehat(4,i:-1:1));  
end;



time=(1973+2/12+1/12*p):1/12:2009+8/12;


%%%%  Figure 3...Gulf War
xlabels = {'1990.7','1990.8','1990.9','1990.10','1990.11','1990.12','1991.1','1991.2'};
figure;
subplot(2,1,1)
plot(time,Phat1,'k--',time,Phat3,'k-',time,zeros(size(Phat1)),'linewidth',2);
legend('Cumulative effect of flow supply shock','Cumulative effect of speculative demand shock')
title('Real price of oil')
axis([1990+7/12 1991+2/12 -35 +35])
set(gca, 'Xtick', [1990+7/12 1990+8/12 1990+9/12 1990+10/12 1990+11/12 1990+12/12 1991+1/12 1991+2/12], 'XtickLabel', xlabels)
grid on

subplot(2,1,2)
plot(time,yhat1,'k--',time,yhat3,'k-',time,zeros(size(yhat1)),'linewidth',2);
title('Change in oil inventories')
axis([1990+7/12 1991+2/12 -50 20])
set(gca, 'Xtick', [1990+7/12 1990+8/12 1990+9/12 1990+10/12 1990+11/12 1990+12/12 1991+1/12 1991+2/12], 'XtickLabel', xlabels)
grid on

%%%%  Figure ...Iranian Revolution
xlabels = {'1978.10','1979.1','1979.4','1979.7','1980.1'};
figure;
subplot(2,1,1)
plot(time,Phat1,'k--',time,Phat3,'k-',time,zeros(size(Phat1)),'linewidth',2);
legend('Cumulative effect of flow supply shock','Cumulative effect of speculative demand shock')
title('Real price of oil')
axis([1978+10/12 1980+2/12 -30 +50])
set(gca, 'Xtick', [1978+10/12 1979+1/12 1979+4/12 1979+7/12 1980+1/12], 'XtickLabel', xlabels)
grid on

subplot(2,1,2)
plot(time,yhat1,'k--',time,yhat3,'k-',time,zeros(size(yhat1)),'linewidth',2);
title('Change in oil inventories')
axis([1978+10/12 1980+2/12 -30 +50])
set(gca, 'Xtick', [1978+10/12 1979+1/12 1979+4/12 1979+7/12 1980+1/12], 'XtickLabel', xlabels)
grid on


%Figure 5...Iran-Iraq War
xlabels = {'1980.9','1980.12','1981.3','1981.6'};
figure;
subplot(2,1,1)
plot(time,Phat1,'k--',time,Phat3,'k-',time,zeros(size(Phat1)),'linewidth',2);
legend('Cumulative effect of flow supply shock','Cumulative effect of speculative demand shock')
title('Real price of oil')
axis([1980+8/12 1981+6/12 -30 +50])
set(gca, 'Xtick', [1980+9/12 1980+12/12 1981+3/12 1981+6/12], 'XtickLabel', xlabels)
grid on

subplot(2,1,2)
plot(time,yhat1,'k--',time,yhat3,'k-',time,zeros(size(yhat1)),'linewidth',2);
title('Change in oil inventories')
axis([1980+8/12 1981+6/12 -30 +50])
set(gca, 'Xtick', [1980+9/12 1980+12/12 1981+3/12 1981+6/12], 'XtickLabel', xlabels)
grid on



%Fig 6  OPEC collaps
x3labels={'1986.1','1986.3','1986.5'};
figure;
subplot(2,1,1)
plot(time,Phat1,'k--',time,Phat3,'k-',time,zeros(size(Phat1)),'linewidth',2);
legend('Cumulative effect of flow supply shock','Cumulative effect of speculative demand shock')
title('Real price of oil')
axis([1985+12/12 1986+6/12 -40 40])
set(gca, 'Xtick', [1986+1/12 1986+3/12 1986+5/12], 'XtickLabel', x3labels)
grid on

subplot(2,1,2)
plot(time,yhat1,'k--',time,yhat3,'k-',time,zeros(size(yhat1)),'linewidth',2);
title('Change in oil inventories')
axis([1985+12/12 1986+6/12 -40 40])
set(gca, 'Xtick', [1986+1/12 1986+3/12 1986+5/12], 'XtickLabel', x3labels)
grid on


%Fig 7 Venezuela
x5labels={'2002.11','2003.1','2003.4'};
figure;
subplot(2,1,1)
plot(time,Phat1,'k--',time,Phat3,'k-',time,zeros(size(Phat1)),'linewidth',2);
legend('Cumulative effect of flow supply shock','Cumulative effect of speculative demand shock')
title('Real price of oil')
axis([2002+11/12 2003+5/12 -40 40])
set(gca, 'Xtick', [2002+11/12 2003+1/12 2003+4/12], 'XtickLabel', x5labels)
grid on

subplot(2,1,2)
plot(time,yhat1,'k--',time,yhat3,'k-',time,zeros(size(yhat1)),'linewidth',2);
title('Change in oil inventories')
axis([2002+11/12 2003+5/12 -40 40])
set(gca, 'Xtick', [2002+11/12 2003+1/12 2003+4/12], 'XtickLabel', x5labels)
grid on


