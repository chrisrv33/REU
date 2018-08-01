#!/usr/bin/env Rscript

# install/ load required libs 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, ggplot2, matrixStats)

# read in K-mer counts 
counts<-fread("/rhome/cvaldez/bigdata/REU/results/normalize/O_sativa_14mers_norm.txt")

dim(counts)
counts[1:5,1:5]

# Calculate row medians for correction weights  
choose_cols=colnames(counts)[3:length(counts)] # skip first two cols
counts[, med:=rowMedians(as.matrix(.SD)),.SDcols=choose_cols]
meds<-as.data.frame(cbind(counts$GC_content, counts$med))
names(meds)<-c("GC_content", "CPM")
REF<-aggregate(CPM ~ GC_content, meds, sum)
write.table(REF, "/rhome/cvaldez/bigdata/REU/results/gc_correct/gc_bins14.txt", sep="\t", row.names=T, quote=F)
counts$med<-NULL
rm(meds)

# define gc correction function 
CorrectGC<-function(column){
  
  ## aggregate bins 
  gc<-data.table(cbind(counts[,1], column))
  gc<-as.data.frame(gc[,sum(column),by=GC_content])
  names(gc)<-c("GC_content", "column")
                 
  ## Calculate weight
  gc<-merge(REF, gc, by="GC_content")
  
  ## lists like dictionaries 
  weights<-gc$CPM/gc$column 
  names(weights)<-gc$GC_content
  rm(gc)
  
  ## apply weights
  Correction<-as.data.frame(cbind(column, counts[,1]))
  keys<-sapply(Correction[,2], function(x) weights[[as.character(x)]]) # get factors 
  Correction$Cts<-Correction$column*keys # apply correction
  return(Correction$Cts)
}


# do gc correction 
print("correction")
counts[, (choose_cols):=lapply(.SD, CorrectGC), .SDcols=choose_cols]
counts[1:5,1:5]

rm(REF) # purge from RAM

fwrite(counts, file="/rhome/cvaldez/bigdata/REU/results/gc_correct/O_sativa_14mers_Norm_GC.txt", sep="\t", quote=F)
