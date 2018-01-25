evaRBF <- function(x,net){
  M=net$M; u=net$u; N=dim(x)[1];
  D=cross_distance(x,u);
  s=2*do.call(rbind, replicate(N,net$si^2 , simplify=FALSE));
  w=net$w;
  y=rowSums(exp(-D/s)* do.call(rbind, replicate(N,w , simplify=FALSE)))+net$w0;

  return(list(y=y,D=D))
}

#Translated on 2016/10/08
#Matlab code 
#M=net.M; u=net.u; N=size(x,1);
#D=cross_distance(x,u);
#s=2*repmat(net.si.^2,N,1);
#w=net.w;
#y=sum(exp(-D./s).*repmat(w,N,1),2)+net.w0;
#y=y';