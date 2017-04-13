%function to estimate a VAR(p) by LS
%includes seasonall adjustment
function [A,B,X, SIGMA, U, V]=lsvarcSA2(y,p)

%set up regressors and regressand
[t,K]=size(y);
y=y';
Y=y(:,p:t);

for i=1:p-1
    Y=[Y; y(:,p-i:t-i)];
end;

%creating SA dummies
 x=[eye(11); zeros(1,11)];
X2=[];
for i=1:fix((t-p)/12)  %number of years)
    X2=[X2;x];
end;
[l w] =size(X2);
last=[eye((t-p)-l), zeros((t-p)-l,11-((t-p)-l))];
X2=[X2;last];
X2=[ones(t-p,1), X2];

X=[X2'; Y(:,1:t-p)];
Y2=y(:,p+1:t);

%Run LS regression
B=(Y2*X')/(X*X');
U=Y2-B*X;
SIGMA=U*U'/(t-p-p*K-1);
V=B(:,1:12); %saving matrix for code in BAYESsign.m...this line differs from lsvarcSA
A=B(:,13:K*p+12);