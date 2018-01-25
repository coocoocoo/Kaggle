LM_RBF <- function(x,y,M,theta){
  N=dim(x)[1];
  d=dim(x)[2];

  #[N,d]=size(x);
  #if nargin==2
  #M=0;
  #end
  #LM_iniNet_RBF is as following
  #Initialized LM RBF
  if(missing(M)){
    readkey();
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
  #Initialized function end (LM_iniNet_RBF end)
  
  #tag=0;    lambda=0.01;      lambda_old=0;
  #for loop = 1: Net.MaxLoop
  #if tag==0
  #[yhat,D]=evaRBF(x,Net);
  #e = (y-yhat);
  #current_E = e*e'/(2*Net.T);
  #gtheta = derivative_RBF(Net,x,theta,D);
  #G = -(e*gtheta/Net.T)';
  #R = gtheta'*gtheta/Net.T;
  #tag=1;
  #if loop==1
  #%fprintf('current_E=%f\n',current_E);
  #end
  #end
  #dtheta = ((R + eye(size(R))*(lambda-lambda_old))\(-G))';
  #NextTheta = theta + dtheta;
  #[next_yhat,D]=evaRBF(x,Net);
  #next_E = (y-next_yhat)*(y-next_yhat)'/(2*Net.T);
  
  #next_EL = -dtheta*G + lambda*dtheta*dtheta';
  #if (current_E-next_E) > 0.75*next_EL
  #lambda=lambda/2;
  #elseif (current_E-next_E) < 0.25*next_EL
  #lambda =lambda*2;
  #else
  #  lambda_old = lambda;
  #end
  #  
  #  if current_E > next_E
  #  theta = NextTheta;
  #  lambda_old=0;
  #  tag=0;
  #  if lambda >= 4
  #  lambda=1;
  #  if Net.beta < 1.2
  #  Net.beta=Net.beta/0.98;
  #  end
  #  end
  #  if mod(loop,10)==0
  #  fprintf('%d beta=%f lambda =%f next_E=%f EL=%f\n',loop,Net.beta,lambda,next_E,next_EL);
  #  end
  #  if next_E < 10.^(-6) | next_EL < 10.^(-8)
  #  break;
  #  end
  #  end
  #  Net=update_net(Net,NextTheta);
  #  end
  tag=0;    lambda=0.01;      lambda_old=0;
  for( loop in 1:Net$MaxLoop ){
    if(tag == 0){
      tempout=evaRBF(x,Net);
      yhat = tempout$y;
      D = tempout$D;
      rm(tempout);
      e = (y-yhat);
      current_E = t(e)%*%e/(2*Net$T); #?marked 2016/10/08
      gtheta = derivative_RBF(Net,x,theta,D)
      G = -t(t(e) %*% gtheta/Net$T)
      R = t(gtheta) %*% gtheta/Net$T;
      tag=1;
    }
    dtheta.x = (R + diag(1,nrow=dim(R)[1])*(lambda-lambda_old));
    dtheta.y = -G;
    dtheta = t(solve(dtheta.x,dtheta.y)); rm(dtheta.y);rm(dtheta.x);
    NextTheta = theta + dtheta;
    tempout=evaRBF(x,Net);
    next_yhat = tempout$y;
    #next_yhat = round(next_yhat) # force to integer 2016/10/09
    D = tempout$D; rm(tempout);
    next_E = t(y-next_yhat)%*%(y-next_yhat)/(2*Net$T);
    next_EL = -dtheta%*%G + lambda%*%dtheta%*%t(dtheta);
    if ((current_E-next_E) > 0.75*next_EL){
      lambda=lambda/2;
    } else if ((current_E-next_E) < 0.25*next_EL){
      lambda =lambda*2;
    } else {lambda_old = lambda;}
    if(current_E > next_E){
      theta = NextTheta;
      lambda_old=0;
      tag=0;
      if (lambda >= 4) {
        lambda=1;
        if(Net$beta < 1.2){
          Net$beta=Net$beta/0.98;
        }
      }
      if(loop%%10 == 0){
        cat(loop,' beta=',Net$beta,'lambda =',lambda, 'next_E=',next_E, 'EL=',next_EL,'\n');
      }
      if(next_E < 10^(-6) || next_EL < 10^(-8)){
        break;
      }
    }
    Net=update_net(Net,NextTheta);
  }
  tempout=evaRBF(x,Net);
  yhat = tempout$y;
  D = tempout$D;
  rm(tempout);
  e = (y-yhat);
  current_E = t(e)%*%e/(2*Net$T);
  return(list(Net=Net,theta=theta))

#  [yhat,D]=evaRBF(x,Net);
#  e = (y-yhat);
#  current_E = e*e'/(2*Net.T);
#  %fprintf('Final mean half square training error:%f\n',current_E);
}