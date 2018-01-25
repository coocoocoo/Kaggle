function D=cross_distance(x,u)
M=size(u,1);N=size(x,1);
D=x*u';
D=-2*D+repmat(sum(x.*x,2),1,M);
D=D+repmat(sum(u.*u,2)',N,1);
%for i=1:N
%    for j=1:M
%        d(i,j)=sum((x(i,:)-u(j,:)).^2);
%    end
%end
%sum(sum(abs(d-D)))