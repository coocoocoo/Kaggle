function [y,D]=evaSVRBF(x,net)
% RBF evaluatioin
M=net.M; u=net.u; N=size(x,1);
D=cross_distance(x,u);
s=2*repmat(net.si.^2,N,1);
w=net.w;
y=sum(exp(-D./s).*repmat(w,N,1),2)+net.w0;
y=y';
return