#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=32G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="count kmers"
#SBATCH --array=5-20
#SBATCH -p koeniglab

module load jellyfish/2.2.9

cd ..
cd data

jellyfish count -m $SLURM_ARRAY_TASK_ID -o "kmer_intergenic"_"$SLURM_ARRAY_TASK_ID".jf -s 3G -t 4 -C intergenic.fasta
jellyfish dump -c "kmer_intergenic"_"$SLURM_ARRAY_TASK_ID".jf > "kmer_intergenic"_"$SLURM_ARRAY_TASK_ID".txt

jellyfish count -m $SLURM_ARRAY_TASK_ID -o "kmer_CDS"_"$SLURM_ARRAY_TASK_ID".jf -s 3G -t 4 -C CDS.fasta
jellyfish dump -c "kmer_CDS"_"$SLURM_ARRAY_TASK_ID".jf > "kmer_CDS"_"$SLURM_ARRAY_TASK_ID".txt

jellyfish count -m $SLURM_ARRAY_TASK_ID -o "kmer_reference"_"$SLURM_ARRAY_TASK_ID".jf -s 3G -t 4 -C Oryza_sativa.IRGSP-1.0.dna.toplevel.fa
jellyfish dump -c "kmer_reference"_"$SLURM_ARRAY_TASK_ID".jf > "kmer_reference"_"$SLURM_ARRAY_TASK_ID".txt

jellyfish count -m $SLURM_ARRAY_TASK_ID -o "kmer_repbase"_"$SLURM_ARRAY_TASK_ID".jf -s 3G -t 4 -C oryrep.ref
jellyfish dump -c "kmer_repbase"_"$SLURM_ARRAY_TASK_ID".jf > "kmer_repbase"_"$SLURM_ARRAY_TASK_ID".txt

rm "kmer_intergenic"_"$SLURM_ARRAY_TASK_ID".jf
rm "kmer_CDS"_"$SLURM_ARRAY_TASK_ID".jf
rm "kmer_reference"_"$SLURM_ARRAY_TASK_ID".jf
rm "kmer_repbase"_"$SLURM_ARRAY_TASK_ID".jf
