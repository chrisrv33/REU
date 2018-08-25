## adopted from https://davetang.org/muse/2013/09/07/creating-a-coverage-plot-in-r/#comment-6973

#install if necessary
source("http://bioconductor.org/biocLite.R")
biocLite("Rsamtools")

#load library
library(Rsamtools)
library(ggplot2)

#read in entire BAM file
bam <- scanBam("top1K.bam")

#names of the BAM fields
names(bam[[1]])
# [1] "qname"  "flag"   "rname"  "strand" "pos"    "qwidth" "mapq"   "cigar"
# [9] "mrnm"   "mpos"   "isize"  "seq"    "qual"

#distribution of BAM flags
table(bam[[1]]$flag)

#function for collapsing the list of lists into a single list
#as per the Rsamtools vignette
.unlist <- function (x){
  ## do.call(c, ...) coerces factor to integer, which is undesired
  x1 <- x[[1L]]
  if (is.factor(x1)){
    structure(unlist(x), class = "factor", levels = levels(x1))
  } else {
    do.call(c, x)
  }
}

#store names of BAM fields
bam_field <- names(bam[[1]])

#go through each BAM field and unlist
list <- lapply(bam_field, function(y) .unlist(lapply(bam, "[[", y)))

#store as data frame
bam_df <- do.call("DataFrame", list)
names(bam_df) <- bam_field

dim(bam_df)

#function for negative strand
check_neg <- function(x){
  if (intToBits(x)[5] == 1){
    return(T)
  } else {
    return(F)
  }
}

#function for positive strand
check_pos <- function(x){
  if (intToBits(x)[3] == 1){
    return(F)
  } else if (intToBits(x)[5] != 1){
    return(T)
  } else {
    return(F)
  }
}

## chrs to loop over, skip Mt and Pt 
chrs<-length(levels(bam_df$rname))
chrs<-12

for (i in 1:chrs){
  print(i)
  chr_neg <- bam_df[bam_df$rname == i & apply(as.data.frame(bam_df$flag), 1, check_neg),'pos']
  length(chr_neg)
  chr_pos <- bam_df[bam_df$rname == i & apply(as.data.frame(bam_df$flag), 1, check_pos),'pos']
  length(chr_pos)
  
  chr_pos<-as.data.frame(chr_pos)
  names(chr_pos)<-"position"
  chr_pos$strand<-"pos"
  
  chr_neg<-as.data.frame(chr_neg)
  names(chr_neg)<-"position"
  chr_neg$strand<-"neg"
  
  title<-paste0("chr", i)
  ## best plot here
  g<-ggplot() + geom_freqpoly(aes(x=chr_neg$position), binwidth=10000) + 
    theme_classic() + geom_freqpoly(aes(x=chr_pos$position), binwidth=10000) + ylim(0,500) +
    xlab("position") + scale_fill_manual(values = c("red")) + 
    theme(text=element_text(size=30), axis.text = element_text(size = 16),
          axis.text.x = element_text(angle = 33, hjust = 1), 
          axis.title = element_text(size = 20)) + ggtitle(title)
  #g<-ggplot() + geom_density(aes(x=chr_neg$position, y = -(..density..))) + geom_density(aes(x=chr_pos$position)) + xlab("position") + ylab("density") + theme_classic() + theme(text=element_text(size=14)) + ggtitle(title) 
  ggsave(paste(title, ".png"), plot=g, width = 3, height = 4.5, units = "in")
}
 