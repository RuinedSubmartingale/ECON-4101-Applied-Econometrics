    % draws for error bands
    %n1 is number of draws from posterior
    %n2 is number of sign restriction rotations


function [IRMposs ] =BAYESsign(y,h,q,p,n1,n2,ProdMBPM,OECDCrudeDif)

[t,K]=size(y); %redundant coding..q and K are the same
IRMposs=zeros(K^2,h+1);  %will populate this in the loop

[BETAnc,B,X, SIGMA, U, V]=lsvarcSA2(y,24);

J=[eye(K,K) zeros(K,K*(p-1))];  %for use in sign rest. loop

pXX=inv((X*X')/(t-p));

index=1;
for r=1:n1
    
    RANTR=randn(t-p,q)/sqrt(t-p)*chol(inv(SIGMA));
    SIGMAr=inv(RANTR'*RANTR);
    Bvec=[vec(V);vec(BETAnc(:,1:q))]; 
    for l=1:p-1;
        Bvec=[Bvec; vec(BETAnc(:,q*l+1:q*(l+1)))];
    end
    vecAr=Bvec+(chol(kron(pXX/(t-p),SIGMAr)))'*randn(q*12+q*q*p,1); 
	Ar=[reshape(vecAr(12*q+1:12*q+q^2*p),q,q*p); eye(q*p-q,q*p-q) zeros(q*p-q,q)]; 
   
   
   %Compute sign IRFs
    for i=1:n2
      IRMint=zeros(K^2,h+1); %resetting
      
   
      newmatrix=normrnd(0,1,q,q); %Rubio et al algorithm
      [Q,R]=qr(newmatrix);
      for ii=1:q;
        if R(ii,ii)<0
            Q(:,ii)=-Q(:,ii);
        end
      end
      


       [eigvec, eigval]=eig(SIGMAr);
       P=eigvec*sqrt(eigval);
       
       %compute impulse response
       IRM=reshape(J*Ar^0*J'*P*Q,K^2,1);
       for j=1:h
	     IRM=([IRM reshape(J*Ar^j*J'*P*Q,K^2,1)]);
       end;
 
       
       if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)>=0 && IRM(3,1)<=0   %1st column is supply shock
           if  min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0 %2nd column is Flow Dem shock
               if min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column is Spec Dem shock
                   IRMint=IRM;
                  
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMint=[IRM(1:4,:); IRM(5:8,:); IRM(13:16,:); IRM(9:12,:)];
                     
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0   %3rd column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is SpecD shock
                   IRMint=[IRM(1:4,:); IRM(9:12,:); IRM(5:8,:); IRM(13:16,:)];
                  
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMint=[IRM(1:4,:); IRM(9:12,:); IRM(13:16,:); IRM(5:8,:)];
                  
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0   %4th column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is PD shock
                   IRMint=[IRM(1:4,:); IRM(13:16,:); IRM(5:8,:); IRM(9:12,:)];
                  
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMint=[IRM(1:4,:); IRM(13:16,:); IRM(9:12,:); IRM(5:8,:)];
                  
               else
                   continue;
               end;
           else
               continue;
           end;
       elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)>=0 && IRM(7,1)<=0   %2nd column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0  %1st column is Flow Dem shock
               if min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column is Spec Dem shock
                    IRMint=[IRM(5:8,:); IRM(1:4,:); IRM(9:12,:); IRM(13:16,:)];
                  
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                    IRMint=[IRM(5:8,:); IRM(1:4,:); IRM(13:16,:); IRM(9:12,:)];
                  
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0   %3rd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(5:8,:); IRM(9:12,:);  IRM(1:4,:);  IRM(13:16,:)];
                  
                elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMint=[IRM(5:8,:); IRM(9:12,:);IRM(13:16,:); IRM(1:4,:)];
                  
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0   %4th column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(5:8,:); IRM(13:16,:); IRM(1:4,:); IRM(9:12,:)];
                  
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMint=[IRM(5:8,:); IRM(13:16,:);  IRM(9:12,:); IRM(1:4,:)];
                  
               else
                   continue;
               end;    
           else
               continue;
           end;       
       elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)>=0 && IRM(11,1)<=0  %3rd column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0  %1st column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is SpecD shock
                   IRMint=[IRM(9:12,:); IRM(1:4,:); IRM(5:8,:); IRM(13:16,:)];
                  
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMint=[IRM(9:12,:); IRM(1:4,:);  IRM(13:16,:); IRM(5:8,:);];
                      
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0  %2nd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(9:12,:); IRM(5:8,:); IRM(1:4,:); IRM(13:16,:)];
                  
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMint=[IRM(9:12,:); IRM(5:8,:);  IRM(13:16,:); IRM(1:4,:);];
                      
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0   %4th column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(9:12,:); IRM(13:16,:); IRM(1:4,:); IRM(5:8,:)];
                  
               elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is SpecD shock
                   IRMint=[IRM(9:12,:); IRM(13:16,:);  IRM(5:8,:); IRM(1:4,:);];
                  
               else
                   continue;
               end;    
           else
               continue;
           end;
        elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)>=0 && IRM(15,1)<=0  %4th column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0 %1st column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is SpecD shock
                   IRMint=[IRM(13:16,:); IRM(1:4,:); IRM(5:8,:); IRM(9:12,:)];
                  
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMint=[IRM(13:16,:); IRM(1:4,:);  IRM(9:12,:); IRM(5:8,:)];
                      
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0  %2nd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(13:16,:); IRM(5:8,:); IRM(1:4,:); IRM(9:12,:)];
                  
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMint=[IRM(13:16,:); IRM(5:8,:);  IRM(9:12,:); IRM(1:4,:);];
                      
               else
                   continue;
               end;
           elseif min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0   %3rd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is SpecD shock
                   IRMint=[IRM(13:16,:); IRM(9:12,:); IRM(1:4,:); IRM(5:8,:)];
                  
               elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is SpecD shock
                   IRMint=[IRM(13:16,:); IRM(9:12,:);  IRM(5:8,:); IRM(1:4,:)];
                  
               else
                   continue;
               end;    
           else
               continue;
           end;    
       else
           continue
       end;
       
       %elas use
       IRprod=IRMint(1,1); IRinv=IRMint(4,1); IRprice=IRMint(3,1);
       FlowNew=ProdMBPM*(1+IRprod/100)-mean(OECDCrudeDif)-IRinv;
       Flow=ProdMBPM-mean(OECDCrudeDif);
       PctChange=100*(FlowNew-Flow)./Flow;
       ElasUse=PctChange/IRprice;
       elasuse=mean(ElasUse);
     
       SupplyelasAD=IRMint(5,1)/IRMint(7,1); %supply elasticity in response to Flow Demand shock
       SupplyelasPD=IRMint(9,1)/IRMint(11,1); % supply elasticity in response to Spec Demand shock

       if SupplyelasAD<.1 && SupplyelasPD<.1  && elasuse<=0 && elasuse>-.8  && min(cumsum(IRMint(1,1:12)))>=0 && min(IRMint(2,1:12))>=0 && max(IRMint(3,1:12))<=0; 
           IRMposs(:,:,index)=IRMint;
           index=index+1;
     
       end;
      

    end;  %end sign rest loop
    display(r)
    display(index)

    %upating after each sign loop
    save BayesUpdate IRMposs r index
    
    
end;  %end bs loop


