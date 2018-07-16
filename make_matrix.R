#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
nm<-args[1]

library(data.table)

## initialize empty table
df1<-data.frame(matrix(nrow=20, ncol=16))
names(df1)<-c(paste0("K", seq(5,20,1)))
row.names(df1)<-c(seq(5,100,5))

## loop over every file
for (i in 5:20){
  nm1<-paste0(nm, i)
  nm1<-paste0(nm1, ".txt")

  df<-fread(nm1)

  df<-df[order(-df$V2),]
  df$cs<-cumsum(as.numeric(df$V2))

  s<-max(cumsum(as.numeric(df$V2)))
  
  df$per<-(df$cs/s)*100
  
  m<-as.data.frame(seq.int(5,100, 5))
  
  m$numb<-apply(m, 1, function(x) which.min(abs(df$per-x)))
  
  df1[,i-4]<-m$numb

  write.table(df1, "K-quantiles_Col-0.txt", row.names=F, quote=F, sep="\t")

}
out<-paste0(nm, "per.txt")

write.table(df1, out, row.names=T, quote=F, sep="\t")

