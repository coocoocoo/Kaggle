update_net = function(Net,theta){
  M = Net$M;
  d = Net$d;
  #M = Net.M;
  #d = Net.d;
  Net$u=t(matrix(theta[1:(M*d)],nrow=d));
  Net$si=theta[((M*d)+1):(M*d+M)];
  Net$w0=theta[M*d+M+1];
  Net$w=theta[(M*d+M+2):(M*d+M+M+1)];
  #Net.u=reshape(theta(1:M*d),[d,M])';
  #Net.si=theta(M*d+1:M*d+M);
  #Net.w0=theta(M*d+M+1);
  #Net.w=theta(M*d+M+2:M*d+M+M+1);
  return(Net)
}