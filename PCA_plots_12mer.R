#!/usr/bin/env Rscript

# Creates scree plot, PCA
# install.packages("scales")
library("ggplot2", "scales", "dplyr")
library("RColorBrewer")

# Load data table for scree plot
pvar<-read.table(gzfile("/rhome/cvaldez/results/pca.values/percentvariance12.txt.gz"))[2:11,]
colnames(pvar)<-c("PC", "PercentVariance")
x<-pvar$PercentVariance # isolate variances to convert to percentage
xnum<-as.numeric(as.character(x)) 
y<-xnum*100 # convert to percent
pvarnew<-cbind(pvar,y) # combine to prev. df
pvar.t<-pvarnew[,-2] # remove old data
colnames(pvar.t)<-c("PC", "PercentVariance")
pvar.t<-as.data.frame(pvar.t) # Final table for scree plot

pvarcsum<-pvar.t
pvarcsum[,2]<-cumsum(pvar.t[,2]) # Creates cumulative sum of percentvariance

# Scree plot
scree <- ggplot(pvar.t, aes(x=PC, y=PercentVariance), group=1) + 
  geom_bar(stat = "identity", fill="darkseagreen3", size = 1, alpha = 0.5) + theme_minimal() +
  theme(panel.grid.major.x = element_blank(), text = element_text(size=17)) +
  scale_x_discrete(limits=pvar$PC) + # makes PCs in numerical order instead of 1,10,2,3...9
  geom_path(group=1, color="darkslategray4", size = 1) + geom_point(color="darkslategrey") + 
  scale_y_continuous(breaks = seq(0, 20, by = 3)) +
  xlab("Principal Component") + ylab("% Variance")

plot(scree)

ggsave("/rhome/cvaldez/results/pca.plots/12mer screetrial.png", scree)

# Load coordinates for PCA
raw.t<-read.table(gzfile("/rhome/cvaldez/results/pca.values/coords12.txt.gz"))[,1:2]

# Load admixtures
adm<-read.table("/rhome/cvaldez/data/admixture_files/50admix.txt", fill = T, sep = '\t') 
colnames(adm)<- c("accession name", "admixture") # add column titles

# Add admixtures to df
raw.f<-cbind(raw.t,adm) #combine PCA and admixture table

# Extract variance percentage numbers for PCs
PC1<-round(pvar.t[[1,2]], digits=1)
PC2<-round(pvar.t[[2,2]], digits=1)
  
# PCA with dashes
pca.d<- ggplot(raw.f, aes(V1, V2)) +
  geom_point(aes(colour = admixture), size=7) + theme_minimal () + 
  scale_color_manual("Admixture group", values = c("#cab2d6","#6a3d9a", "#ffff99",  "#a6cee3",
                                                   "#1f78b4", "#b2df8a", "#33a02c", "#fb9a99", "#e31a1c", "#fdbf6f", "#ff7f00")) + 
  theme(text = element_text(size=30), axis.text = element_text(size = 25), panel.grid.minor = element_blank(),
        panel.grid.major = element_line(colour = "grey70"), legend.key = element_rect(size = 7, color='white'),
        legend.key.size = unit(0.5, 'in')) +
  geom_hline(yintercept=0, linetype="dashed", size=1.5) +
  geom_vline(xintercept=0, linetype="dashed", size=1.5) +
  xlab(paste("PC1 (",PC1, "%)", sep = "" )) + # create label for x-axis 
  ylab(paste("PC2 (",PC2, "% )\n", sep = "" )) # for y-axis

print(pca.d)

ggsave("/rhome/cvaldez/results/pca.plots/12mer PCA dashed.png", pca.d)

# Create PCA without dashes (not used in poster)
pca<- ggplot(raw.f, aes(V1, V2)) +
  geom_point(aes(colour = admixture)) + theme_classic () + 
  scale_color_brewer("Admixture group", palette = "Paired") +
  theme(text = element_text(size=14)) +
  xlab(paste("PC1 (",PC1, "%)", sep = "" )) + # create label for x-axis 
  ylab(paste("PC2 (",PC2, "% )", sep = "" )) # for y-axis

print(pca)

ggsave("/rhome/cvaldez/bigdata/REU/results/pca.plots/12mer PCA.png", pca)


