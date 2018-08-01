## Calculate score for K-mers and append to beginning of line. 
## cjfiscus

## usage
## python annot_mers_gc_content.py InFile.txt OutFile.txt

import sys
import os

filename1=sys.argv[1] # infile 
filename2=sys.argv[2] # outfile 

File=open(filename1,"r") # file containing loadings 
FileOut=open(filename2,"w") # outfile 

LineNum=1 # first line 

for Line in File:
    ## reset score
    content=0

    ## tabulate count of Gs and Cs
    split=Line.split("\t") # split into nucleotides
    nuc=split[0]
    n=list(nuc) 
    
    
    for nuc in n:
        if str(nuc) == "C":
            content = content + 1
        
        elif str(nuc) == "G":
            content = content + 1 
    ## calculate GC content 
    score = (content/len(n))*100
    print(score)
    score = int(score) # integer (this will be binned when plotted)

    ## append score to outfile (skip first line)     
    if LineNum > 1:
    	FileOut.write(str(score)+"\t"+str(Line))
    
    else: 
    	FileOut.write("GC_content\t" + str(Line))
    
    LineNum=LineNum + 1 

## close files 
File.close()
FileOut.close()

