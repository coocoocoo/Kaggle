LM_iniNet_RBF <- function(){
if( M == 0){
  print('Input M:');
  M = scan(nmax=1);
}
d = dim(x)[2];
ep = 0.001;
L = M*d+2*M+1;
if(missing(theta)){
  theta = runif(L)*2*ep - ep;
  cl=kmeans(x,M);
  ctrs = cl$centers;
  theta[1:(M*d)] = as.vector(ctrs);
  theta[(M*d+1):(M*d+M)]=1;
}
Net = list(u = matrix(theta[1:(M*d)],nrow=M));
Net$si = theta[(M*d+1):(M*d+M)];
Net$w0 = theta[M*d+M+1];
Net$w  = theta[(M*d+M+2):(M*d+2*M+1)];
Net$M  = M;
Net$d  = d;
Net$MaxLoop=1000;
Net$T=N;
Net$A=diag(x = 1, d);
Net$beta=1;
}

#if M==0
#M = input('M : ');
#end
#d = size(x,2);
#ep = 0.001;
#L = M*d+2*M+1;
#if nargin<=3
#theta = rand(1,L)*2*ep - ep;
#[cidx, ctrs]=kmeans(x,M);
#theta(1:M*d)=reshape(ctrs',1,M*d);
#theta(M*d+1:M*d+M)=1;
#end
#Net.u=reshape(theta(1:M*d),[d,M])';
#Net.si=theta(M*d+1:M*d+M);
#Net.w0=theta(M*d+M+1);
#Net.w=theta(M*d+M+2:M*d+M+M+1);
#Net.M = M;
#Net.d = d;
#Net.MaxLoop=1000;
#Net.T=N;
#Net.A=eye(d);
#Net.beta=1;