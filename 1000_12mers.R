#!/usr/bin/env Rscript

# Extract the top 1000 most variable K-mers
library("data.table")

PC1<-fread("/rhome/cvaldez/results/pca.values/loading/loading12.txt")[,1:2] # Load loadings file
PC1<-as.data.frame(PC1)
colnames(PC1)<-c("mer", "PC1")
orderPC1<-PC1[order(-PC1$PC1)[1:1000],1:2] # sort/order loadings value from greatest to least
write.table (orderPC1, "/rhome/cvaldez/results/pca.values/1000_12mers.txt", sep="\t", quote=F,row.names=F)

