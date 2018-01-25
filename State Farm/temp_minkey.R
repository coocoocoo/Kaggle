h.tfinal
h.gfinal

lda.fit <- lda(h.tlabel~.,data=h.tfinal)
lda.pred <- predict(lda.fit,h.gfinal[,-1])$class

table(h.gfinal[,1],lda.pred)
