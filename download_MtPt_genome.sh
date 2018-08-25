#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=40G
#SBATCH --output=pl%j.stdout
#SBATCH --error=pl%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="download"
#SBATCH -p koeniglab

cd ../data/reference

wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.chromosome.Pt.fa.gz
gunzip Oryza_sativa.IRGSP-1.0.dna.chromosome.Pt.fa.gz

wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.chromosome.Mt.fa.gz
gunzip Oryza_sativa.IRGSP-1.0.dna.chromosome.Mt.fa.gz

rm *.fa.gz

cat *.fa > Oryza_sativa.IRGSP-1.0.dna.chromosome.Mt.Pt.fa
