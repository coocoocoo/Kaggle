clear all
close all
tic
%Generate Datas
N=400;d=2;
n1=N/2;n2=N/2;
x=2*rand(N,d)-1;
s=1;
switch s
    case 1
        y=[tanh(x(1:n2,1)+x(1:n1,2)) ;tanh(x((n1+1):end,1)-x((n1+1):end,2))]';
    case 2
        y=[sin(x(1:n2,1)+x(1:n1,2)) ;cos(x((n1+1):end,1)-x((n1+1):end,2))]';
end
%initial theta
LM_iniNet_SVRBF
B=1;
HC = 0;
while HC ~= 1 
    u=[];
    for i =1:K
        %Eq8
        x_ei=[x repmat([zeros(1,i-1) 1 zeros(1,K-i)],N,1)];
        u=[((y-evaSVRBF(x_ei,Net)).^2)' u];
    end
    for i =1:K
        %Eq9
        delta(:,i)=exp(-B*u(:,i))./sum(exp(-B*u),2);
    end
    xnew=[x delta];
    [Net theta]=SVLM_RBF(xnew,y,M,theta,Net);
    [yhat,D]=evaSVRBF(xnew,Net);
    fprintf('E: %f Sta: %f  B: %f \n',mean((y-yhat).^2),sum(sum( delta.^2))/N,B)
    if sum(sum( delta.^2))/N >0.99
        HC =1;
    end
    B=B/0.95;
end
%畫散步點 圈類別(兩類)
figure
plot3(x(:,1),x(:,2),y,'b.');hold on
loc1=find(delta(:,1)>=0.5);
plot3(x(loc1,1),x(loc1,2),y(loc1),'ro');hold on;
loc2=find(delta(:,2)>=0.5);
plot3(x(loc2,1),x(loc2,2),y(loc2),'bo');hold on;
title('Approximative functions')
%畫出近似曲面
X=[];
for i = -1:0.1:1
    for j = -1:0.1:1
        X=[X;i j];
    end
end
%X1=[X repmat([1 0],size(X,1),1)];
%X2=[X repmat([0 1],size(X,1),1)];
%Z1=evaSVRBF(X1,Net);
%Z2=evaSVRBF(X2,Net);
%[X,Y] = meshgrid(-1:.1:1);
%Z1=reshape(Z1,[size(X,1) size(X,1)]);
%Z2=reshape(Z2,[size(X,1) size(X,1)]);
%mesh(X,Y,Z1); hold on;
%mesh(X,Y,Z2);
%%%
a1=[x(loc1,1) x(loc1,2)];
a2=[x(loc2,1) x(loc2,2)];
b1=y(loc1);
b2=y(loc2);
[Net1,theta]=LM_RBF(a1,b1);
[Net2,theta]=LM_RBF(a2,b2);
X=[];
for i = -1:0.1:1
    for j = -1:0.1:1
        X=[X;i j];
    end
end
z1=evaRBF(X,Net1);
z2=evaRBF(X,Net2);
[X,Y] = meshgrid(-1:.1:1);
z1=reshape(z1,[size(X,1) size(X,1)]);
z2=reshape(z2,[size(X,1) size(X,1)]);
mesh(X,Y,z1); hold on;
mesh(X,Y,z2); hold on;
% 畫出真實函數
figure;

plot3(x(:,1),x(:,2),y,'b.');hold on
plot3(x(loc1,1),x(loc1,2),y(loc1),'ro');hold on;
plot3(x(loc2,1),x(loc2,2),y(loc2),'bo');hold on;
switch s
    case 1
        mesh(X,Y,tanh(X+Y)); hold on
        mesh(X,Y,tanh(X-Y)); hold on
    case 2
        mesh(X,Y,sin(X+Y)); hold on
        mesh(X,Y,cos(X-Y)); hold on
end
title('Real functions')
toc