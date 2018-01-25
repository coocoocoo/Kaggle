#2016/07/15
#a simple eay to calculate logloss
#only suit for 2000 training data within 200 data for each class in y parts
logloss <- function(p){
  N=2000
  y=matrix(data = 0, nrow = 2000, ncol = 10, byrow = FALSE,dimnames = NULL)
  for(i in 1:10){
    y[(200*(i-1)+1):(200*i),i]=1
  }
  p[p==0]=10^-15;
  return(-sum(y*log(p))/N)
}