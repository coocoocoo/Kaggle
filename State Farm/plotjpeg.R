library("jpeg")
plot.jpeg <- function(jpg){
  res <- dim(jpg)[1:2]
  plot(0,0,xlim=c(0,res[2]),ylim=c(0,res[1]),type='n',xlab='',ylab='')
  rasterImage(jpg,0,0,res[2],res[1])
}












