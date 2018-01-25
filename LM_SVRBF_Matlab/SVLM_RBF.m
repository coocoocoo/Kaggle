function [Net,theta]=SVLM_RBF(x,y,M,theta,Net)
[N,d]=size(x);
%Net.max_x=max(max(abs(x)));
%Net.max_y=max(abs(y));
%x=x/Net.max_x;
%y=y/Net.max_y;
% approximating error ?
tag=0;    lambda=0.01;      lambda_old=0;
    for loop = 1: Net.MaxLoop
        if tag==0
            [yhat,D]=evaRBF(x,Net);
            e = (y-yhat);
            current_E = e*e'/(2*Net.T);
            gtheta = derivative_RBF(Net,x,theta,D);
            G = -(e*gtheta/Net.T)';
            R = gtheta'*gtheta/Net.T;
            tag=1;
            if loop==1
                %fprintf('current_E=%f\n',current_E);
            end
        end
        dtheta = ((R + eye(size(R))*(lambda-lambda_old))\(-G))';
        NextTheta = theta + dtheta;
        [next_yhat,D]=evaRBF(x,Net);
        next_E = (y-next_yhat)*(y-next_yhat)'/(2*Net.T);
        next_EL = -dtheta*G + lambda*dtheta*dtheta';
        if (current_E-next_E) > 0.75*next_EL
            lambda=lambda/2;
        elseif (current_E-next_E) < 0.25*next_EL
            lambda =lambda*2;
        else
            lambda_old = lambda;
        end
        
        if current_E > next_E
            theta = NextTheta;
            lambda_old=0;
            tag=0;
            if lambda >= 4
                lambda=1;
                if Net.beta < 1.2
                   Net.beta=Net.beta/0.98;
                end
            end
          if mod(loop,10)==0
            %fprintf('%d beta=%f lambda =%f next_E=%f EL=%f\n',loop,Net.beta,lambda,next_E,next_EL);
          end
          if next_E < 10.^(-6) | next_EL < 10.^(-8)
              break;
          end
        end
        Net=update_net(Net,NextTheta);
    end
    [yhat,D]=evaRBF(x,Net);
    e = (y-yhat);
    current_E = e*e'/(2*Net.T);
    %fprintf('Final mean half square training error:%f\n',current_E);
return

function Net=update_net(Net,theta)
 M = Net.M;
 d = Net.d;

    Net.u=reshape(theta(1:M*d),[d,M])';
    Net.si=theta(M*d+1:M*d+M);
    Net.w0=theta(M*d+M+1);
    Net.w=theta(M*d+M+2:M*d+M+M+1);
return
