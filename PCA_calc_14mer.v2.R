#!/usr/bin/env Rscript

# Install packages for PCA computation
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, rsvd)

# Load normalized & GC-corrected data table
raw<-read.table("/rhome/cvaldez/bigdata/REU/results/gc_correct/O_sativa_14mers_Norm_GC.txt") 

# Produce numerical table
num<-raw[2:nrow(raw) , 3:ncol(raw)] # all-number table
new.num<-t(num) #switch rows into columns, making columns as K-mers and libraries as rows
num.matrix<-apply(as.matrix(new.num),2,as.numeric) # Make data frame as data matrix

# Produce rows (libraries) and columns (K-mers)
col.headers<-as.character(unlist(raw[2:nrow(raw),2])) #  K-mers for columns
row.headers<-as.character(unlist(raw[1,3:ncol(raw)]))  # libraries/accessions for rows

# Change titles of rows and columns
colnames(num.matrix)<-col.headers # Make column titles into K-mers
rownames(num.matrix)<-row.headers # Make row titles into library names

# Compute for PCA
df.pca<-rpca(num.matrix, k=100, center=T, scale=T)

summary(df.pca) 
plot(df.pca)

# percent variance for each component (for scree plot)
per.var<-as.data.frame(cbind(1:10,summary(df.pca)[3,1:50])) # calculate % variance
colnames(per.var)<-c("PC", "PercentVariance")
write.table(per.var, gzfile("/rhome/cvaldez/bigdata/REU/results/pca.values/percentvariance14.txt.gz"), sep="\t", quote=F,row.names=F) # write table out

## get coords out
coord<-as.data.frame(df.pca$x) ## coordinates
write.table(coord, gzfile("/rhome/cvaldez/bigdata/REU/results/pca.values/coords14.txt.gz"), quote=F, sep="\t")

## get rotations out (used for loadings)
rot<-as.data.frame(df.pca$rotation)
write.table(rot, gzfile("/rhome/cvaldez/bigdata/REU/results/pca.values/loading14.txt.gz"), quote=F, sep="\t")

## get eigenvalues out
# ev<-as.data.frame(df.pca$eigvals)
# write.table(ev, gzfile("/rhome/cvaldez/bigdata/REU/results/pca.values/eigvals14.txt.gz"), quote=F, sep="\t")

# get sdev out
# sdev<-as.data.frame(df.pca$sdev)
# write.table(sdev, gzfile("/rhome/cvaldez/bigdata/REU/results/pca.values/sdev14.txt.gz"), quote=F, sep="\t")
