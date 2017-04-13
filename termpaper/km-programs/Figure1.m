%obtain relevant IRF
IRF=IRFelas(:,:,findex);
%obtain IRFs from the Posterior draws
load BayesPosterior;

time=(0:1:xmax);
CI=prctile(IRMposs,[16 84],3);
CI1458912=prctile(cumsum(IRMposs,2),[16 84],3);
CI([1 4 5 8 9 12],:)=CI1458912([1 4 5 8 9 12],:);

CI5=prctile(IRMposs,[2.5 97.5],3);
CI5_1458912=prctile(cumsum(IRMposs,2),[2.5 97.5],3);
CI5([1 4 5 8 9 12],:)=CI5_1458912([1 4 5 8 9 12],:);


figure;
set(gcf,'name',['Figure 1'])
set(gcf,'NumberTitle','off')

subplot(3,4,1); %row 1
plot(time,-cumsum(IRF(1,:)),'r',time,-(CI(1,:,1)),'b--',time,-(CI(1,:,2)),'b--','linewidth',2);         
title('Flow supply shock')
ylabel('Oil production')
line([0 xmax], [0 0],'linewidth',2)
axis([0 xmax -2 1])
hold off;
 
subplot(3,4,2);
    plot(time,-IRF(2,:),'r',time,-(CI(2,:,1)),'b--',time,-(CI(2,:,2)),'b--','linewidth',2);
    title('Flow supply shock')
    ylabel('Real activity')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off; 

subplot(3,4,3);
    plot(time,-IRF(3,:),'r',time,-(CI(3,:,1)),'b--',time,-(CI(3,:,2)),'b--','linewidth',2);
    title('Flow supply shock')
    ylabel('Real price of oil')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off; 

subplot(3,4,4);
    plot(time,-cumsum(IRF(4,:)),'r',time,-(CI(4,:,1)),'b--',time,-(CI(4,:,2)),'b--','linewidth',2);
    title('Flow supply shock')
    ylabel('Inventories')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -20 20]);
    hold off; 
    
 subplot(3,4,5);
    plot(time,cumsum(IRF(5,:)),'r',time,(CI(5,:,1)),'b--',time,(CI(5,:,2)),'b--','linewidth',2);
    title('Flow demand shock')
    ylabel('Oil production')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -1 2]);
    hold off; 

 subplot(3,4,6);
    plot(time,IRF(6,:),'r',time,(CI(6,:,1)),'b--',time,(CI(6,:,2)),'b--','linewidth',2);
    title('Flow demand shock')
    ylabel('Real activity')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off; 
 
subplot(3,4,7);
    plot(time,IRF(7,:),'r',time,(CI(7,:,1)),'b--',time,(CI(7,:,2)),'b--','linewidth',2);
    title('Flow demand shock')
    ylabel('Real price of oil')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off;     
    
 subplot(3,4,8);
    plot(time,cumsum(IRF(8,:)),'r',time,(CI(8,:,1)),'b--',time,(CI(8,:,2)),'b--','linewidth',2);
    title('Flow demand shock')
    ylabel('Inventories')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -20 20]);
    hold off;        
    
 subplot(3,4,9);
    plot(time,cumsum(IRF(9,:)),'r',time,(CI(9,:,1)),'b--',time,(CI(9,:,2)),'b--','linewidth',2);
    title('Speculative demand shock')
    ylabel('Oil production')
    xlabel('Months')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -1 2]);
    hold off; 
    
subplot(3,4,10);
    plot(time,IRF(10,:),'r',time,(CI(10,:,1)),'b--',time,(CI(10,:,2)),'b--','linewidth',2);
    title('Speculative demand shock')
    ylabel('Real activity')
    xlabel('Months')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off;  
    
 subplot(3,4,11);
   plot(time,IRF(11,:),'r',time,(CI(11,:,1)),'b--',time,(CI(11,:,2)),'b--','linewidth',2);
    title('Speculative demand shock')
    ylabel('Real price of oil')
    xlabel('Months')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -5 10]);
    hold off; 
    
  subplot(3,4,12);
   plot(time,cumsum(IRF(12,:)),'r',time,(CI(12,:,1)),'b--',time,(CI(12,:,2)),'b--','linewidth',2);
    title('Speculative demand shock')
    ylabel('Inventories')
    xlabel('Months')
    line([0 xmax], [0 0],'linewidth',2)
    axis([0 xmax -20 20]);
    hold off;    
  

     