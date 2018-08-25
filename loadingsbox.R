library(data.table)

df<-fread("part_2.txt")
head(df)
names(df)<-c("Feature", "PC1", "Kmers")

df1<-read.delim("O_sativa_repbase.txt", header=F)
head(df1)
names(df1)<-c("Feature", "Class", "Organism")

m<-merge(df, df1, by="Feature")
head(m)

library(ggplot2)

g<-ggplot(m) + geom_boxplot(aes(x=reorder(Class,PC1, FUN=median), y=(PC1)), fill="thistle", color="mediumpurple4") + 
  xlab("Repeat Class") + ylab("PC 1 Loading") + theme_classic() + 
  theme(axis.text.x = element_text(angle = 55, hjust = 1), text=element_text(size=29), axis.text = element_text(size = 20),
        panel.grid.major.x=element_line("grey85")) + 
  scale_y_continuous(labels=function(x)x*10000) + geom_hline(aes(yintercept=0), linetype="dashed", color="grey30", alpha=0.7)

print(g)


ggsave("PC1_loading.png", g, height=9, width=13.5, units="in")
