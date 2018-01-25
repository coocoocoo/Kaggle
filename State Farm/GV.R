#2016/05/30
#using for compute gradient vector
GV <- function(img){
  rad2deg <- function(rad) {(rad * 180) / (pi)}
  deg2rad <- function(deg) {(deg * pi) / (180)}
  img.row = dim(img)[1]
  img.col = dim(img)[2]
  #gradient vectors
  #gv.x           : gradient vector along x direction
  #gv.y           : gradient vector along y direction
  #gv.angle       : arctanh(x/y) by angle
  #gv.maginitude  : gradient vector's magintude
  gv.x <- gv.y <- gv.angle <- gv.magnitude <- matrix(nrow = img.row,ncol = img.col)
  t.img <- matrix(data=0,nrow = img.row+2,ncol = img.col+2)
  t.img[2:(dim(t.img)[1]-1),2:(dim(t.img)[2]-1)] <- img
  for(i in 1:img.row){
    for(j in 1:img.col){
      gv.x[i,j] <- t.img[i+1,j+2]-t.img[i+1,j]
      gv.y[i,j] <- t.img[i+2,j+1]-t.img[i,j+1]
      gv.angle[i,j] <- rad2deg(atan((gv.x[i,j]+0.00001)/(gv.y[i,j]+0.00001)))
      gv.magnitude[i,j] <- sqrt(gv.x[i,j]^2 + gv.y[i,j]^2)
    }
  }
  #turn the angle ranger from [-90,90] to [0,180]
  gv.angle <- gv.angle + 90;
  gv = list(x = gv.x, y = gv.y, angle = gv.angle,magnitude = gv.magnitude)
  return(gv)
}



#other try 2016/05/30
#if(j-1 == 0){
#  gv.x[i,j] <- img[i,j+1]
#}else if(j+1 > img.col){
#  gv.x[i,j] <- -img[i,j-1]
#}else if(i-1 == 0){
#  gv.y[i,j] <- img[i+1,j]
#}else if(i+1 > img.row){
#  gv.y[i,j] <- -img[i-1,j]
#}else{
#  gv.x[i,j] <- img[i,j+1]-img[i,j-1]
#  gv.y[i,j] <- img[i+1,j]-img[i-1,j]
#}