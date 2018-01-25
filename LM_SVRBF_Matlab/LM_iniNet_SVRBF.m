%addpath('annealed_KMeans');

%init delta
K = 2;%input('K : ');
delta = ones(N,d)./K;
%xnew=[x delta];
M = input('M : ');%M = 30;
d = size(x,2);
ep = 0.001;
L = M*(d+K)+2*M+1;
theta = rand(1,L)*2*ep - ep;
[cidx, ctrs]=kmeans(x,M);
%[Y Q]=annealed_kmeans2(X,M)
%[ctrs cidx]=annealed_kmeans2(x,M);
theta(1:M*d)=reshape(ctrs',1,M*d);
%theta(M*d+1:M*d+M*K)=1/K
theta(M*(d+K)+1:M*(d+K)+M)=1;
Net.u=reshape(theta(1:M*(d+K)),[d+K,M])';
Net.si=theta(M*(d+K)+1:M*(d+K)+M);
Net.w0=theta(M*(d+K)+M+1);
Net.w=theta(M*(d+K)+M+2:M*(d+K)+M+M+1);
Net.M = M;
Net.d = d+K;
Net.MaxLoop=1000;
Net.T=N;
Net.A=eye(d+K);
Net.beta=1;