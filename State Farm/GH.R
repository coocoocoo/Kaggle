#gradient histogram
#input : gradient vector, cell size, blocksize
GH <-function(gv,cellsize,blocksize){
#cell histogram
cell.row <- dim(data.gray)[1]/cellsize
cell.col <- dim(data.gray)[2]/cellsize
h <- matrix(data = 0, nrow = cell.row*cell.col, ncol = 9)
h.count <- 1
for(i in 1:cell.row){
  for(j in 1:cell.col){
    t.gv = list(angle = gv$angle[(cellsize*(i-1)+1):(cellsize*i),(cellsize*(j-1)+1):(cellsize*j)]
                      ,magnitude = gv$magnitude[(cellsize*(i-1)+1):(cellsize*i),(cellsize*(j-1)+1):(cellsize*j)])
    #put them into a 9-bin histogram
    ang <- 10
    count <- 1
    while(ang < 170){
      loc = which(t.gv$angle < (ang+20) & t.gv$angle > ang)
      t.agv <- t.gv$angle[loc]
      t.mgv <- t.gv$magnitude[loc]
      #count boundary between two hist
      p <- (t.agv - (count-1)*20 - 10)*(1/20)
      q <- 1-p
      h[h.count, count+1] <- h[h.count, count+1] + sum(p*t.mgv)
      h[h.count, count] <- h[h.count, count] + sum(q*t.mgv)
      ang <- ang + 20
      count <- count +1
    }
    loc = which(t.gv$angle < 10)
    t.mgv <- t.gv$magnitude[loc]
    h[h.count, 1] = h[h.count, 1] + sum(t.mgv)
    loc = which(t.gv$angle > 170)
    t.mgv <- t.gv$magnitude[loc]
    h[h.count, 9] = h[h.count, 9] + sum(t.mgv)
    h.count <- h.count +1
    #standardized
    #h=h/max(h)
    #hist(gv$angle, breaks = 9, xlim = c(10,170), ylim =c(), prob = T, col = 'light blue', labels= F)
  }
}
#block parts
#resize the h into 3-dim array
h.reshaped <- array(data = h, dim = c(cell.row,cell.col,9), dimnames = NULL)
h.final <- c()
#compute 50% up overlap (if blocksize is 5 there is 60% overlap)
block.row <- seq(1,cell.row-blocksize+1,blocksize-ceiling(blocksize/2))
block.col <- seq(1,cell.col-blocksize+1,blocksize-ceiling(blocksize/2))
for(i in 1:length(block.row)){
  for(j in 1:length(block.col)){
    t.h <- h.reshaped[block.row[i]:(block.row[i]+blocksize-1),block.col[j]:(block.col[j]+blocksize-1),]
    t.h <- t.h/max(t.h)
    h.final <- c(h.final,array(data = t.h,dim = length(t.h)))
    }
}

return(h.final)
}