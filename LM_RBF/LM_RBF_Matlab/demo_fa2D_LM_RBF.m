clear all
fstr=input('input a 2D function: x1.^2+x2.^2+cos(x1) :','s');
fx=inline(fstr);
range=pi;
x1=-range:0.02:range;
x2=x1;
for i=1:length(x1)
        C(i,:)=fx(x1(i),x2);
end
mesh(x1,x2,C);
hold on;
N=input('keyin sample size:');
x(1,:)=rand(1,N)*2*range-range;
x(2,:)=rand(1,N)*2*range-range;
n=rand(1,N)*0.1-0.05;
y=fx(x(1,:),x(2,:))+n;
plot3(x(2,:),x(1,:),y,'.');

max_y=max(y); 
% x : Nxd
% y : 1xN
x=x';
Net=LM_RBF(x,y);
[yhat,D]=evaRBF(x,Net);
mean((y-yhat).^2)/2

    
x_test(1,:)=rand(1,N)*2*range-range;
x_test(2,:)=rand(1,N)*2*range-range;
n=rand(1,N)*0.1-0.05;
y_test=fx(x_test(1,:),x_test(2,:))+n;
x=x_test';
[yhat,D]=evaRBF(x,Net);
mse_TE = ( yhat - y_test ).^2 ;
fprintf(' mean square error for testing %f\n',mean(mse_TE));
figure
plot3(x_test(2,:),x_test(1,:),y_test,'.');hold on;
plot3(x_test(2,:),x_test(1,:),yhat*max_y,'ro');hold on;

x1=-range:0.02:range;
x2=x1;
for i=1:length(x1)
        x_test = [x1(i)*ones(1,length(x2));x2];
        y_test=fx(x_test(1,:),x_test(2,:));
        x=x_test';
        [yhat,D]=evaRBF(x,Net);
        C(i,:)=yhat*max_y;
end
mesh(x1,x2,C);     
    