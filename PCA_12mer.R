#!/usr/bin/env Rscript

# Install necessary libraries separately from this script
# install.packages("factoextra")

library("factoextra", "ggplot2")

# Load normalized & GC-corrected data table
raw<-read.table("/rhome/cvaldez/bigdata/REU/results/gc_correct/O_sativa_12mers_Norm_GC.txt") 

# Load admixtures
adm<-read.table("/rhome/cvaldez/bigdata/REU/data/admixture_files/50admix.txt", fill = T, sep = '\t') 
colnames(adm)<- c("accession name", "admixture") # add column titles

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
res.pca<-prcomp(num.matrix)

# Print scree plot (default)
scree<-fviz_eig(res.pca) # Scree plot

print(scree)

# Print PCA (default)
pca<-fviz_pca_ind(res.pca, label="none",
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

print(pca)

# Get coordinates for individuals (accessions)
res.ind <- get_pca_ind(res.pca)
coord.ind<-res.ind$coord

# Get coordinates for variance (K-mers)
res.var <- get_pca_var(res.pca)
coord.var<-res.var$coord

# Get first two columns of coord
coord2dims<-coord.ind[,1:2]
df<-as.data.frame(coord2dims) #convert to data frame
# accessions<-as.data.frame(row.headers) #make row headers into a data frame

# Add admixtures to df
df1<-cbind(df,adm) #combine PCA and admixture table

# Extract variance percentage numbers for PCs
eig.val <- get_eigenvalue(res.pca)
PC1<-round(eig.val[[1,2]], digits=1)
PC2<-round(eig.val[[2,2]], digits=1)
  
# Create plot point 
pt<- ggplot(df1, aes(Dim.1, Dim.2)) +
  geom_point(aes(colour = admixture)) + theme_classic () + 
  scale_color_brewer("Admixture group", palette = "Paired") +
  xlab(paste("PC1 (",PC1, "%)", sep = "" )) + # create label for x-axis 
  ylab(paste("PC2 (",PC2, "% )", sep = "" )) # for y-axis

print(pt)

ggsave("/rhome/cvaldez/bigdata/REU/results/pca/12mer PCA.png", pt)

