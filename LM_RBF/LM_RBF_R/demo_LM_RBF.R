#setwd("E:/Dropbox/Kaggle - House Prices Advanced Regression Techniques")
library(data.table);
ptm <- proc.time()

#demo_LM_RBF 2016/10/08
#MATLAB code transformation
#source("https://raw.githubusercontent.com/ggrothendieck/gsubfn/master/R/list.R")
#devtools::install_github("ggrothendieck/gsubfn")
library(gsubfn)
library(plot3D)
library(scatterplot3d)
source("update_net.R")
source("cross_distance.R")
source("derivative_RBF.R")
source("evaRBF.R")
source("LM_RBF.R")
source("readkey.R")

#x : Nxd
# y : 1xN

N=200;d=2;
x=matrix(runif(N*d,0,1),nrow= N);
y=exp(-x[,1]^2 - x[,2]^2);
y=t(t(y));

tempout=LM_RBF(x,y,50);
Net = tempout$Net;
theta = tempout$theta; rm(theta);
tempout=evaRBF(x,Net);
yhat = tempout$y;
D = tempout$D;rm(tempout);
mean((y-yhat)^2)/2

scatterplot3d(x[,1],x[,2],y,color='red', main="3D Scatterplot")
par(new=TRUE)
scatterplot3d(x[,1],x[,2],yhat, main="3D Scatterplot")
proc.time()-ptm

#N=200;d=3;
#x=rand(N,d)*2-1;
#y=tanh(-x(:,1).^2-x(:,2).^2);
#y=y';
#Net=LM_RBF(x,y);
#[yhat,D]=evaRBF(x,Net);
#mean((y-yhat).^2)/2