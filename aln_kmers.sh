#!/bin/bash

#SBATCH --job-name="aln_mers"
#SBATCH --output=aln%j.stdout
#SBATCH --error=aln%j.stderr
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --ntasks 4
#SBATCH --mem-per-cpu=8gb
#SBATCH -t 02:00:00
#SBATCH -p koeniglab 

module load bowtie/1.1.1 samtools/1.6

REF=/rhome/cvaldez/data/extract_features/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
OUTPUT=/rhome/cvaldez/results/top1K
TOP1K=/rhome/cvaldez/results/pca.values/1000_12mers.txt

## build reference with bowtie
bowtie-build $REF $OUTPUT/Osativa 

## align to ref genome with bowtie, don't allow mismatches and report all alignments, use 4 threads
bowtie -v 0 -p 4 -a -r $OUTPUT/Osativa $TOP1K -S $OUTPUT/output.sam 
	# -S print in SAM format
	# -v is 0 mismatches 
	# -p is threads
	# -a report all alns
	# -r don't build Osativa.3.ewbt etc.. portion of index

## sam to sorted bam
samtools view -bS $OUTPUT/output.sam | samtools sort - -o $OUTPUT/top1K.bam
	
	
# remove this file
# rm $OUTPUT/output.sam 
