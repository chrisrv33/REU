
library("ggplot2")
library(plyr)

raw<-read.table("gene_names.txt")
raw$V2="gene"
colnames(raw)<-c("feature", "annotation")
raw$V3="gene"
  
rep<-read.table("O_sativa_repbase.txt", sep = "\t")
rep$V3=NULL
colnames(rep)<-c("feature", "annotation")
rep$V3="repeats"

var<-read.table("ordered_var.txt", header = T)

f<-rbind(raw, rep)
m<-merge(f, var, by = "feature")


# Density plot
mu <- ddply(m, "V3", summarise, grp.median=median(log(variance))) # find means
plot<-ggplot(m) + geom_density(aes(x=log(variance), group = V3, fill = V3, color=V3), alpha = 0.45) + 
  geom_vline (data=mu, aes(xintercept = grp.median, color=V3), linetype="dashed", size = 1) + 
  scale_color_manual (values = c("violetred", "darkolivegreen")) + 
  scale_fill_manual (values = c("plum3", "darkseagreen3")) + theme_classic() +
  theme(text=element_text(size=16), axis.text = element_text(size = 13),
        panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), legend.position = c(0.8, 0.6),
        panel.grid.minor.y=element_blank(), axis.text.x = element_text(), legend.title = element_blank(),
        legend.key.size = unit(1.8, 'lines')) + ylab("Density")
print (plot)
ggsave("density.png", plot , width = 9.5, height = 5.5, units = "in" )
ggsave("density.tiff", plot , width = 9.5, height = 5.5, units = "in" )


# add median to density plot!!


# Boxplot
repeats<-m[m$V3 == "repeats", ]

box<-ggplot(repeats, aes(y=log(variance), x=reorder (annotation, log(variance), FUN = median))) + 
  geom_boxplot(color="darkslategray", fill="darkseagreen3", outlier.size = 1, alpha=0.85) + theme_minimal() + theme(text=element_text(size=23), axis.text = element_text(size = 15), 
                                           panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), 
                                           panel.grid.minor.y=element_blank(), axis.text.x = element_text(angle = 60, hjust = 1)) + 
  xlab("Annotated Repeats")
  
print (box)
ggsave("repeats.png", box, width = 8.65, height = 7.5, units = "in")
ggsave("repeats.tiff", box, width = 8.65, height = 7.5, units = "in")

