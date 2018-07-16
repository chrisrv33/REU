#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=16G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="download"
#SBATCH -p intel
cd ..
cd data
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/gff3/oryza_sativa/Oryza_sativa.IRGSP-1.0.39.gff3.gz
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz

