#!/usr/bin/env Rscript

# Calculate variances for each abundance

library("matrixStats")

# Load df
raw<- read.table("O_sativa_annot_abun.txt", header=T)
df<-raw[,2:ncol(raw)]
dfmat<-as.matrix.data.frame(df)
rows<-as.character(raw[,1])

# Calculate variance
var<-rowVars(dfmat)
var<-as.numeric(var)

# Combine dfs
var.t<-as.data.frame(cbind(rows, var))
colnames(var.t)<-c("feature", "variance")

# Sort variances
var.t$variance<-as.numeric(as.character(var.t$variance))
ordervar<-var.t[order(-var.t$var),]

write.table(ordervar, "ordered_var.txt", sep="\t", quote=F ,row.names=F)
