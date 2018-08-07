library(ggplot2); library(plyr)

# Upload normalized raw table
before<-read.table("O_sativa_12mers_raw.txt", dec=",")
gc.before<-before$V2 # only show GC Content values

# Upload normalized GC-corrected table
after<-read.table("O_sativa_12mers_GC_corr.txt", dec=",")
gc.after<-after$V2 # Only show GC Content values

before.values<-gc.before[2:length(gc.before)] # remove header
after.values<-gc.after[2:length(gc.after)] # remove header

# Put values in a data frame as numbers
bv<-data.frame(as.numeric(as.character(before.values)))
av<-data.frame(as.numeric(as.character(after.values)))

# Combine values into one column table
all.values<-cbind (as.vector(bv), as.vector(av)) # combine both tables into one
colnames(all.values)<- c("Before Correction", "After Correction") # change column titles
one<-stack(all.values, select=c("Before Correction", "After Correction")) # Make a long form
colnames(one)<-c("GC", "Legend")

#Calculate median of each group
mu <- ddply(one, "Legend", summarise, grp.median=median(GC))

# Create density plot
p<-ggplot(one, aes(x=GC, fill=Legend)) + geom_density(alpha=0.4) +  
  labs(title="12-mer GC content comparison",x="GC %", y = "Density") + theme_classic() + 
  coord_cartesian(xlim = c(42, 46)) + 
  theme(plot.title = element_text(hjust = .5), 
        text=element_text(size=16),
        legend.title=element_blank(), 
        legend.position = "bottom",
        legend.spacing.x = unit(0.2, 'inch')) + 
  geom_vline(data=mu, aes(xintercept=grp.median, color=Legend), linetype="dashed", size=1) +
  scale_color_brewer(palette="Set1")

print(p)

ggsave("12mer GC comparison.png", p)

