#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

# whole genome (used to determine proportion)
all<-read.table("kmer_reference_per.txt")

s<-all[20,] # the last row of the 'all' table; the sum of counts in reference genome for each mer 

# CDS only 
CDS<-read.table("kmer_CDS_per.txt")
CDS<-CDS[20,] # clobber/overwrite the complete CDS table into just the sum
CDS<-as.data.frame(mapply("/", list(CDS),list(s),SIMPLIFY=FALSE)) # divide CDS/s to get proportion
CDS$Cat<-"CDS" # add Category CDS on the last end for identification (for merging later on)
  
# Intergenic only 
InGen<-read.table("kmer_intergenic_per.txt")
InGen<-InGen[20,]
InGen<-as.data.frame(mapply("/", list(InGen),list(s),SIMPLIFY=FALSE)) # InGen/s
InGen$Cat<-"Intergenic"

# Repbase only 
RepBase<-read.table("kmer_repbase_per.txt")
RepBase<-RepBase[20,]
RepBase<-as.data.frame(mapply("/", list(RepBase),list(s),SIMPLIFY=FALSE)) # RepBase/s
RepBase$Cat<-"RepBase"

# merging tables
a<-merge(InGen, CDS, all=T) # merges InGen and CDS table into one list; merge function can only do two lists at a time
a1<-merge(a,RepBase, all=T) # merges table a (InGen & CDS) and RepBase
write.csv(a1, "prop_merged.csv") # for lab notebook purposes

## test to subset data (zoom in from 7-14 mer)
a1test<-a1[1:3,c(3:10,17)]

mtest<-melt(a1test, id.vars=c("Cat")) # transforms a1 into long form table
mtest$variable<-as.integer(sub('K', '', mtest$variable)) # changes kmers into actual numbers e.g. from 'K5' to '5'

gtest<-ggplot(mtest) + geom_line(aes(x=variable, y=value, group=Cat, colour=Cat)) + xlab("K") + ylab("Proportion of Total K-mers") + theme_minimal() + theme(text=element_text(size=14), panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank()) + labs(colour="") + scale_x_continuous(breaks = seq(min(mtest$variable), max(mtest$variable), by = 1)) + coord_cartesian(ylim = c(0.75, 1))
ggsave("7 to 14 prop.png", gtest)

bye# melt
m<-melt(a1, id.vars=c("Cat")) # transforms a1 into long form table
m$variable<-as.integer(sub('K', '', m$variable)) # changes kmers into actual numbers e.g. from 'K5' to '5'
  
g<-ggplot(m) + geom_line(aes(x=variable, y=value, group=Cat, colour=Cat)) + xlab("K") + ylab("Proportion of Total K-mers") + theme_minimal() + theme(text=element_text(size=14), panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank()) + labs(colour="") + scale_x_continuous(breaks = seq(min(m$variable), max(m$variable), by = 1))
ggsave("gtest.png", g)

# make proportions of matrices in numeric form
InGen1<-as.numeric(InGen[1:16]) # make proportions in which values are only in numerical form from 1-15 (short form format)
CDS1<-as.numeric(CDS[1:16]) 
RepBase1<-as.numeric(RepBase[1:16]) 

# Difference between CDS and InGen
dif<-abs(CDS1-InGen1) # subtract InGen from CDS to get difference
names(dif)<-seq(1:length(dif)) + 4 # names of row titles are sequenced 5-20
dif<-as.data.frame(dif) # add "dif" as a header column name
dif$mer<-row.names(dif) # added a mer column and added the 5-20 as data points
names(dif)<-c("difference", "mer") # changed column headers as "difference" and mer (originally "dif" and mer)
dif$difference<-as.numeric(dif$difference) # make the "difference" column be in numeric form
dif$mer<-as.numeric(dif$mer) # make the "mer" column be in numeric form

p<-ggplot(dif) + ylab("abs(CDS - Intergenic)") +  geom_line(aes(x=mer, y=difference, group=1)) + scale_x_continuous(breaks = seq(min(m$variable), max(m$variable), by = 1)) + theme_minimal() + theme(text=element_text(size=14), panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank())
ggsave("CDS InGen dif.png", p)


# Difference between CDS and RepBase
dif<-abs(CDS1-RepBase1) # subtract CDS from RepBase to get difference
names(dif)<-seq(1:length(dif)) + 4 # names of row titles are sequenced 5-20
dif<-as.data.frame(dif) # add "dif" as a header column name
dif$mer<-row.names(dif) # added a mer column and added the 5-20 as data points
names(dif)<-c("difference", "mer") # changed column headers as "difference" and mer (originally "dif" and mer)
dif$difference<-as.numeric(dif$difference) # make the "difference" column be in numeric form
dif$mer<-as.numeric(dif$mer) # make the "mer" column be in numeric form

q<-ggplot(dif) + ylab("abs(CDS - RepBase)") +  geom_line(aes(x=mer, y=difference, group=1)) + scale_x_continuous(breaks = seq(min(m$variable), max(m$variable), by = 1)) + theme_minimal() + theme(text=element_text(size=14), panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank())
ggsave("CDS RepBase dif.png", q)


# Difference between InGen and RepBase
dif<-abs(InGen1-RepBase1) # subtract InGen from RepBase to get difference
names(dif)<-seq(1:length(dif)) + 4 # names of row titles are sequenced 5-20
dif<-as.data.frame(dif) # add "dif" as a header column name
dif$mer<-row.names(dif) # added a mer column and added the 5-20 as data points
names(dif)<-c("difference", "mer") # changed column headers as "difference" and mer (originally "dif" and mer)
dif$difference<-as.numeric(dif$difference) # make the "difference" column be in numeric form
dif$mer<-as.numeric(dif$mer) # make the "mer" column be in numeric form

r<-ggplot(dif) + ylab("abs(Intergenic - RepBase)") +  geom_line(aes(x=mer, y=difference, group=1)) + scale_x_continuous(breaks = seq(min(m$variable), max(m$variable), by = 1)) + theme_minimal() + theme(text=element_text(size=14), panel.grid.minor.x=element_blank(), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank())
ggsave("InGen RepBase dif.png", r)
