rm(list=ls())
setwd("E:/Kaggle Competition - 1StateFarm電腦視覺/HOG")

source("rgb2gray.R")
source("rgb2gray2.R")
source("GV.R")
source("logloss.R")
source("GV2.R")
source("GH.R")
source("plotjpeg.R")
install.packages("imager")
library("imager")
install.packages("randomForest")
library("randomForest")
install.packages("e1071")
library("e1071")
install.packages("jpeg")
library('jpeg')
install.packages("MASS")
library("MASS")

# creat training and testing set for learning
# sample.number : number of sample in every calss (there are 10 classes)
sample.number=200
cellsize = 80; blocksize = 2;
for( count.tandg in 1:2){
  h <- c()
  file.name <- list.files("E:/Kaggle StateFarm data/train/c0")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c0/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c1")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c1/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c2")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c2/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c3")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c3/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c4")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c4/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c5")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c5/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c6")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c6/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c7")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c7/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c8")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c8/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  file.name <- list.files("E:/Kaggle StateFarm data/train/c9")
  file.name <- sample(file.name,sample.number)
  for(i in 1:sample.number){
    data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/train/c9/",file.name[i]))
    data.gray <- rgb2gray2(data.rgb)
    rm(data.rgb)
    #plot.jpeg(data.gray)
    gv <- GV2(data.gray)
    h <- rbind(h,GH(gv,cellsize,blocksize))
  }
  if(count.tandg == 1){
    h.t=h
  }else{h.g=h}
  rm(file.name)
  rm(gv)
}
save(h.t, h.g, file="learning-data2000.Rdata")

k=sample.number;
h.tlabel <- c(rep("c0",k),rep("c1",k),rep("c2",k),rep("c3",k),
         rep("c4",k),rep("c5",k),rep("c6",k),rep("c7",k),
         rep("c8",k),rep("c9",k))
h.glabel <- c(rep("c0",k),rep("c1",k),rep("c2",k),rep("c3",k),
         rep("c4",k),rep("c5",k),rep("c6",k),rep("c7",k),
         rep("c8",k),rep("c9",k))
h.tfinal      <- data.frame(h.tlabel,h.t)
h.gfinal      <- data.frame(h.glabel,h.g)####################end generating two paired training data

# After generating data, using RF and SVM to learn the unknown parameters
## RF learning
rf.fit   <- randomForest(formula=h.tlabel~.,data=h.tfinal,ntree=500,proximity=T)
rf.pred  <- predict(object=rf.fit,newdata=h.gfinal,proximity=T)
table(h.glabel,rf.pred)
##  SVM learning
svm.fit  <- svm(formula=h.tlabel~.,data=h.tfinal,probability=TRUE)
svm.pred <- predict(svm.fit,newdata=h.g,probability=TRUE)
table(svm.pred,h.glabel)
#svm.fit  <- svm(formula=h.tlabel~.,data=h.tfinal,probability = TRUE)
#svm.pred <- predict(svm.fit,h.finaltest,probability = TRUE)
p <- attr(svm.pred,"probabilities")
logloss(sqrt(sqrt(sqrt(sqrt(p)))))
#load final competition dataset and test results####################all in one to predict
tic <- proc.time()
h.finaltest <- c()
cellsize = 80; blocksize = 2;
file.name <- list.files("E:/Kaggle StateFarm data/test")
k.count <- 2
for(i in 1:length(file.name)){
  data.rgb <- readJPEG(paste0("E:/Kaggle StateFarm data/test/",file.name[i]))
  data.gray <- rgb2gray2(data.rgb)
  rm(data.rgb)
  #plot.jpeg(data.gray)
  gv <- GV2(data.gray)
  h.finaltest <- rbind(h.finaltest,GH(gv,cellsize,blocksize))
  if(mod(i,10000) == 0){
    save(h.finaltest, file=paste0("final-teating-data",k.count*10000,".Rdata"))
    h.finaltest <- c()
    k.count <- k.count + 1
  }
}
rm(file.name)
rm(gv)
save(h.finaltest, file=paste0("final-teating-data",79726,".Rdata"))
proc.time() - tic
################the RF model using test folder data

