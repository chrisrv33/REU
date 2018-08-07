#!/bin/bash -l

# Cut files to get admixtures and DNA IDs

cut -f1,15 Summary_filename.txt > admixtures.txt # extract DNA IDs and admixtures
grep -w -f 50accessions.txt admixtures.txt > 50admix.txt # get only the desired accessions