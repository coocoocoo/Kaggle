rgb2gray <- function(img){
  out <- matrix(nrow = dim(img)[1],ncol = dim(img)[2])
  for( i in 1:dim(img)[1]){
    for( j in 1:dim(img)[2]){
      #luminosity method 0.21 R + 0.72 G + 0.07 B
      out[i,j] = 0.21*img[i,j,1] + 0.72*img[i,j,2] + 0.07*img[i,j,3]
    }
  }
  return(out)
}