load("learning-data2000.Rdata")
k=sample.number;
h.tlabel <- c(rep("c0",k),rep("c1",k),rep("c2",k),rep("c3",k),
              rep("c4",k),rep("c5",k),rep("c6",k),rep("c7",k),
              rep("c8",k),rep("c9",k))
h.glabel <- c(rep("c0",k),rep("c1",k),rep("c2",k),rep("c3",k),
              rep("c4",k),rep("c5",k),rep("c6",k),rep("c7",k),
              rep("c8",k),rep("c9",k))
h.tfinal      <- data.frame(h.tlabel,h.t)
h.gfinal      <- data.frame(h.glabel,h.g)

rf.fit   <- randomForest(formula=h.tlabel~.,data=h.tfinal,ntree=500,proximity=T)
rf.pred  <- predict(object=rf.fit,newdata=h.gfinal)
table(h.glabel,rf.pred)
################ learning SVM ################
svm.fit  <- svm(formula=h.tlabel~.,data=h.tfinal,probability = TRUE)


############################################prediect testing data seperately
test.class=c(10000,20000,30000,40000,50000,60000,70000,79726)
file.name <- list.files("E:/Kaggle StateFarm data/test")
for(i in 1:length(test.class)){
load(paste0("final-teating-data",test.class[i],".Rdata"))
svm.pred <- predict(svm.fit,h.finaltest,probability = TRUE)
svm.pred.prob <- attr(svm.pred,"probabilities")
rm(svm.pred)
#rownames(svm.pred.prob)=file.name[(test.class[i-1]+1):test.class[i]]
write.table(svm.pred.prob, file=paste0("pred-final-teating-data",test.class[i],".csv"), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
rm(svm.pred.prob)
}
#prediect testing data together
test.class=c(10000,20000,30000,40000,50000,60000,70000,79726)
file.name <- list.files("E:/Kaggle StateFarm data/test")
h.allfinaltest=c();
for(i in 1:(length(test.class)-0)){
  load(paste0("final-teating-data",test.class[i],".Rdata"))
  h.allfinaltest=rbind(h.allfinaltest,h.finaltest)
}
## RF testing
namec <- c()
for(i in 1: 1260){
  namec <- c(namec,paste0("X",i))
}
colnames(h.allfinaltest) <- namec
rf.pred  <- predict(object=rf.fit,h.allfinaltest)
rf.pred.prob <- attr(rf.pred,"probabilities")
rm(rf.pred)
#Give row names
rownames(rf.pred.prob)=file.name
write.table(rf.pred.prob, file=paste0("pred-final-teating-data-allrf.csv"), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
rm(rf.pred.prob)
#h.allfinaltest[c(21165,60294,61991),]=0.0001
svm.pred <- predict(svm.fit,h.allfinaltest,probability = TRUE)
svm.pred.prob <- attr(svm.pred,"probabilities")
rm(svm.pred)
# k = which(svm.pred.prob<0.00007)
# svm.pred.prob[k]=0.00007
# min(svm.pred.prob)
rownames(svm.pred.prob)=file.name
write.table(svm.pred.prob.adjust, file=paste0("pred-final-teating-data20160715fourth.csv"), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = FALSE, qmethod = c("escape", "double"),
            fileEncoding = "")
rm(svm.pred.prob)
#if error using this to see the error part
#rownames(h.allfinaltest)=file.name
#write.table(h.allfinaltest, file=paste0("seeseesee.csv"), append = FALSE, quote = TRUE, sep = ",",
#            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
#            col.names = FALSE, qmethod = c("escape", "double"),
#            fileEncoding = "")


#just see simple HOG for one picture
#rm(list=ls())
#setwd("E:/Dropbox/HOG")

#source("rgb2gray.R")
#source("GV.R")
#source("GH.R")
#source("plotjpeg.R")
#library("imager")
#library("randomForest")
#library("e1071")
#library('jpeg')


#data.rgb <- readJPEG("img_1083.jpg")
#data.gray <- rgb2gray(data.rgb)
#rm(data.rgb)
#plot.jpeg(data.gray)
#gv <- GV(data.gray)
#cellsize = 80; blocksize = 6;
#h <- GH(gv,cellsize,blocksize)


