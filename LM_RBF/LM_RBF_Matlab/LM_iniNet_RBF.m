addpath('annealed_KMeans');

if M==0
M = input('M : ');
end
d = size(x,2);
ep = 0.001;
L = M*d+2*M+1;
if nargin<=3
theta = rand(1,L)*2*ep - ep;
[cidx, ctrs]=kmeans(x,M);
%[Y Q]=annealed_kmeans2(X,M)
%[ctrs cidx]=annealed_kmeans2(x,M);
theta(1:M*d)=reshape(ctrs',1,M*d);
theta(M*d+1:M*d+M)=1;
end
Net.u=reshape(theta(1:M*d),[d,M])';
Net.si=theta(M*d+1:M*d+M);
Net.w0=theta(M*d+M+1);
Net.w=theta(M*d+M+2:M*d+M+M+1);
Net.M = M;
Net.d = d;
Net.MaxLoop=1500;
Net.T=N;
Net.A=eye(d);
Net.beta=1;
