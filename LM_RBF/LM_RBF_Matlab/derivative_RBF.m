function gtheta = derivative_RBF(Net,x,theta,D)

% determine ga,gb,gr ??
% gtheta : N x (Md+2M+1)
% ga : N x Md
% gb : N x M
% gr : N x ( M+1)

M=Net.M; w=Net.w;si=Net.si;
[N,d]=size(x);
%v
s=2*repmat(Net.si.^2,N,1);
v=exp(-D./s);
v2=v.*repmat(w./(si.^2),N,1);
%v3 
v3=reshape(repmat(v2,d,1),N,d*M);
u_row=reshape(Net.u',1,M*d);
dx_u=repmat(x,1,M) - repmat(u_row,N,1);
gu=v3.*dx_u;
% gsi
v2=v.*repmat(w./(si.^3),N,1);
gsi=v2.*D;
%gw0
gw0=ones(N,1);
gw=v;
gtheta=[gu gsi gw0 gw];

