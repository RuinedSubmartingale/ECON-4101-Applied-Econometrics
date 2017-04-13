%estimate VAR impulse response function
%takes estimtes of slope coefficients and structural innovation variance matrix
%15 is horizon
function [VC, K]=VARdecomp(BETAnc,Btilda,h);
  
  [K, n]=size(BETAnc);
  p=n/K;  %determine number of lags used in original estimation
  A=  [[BETAnc; eye(K*(p-1),K*(p-1)), zeros(K*(p-1),K)]];
  J=[eye(K,K) zeros(K,K*(p-1))];
  TH1=J*A^0*J'; TH=TH1*Btilda; TH=TH'; TH2=(TH.*TH); TH3=TH2;
  for i=2:h
    TH=J*A^(i-1)*J'*Btilda; TH=TH'; TH2=(TH.*TH); TH3=TH3+TH2;
  end;
  TH4=sum(TH3);
  VC=zeros(K,K);
  for j=1:K
    VC(j,:)=TH3(j,:)./TH4;
  end;
  
% Display VDC in percentage terms at horizon h, K x K matrix.
% Columns refer to shocks j=1,...,K that explain any given variable
% Rows refer to variables whose variation is to be explained
VC=VC'*100;