derivative_RBF = function(Net,x,theta,D){
  M=Net$M; w=Net$w;si=Net$si;
  N=dim(x)[1];
  d=dim(x)[2];
  
#M=Net.M; w=Net.w;si=Net.si;
#[N,d]=size(x);
#%v
  s=2*do.call(rbind, replicate(N,Net$si^2 , simplify=FALSE));
  v=exp(-D/s);
  v2=v*do.call(rbind, replicate(N,w/(si^2) , simplify=FALSE));
#s=2*repmat(Net.si.^2,N,1);
#v=exp(-D./s);
#v2=v.*repmat(w./(si.^2),N,1);
#%v3 
  v3=matrix(do.call(rbind, replicate(d,v2, simplify=FALSE)),nrow=N);
  u_row= matrix(t(Net$u),nrow=1);
#v3=reshape(repmat(v2,d,1),N,d*M);
#u_row=reshape(Net.u',1,M*d);
  dx_u = do.call(cbind, replicate(M,x , simplify=FALSE)) -
    do.call(rbind, replicate(N,u_row , simplify=FALSE));
  gu = v3*dx_u;
#dx_u=repmat(x,1,M) - repmat(u_row,N,1);
#gu=v3.*dx_u;
#% gsi
  v2 = v*do.call(rbind, replicate(N,w/(si^3) , simplify=FALSE));
  gsi = v2*D;
#v2=v.*repmat(w./(si.^3),N,1);
#gsi=v2.*D;
#%gw0
  gw0=matrix(1,nrow=N);
  gw=v;
#gw0=ones(N,1);
#gw=v;
  gtheta = cbind(gu,gsi,gw0,gw);
  return(gtheta)
#gtheta=[gu gsi gw0 gw];
}