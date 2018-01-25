cross_distance = function(x,u){
  M=dim(u)[1];N=dim(x)[1];
  D=x %*% t(u);
  #D=-2*D+ matrix(rep(rowSums(x^2),M),nrow=N);
  #D=D+ matrix(rep(rowSums(u^2),each=N),nrow=N);
  D=-2*D+ do.call(cbind, replicate(M,rowSums(x^2) , simplify=FALSE));
  D=D+ do.call(rbind, replicate(N,rowSums(u^2) , simplify=FALSE));
  return(D)
}

#Translated on 2016/10/08
#Matlab code 
#M=size(u,1);N=size(x,1);
#D=x*u';
#D=-2*D+repmat(sum(x.*x,2),1,M);
#D=D+repmat(sum(u.*u,2)',N,1);
