% x : Nxd
% y : 1xN
tic
%x = csvread('features_st_to_matlab.csv');
%y = csvread('response_to_matlab.csv');
N=200;d=2;
x=rand(N,d)*2-1;
y=exp(-x(:,1).^2-x(:,2).^2);
y=y';
Net=LM_RBF(x,y);
[yhat,D]=evaRBF(x,Net);
mean((y-yhat).^2)/2
toc

