#!/usr/bin/env Rscript

# Creates loadings plot
# install.packages("scales")
library("ggplot2", "scales")

# Load data for loading figure
load<-read.table(gzfile("/rhome/cvaldez/results/pca.values/loading12.txt.gz"))[,1:4]
total<-length(load$PC1) # number of N (Kmers)


# PC 1 Loading
loading1<-ggplot(load, aes(x=PC1)) + geom_density(fill="darkseagreen3", alpha=0.5, color = "darkslategray") + theme_classic() + 
  theme(text = element_text(size = 18), panel.grid.major.x = element_line(color = "gray85")) + 
  ylab("Density") + scale_x_continuous(labels=function(n){format(n, scientific = FALSE)}) +
  xlab("PC1 Loadings")

plot(loading1)

ggsave("/rhome/cvaldez/bigdata/REU/results/pca.plots/loading12PC1.png", loading1)

# PC 2 Loading
loading2<-ggplot(load, aes(x=PC2)) + geom_density(fill="darkseagreen3", alpha=0.5, color = "darkslategray") + theme_classic() + 
  theme(text = element_text(size = 18), panel.grid.major.x = element_line(color = "gray85")) + 
  ylab("Density") + scale_x_continuous(labels=function(n){format(n, scientific = FALSE)}) +
  xlab("PC2 Loadings")


plot(loading2)

ggsave("/rhome/cvaldez/bigdata/REU/results/pca.plots/loading12PC2.png", loading2)
