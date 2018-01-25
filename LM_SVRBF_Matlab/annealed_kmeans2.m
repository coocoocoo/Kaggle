function [Y Q]=annealed_kmeans2(X,K)
[N d]=size(X);
mean_x = mean(X);
B=0.1;stability=1/K;
Y=rand(K,d)*0.2-0.1+ones(K,1)*mean_x;
HC=0; Q=ceil(rand(N,1)*size(Y,1))';
ep=10^-10;
while ~HC
    if stability < 1/K*2
        Y=Y+rand(K,d)*0.02-0.01;
    end
    D=cross_dis(X,Y);
    U= exp(-B*D);
    S=sum(U,2);
    ind_zero=find(S < ep);
    S(ind_zero)=10^-6;
    n_empty_node=length(ind_zero);
    Q=U./(S*ones(1,K));
    stability=mean(sum(Q.^2,2));
    E=mean(sum(Q.*D.^2,2));
    stability=stability*K/(K-n_empty_node);
    for k=1:K
        a=sum(Q(:,k));
        b=sum(X.*( Q(:,k)*ones(1,d)));
        if a > 0
        Y(k,:) = b/a;
        end
    end
    fprintf('B %f sta %f E %f n %d\n',B,stability,E,n_empty_node);
    if stability > 0.98 
        HC=1; 
    end    
    B=B/0.995;
end



function D=cross_dis(X,Y)
K=size(Y,1);N=size(X,1);
A=sum(X.^2,2)*ones(1,K);
C=ones(N,1)*sum(Y.^2,2)';
B=X*Y';
D=sqrt(A-2*B+C);
