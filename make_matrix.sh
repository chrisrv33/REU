#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=32G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="MATRIX"
#SBATCH -p koeniglab

cd ../data

for i in kmer_CDS_ kmer_intergenic_ kmer_reference_ kmer_repbase_
do
	Rscript ../scripts/make_matrix.R "$i" 
		
done 
