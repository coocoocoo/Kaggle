rgb2gray2 <- function(img){
  out2 <- 0.21*img[,,1] +0.72*img[,,2] + 0.07*img[,,3]
  return(out2)
}