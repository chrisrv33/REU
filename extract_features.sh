#!/bin/bash

## Extract genomic features from Oryza sativa genome

## Requires santools 1.7 and bedtools v2.27.1

## download genome annotation
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/gff3/oryza_sativa/Oryza_sativa.IRGSP-1.0.39.gff3.gz
	### creates Oryza_sativa.IRGSP-1.0.39.gff3.gz
gunzip Oryza_sativa.IRGSP-1.0.39.gff3.gz

## download reference genome and generate bed format (for exporting sequences)
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
	### creates Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
gunzip Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz
samtools faidx Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
	### intext/extract FASTA
awk 'BEGIN {FS="\t"}; {print $1 FS $2}' Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.fai | grep -vE "Mt|Pt|AP*|Syng*" > genome.bed
	### genome.bed shows chromosomes only; removed the mitoch DNA, chloroplast DNA, and contigs 

## isolate 3'UTR, 5'UTR, CDS and exclude chloroplast and mitochondrial genes and other annotations
grep -E 'CDS|three_prime_UTR|five_prime_UTR' Oryza_sativa.IRGSP-1.0.39.gff3 | grep -vE 'Mt|Pt|gene' > CDS_UTRs_primary.gff
	### to check unique characters in the first field to determine what chromosomes are included, use:
	awk '{ a[$1]++ } END { for (b in a) { print b } }' CDS_UTRs_primary.gff

## only keep primary annotations
python keep_prim_annot.py CDS_UTRs.gff > CDS_UTRs_primary.gff
	### keep_prim_annot.py using python language, check out the template

## isolate CDS
grep "CDS" CDS_UTRs_primary.gff | sort -k1n,1n -k4n,4n > CDS_sorted.gff
	### be careful of how columns are sorted, "1, 11, 12, 13, 2, 20, 21, 3,	4, etc.." To fix this, use n, hence the	code '-k1n,1n -4n, 4n'
bedtools getfasta -fi Oryza_sativa.IRGSP-1.0.dna.toplevel.fa -bed CDS_sorted.gff > CDS.fasta

## isolate 3'UTRs
grep "three_prime_UTR" CDS_UTRs_primary.gff | sort -k1n,1n -k4n,4n > three_prime_UTR_sorted.gff
bedtools getfasta -fi Oryza_sativa.IRGSP-1.0.dna.toplevel.fa -bed three_prime_UTR_sorted.gff > three_prime_UTR.fasta

## isolate 5' UTRs
grep "five_prime_UTR" CDS_UTRs_primary.gff | sort -k1n,1n -k4n,4n > five_prime_UTR_sorted.gff
bedtools getfasta -fi Oryza_sativa.IRGSP-1.0.dna.toplevel.fa -bed five_prime_UTR_sorted.gff > five_prime_UTR.fasta

## extract intergenic regions
awk '$3 == "gene" {print}' Oryza_sativa.IRGSP-1.0.39.gff3 | grep -vE 'mRNA|ChrC|ChrM|Pt|Mt' | sort -k1n,1n -k4n,4n > genes_sorted.gff
	### extracted genes and sorted them
bedtools complement -i genes_sorted.gff -g genome.bed > targets.bed
bedtools getfasta -fi Oryza_sativa.IRGSP-1.0.dna.toplevel.fa -bed targets.bed > intergenic.fasta

## extract introns
sort -k1n,1n -k4n,4n CDS_UTRs_primary.gff > CDS_UTRs_primary_sorted.gff ## CDS
bedtools complement -i CDS_UTRs_primary_sorted.gff -g genome.bed > targets.bed 
	### regions not in CDS
bedtools intersect -a targets.bed -b genes_sorted.gff |sed 's/Chr//' > introns.bed 
	### intersect regions not in CDS and within genes (introns)
bedtools getfasta -fi Arabidopsis_thaliana.TAIR10.dna.toplevel.fa -bed introns.bed > introns.fasta


