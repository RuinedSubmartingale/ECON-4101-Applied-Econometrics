%estimate VAR impulse response function
%takes estimtes of slope coefficients and structural innovation variance matrix
%h is horizon for IRF
%jmax is number of rotations 
%Using Rubio et al method (QR decomp)

function [IRMposs]=IRFsign(BETAnc,SIGMA,h,jmax)
  
  [K, n]=size(BETAnc);
  p=n/K;  %determine number of lags used in original estimation
      
  A=  [BETAnc; eye(K*(p-1),K*(p-1)), zeros(K*(p-1),K)];
  J=[eye(K,K) zeros(K,K*(p-1))];
  
  
  Btilda=zeros(K,K);  %this will be our set of permissable orthogonalizations
  %create rotation matrices
  IRMposs=zeros(K^2,h+1);
  index=1;
  for j=1:jmax;
     newmatrix=normrnd(0,1,K,K);
     [Q,R]=qr(newmatrix);
     for i=1:K;
       if R(i,i)<0
           Q(:,i)=-Q(:,i);
       end
     end

         
     Q=Q';


      [eigvec, eigval]=eig(SIGMA);
      P=eigvec*sqrt(eigval);

      Theta=J*A^(0)*J'*P*Q;
      IRM= reshape(Theta,K^2,1);
      for i=1:h;
          IRM=[IRM reshape(J*A^i*J'*P*Q,K^2,1)];
      end;

       if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)>=0 && IRM(3,1)<=0 %1st column is supply shock
           if  min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0 %2nd column is Flow Dem shock
               if min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column is Spec Dem shock
                   IRMposs(:,:,index)=IRM;
                   index=index+1;
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(1:4,:); IRM(5:8,:); IRM(13:16,:); IRM(9:12,:)];
                   index=index+1;   
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0   %3rd column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(1:4,:); IRM(9:12,:); IRM(5:8,:); IRM(13:16,:)];
                   index=index+1;
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(1:4,:); IRM(9:12,:); IRM(13:16,:); IRM(5:8,:)];
                   index=index+1;
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0  %4th column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(1:4,:); IRM(13:16,:); IRM(5:8,:); IRM(9:12,:)];
                   index=index+1;
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(1:4,:); IRM(13:16,:); IRM(9:12,:); IRM(5:8,:)];
                   index=index+1;
               else
                   continue;
               end;
           else
               continue;
           end;
       elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)>=0 && IRM(7,1)<=0   %2nd column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0 %1st column is Flow Dem shock
               if min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column is Spec Dem shock
                    IRMposs(:,:,index)=[IRM(5:8,:); IRM(1:4,:); IRM(9:12,:); IRM(13:16,:)];
                   index=index+1;
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                    IRMposs(:,:,index)=[IRM(5:8,:); IRM(1:4,:); IRM(13:16,:); IRM(9:12,:)];
                   index=index+1;
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0   %3rd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(5:8,:); IRM(9:12,:);  IRM(1:4,:);  IRM(13:16,:)];
                   index=index+1;
                elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(5:8,:); IRM(9:12,:);IRM(13:16,:); IRM(1:4,:)];
                   index=index+1;
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0   %4th column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(5:8,:); IRM(13:16,:); IRM(1:4,:); IRM(9:12,:)];
                   index=index+1;
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(5:8,:); IRM(13:16,:);  IRM(9:12,:); IRM(1:4,:)];
                   index=index+1;
               else
                   continue;
               end;    
           else
               continue;
           end;       
       elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)>=0 && IRM(11,1)<=0 %3rd column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0 %1st column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(1:4,:); IRM(5:8,:); IRM(13:16,:)];
                   index=index+1;
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(1:4,:);  IRM(13:16,:); IRM(5:8,:);];
                   index=index+1;    
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0 %2nd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(5:8,:); IRM(1:4,:); IRM(13:16,:)];
                   index=index+1;
               elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)<=0 && min(IRM(15,1))>=0  && min(IRM(16,1))>=0 %4th column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(5:8,:);  IRM(13:16,:); IRM(1:4,:);];
                   index=index+1;    
               else
                   continue;
               end;
           elseif min(cumsum(IRM(13,1)))>=0  && min(IRM(14,1))>=0 && min(IRM(15,1))>=0  %4th column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(13:16,:); IRM(1:4,:); IRM(5:8,:)];
                   index=index+1;
               elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(9:12,:); IRM(13:16,:);  IRM(5:8,:); IRM(1:4,:);];
                   index=index+1;
               else
                   continue;
               end;    
           else
               continue;
           end;
        elseif min(cumsum(IRM(13,1)))>=0 && IRM(14,1)>=0 && IRM(15,1)<=0  %4th column is supply shock
           if  min(cumsum(IRM(1,1)))>=0  && min(IRM(2,1))>=0 && min(IRM(3,1))>=0 %1st column is Flow Dem shock
               if min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(1:4,:); IRM(5:8,:); IRM(9:12,:)];
                   index=index+1;
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(1:4,:);  IRM(9:12,:); IRM(5:8,:)];
                   index=index+1;    
               else
                   continue;
               end;
           elseif   min(cumsum(IRM(5,1)))>=0  && min(IRM(6,1))>=0 && min(IRM(7,1))>=0 %2nd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(5:8,:); IRM(1:4,:); IRM(9:12,:)];
                   index=index+1;
               elseif min(cumsum(IRM(9,1)))>=0 && IRM(10,1)<=0 && min(IRM(11,1))>=0  && min(IRM(12,1))>=0 %3rd column Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(5:8,:);  IRM(9:12,:); IRM(1:4,:);];
                   index=index+1;    
               else
                   continue;
               end;
           elseif min(cumsum(IRM(9,1)))>=0  && min(IRM(10,1))>=0 && min(IRM(11,1))>=0  %3rd column is Flow Dem shock
               if min(cumsum(IRM(1,1)))>=0 && IRM(2,1)<=0 && min(IRM(3,1))>=0  && min(IRM(4,1))>=0 %1st column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(9:12,:); IRM(1:4,:); IRM(5:8,:)];
                   index=index+1;
               elseif min(cumsum(IRM(5,1)))>=0 && IRM(6,1)<=0 && min(IRM(7,1))>=0  && min(IRM(8,1))>=0   %2nd column is Spec Dem shock
                   IRMposs(:,:,index)=[IRM(13:16,:); IRM(9:12,:);  IRM(5:8,:); IRM(1:4,:)];
                   index=index+1;
               else
                   continue;
               end;    
           else
               continue;
           end;    
       else
           continue
       end;
      
  end;  


