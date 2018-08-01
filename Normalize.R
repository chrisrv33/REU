#!/usr/bin/env Rscript

# install/ load required libs 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, ggplot2, factoextra, ggfortify, matrixStats, parallel, rsvd)

# start cluster (for parallel function application)
no_cores <- 3
print(paste0("cores = ", no_cores))
cl <- makeCluster(no_cores)
clusterEvalQ(cl, library(data.table))

# read in K-mer counts 
counts<-fread("/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/14-mer/combined_kmers/aggregates/O_sativa_14mers_annot_GC.txt")

# what the data looks like 
dim(counts) 
counts[1:5,1:5]

# remove previously identified outliers 
#drop<-read.table("./results/outliers.txt")
#drop<-as.vector(drop$V1)
#cunts[, c(drop):=NULL]
#dim(counts)

# define normalization function 
NormalizeCPM<-function(column){
  column<-column/sum(as.numeric(column))*1000000
  return(column)
}

# Normalize raw counts to count per million (CPM)
print("normalization")
choose_cols=colnames(counts)[3:length(counts)] # skip first two cols
counts[, (choose_cols):=parLapply(cl,.SD, NormalizeCPM), .SDcols=choose_cols]
counts[1:5,1:5]

fwrite(counts, file="/rhome/cvaldez/bigdata/REU/results/normalize/O_sativa_14mers_norm.txt", sep="\t", quote=F)

stopCluster(cl) 
