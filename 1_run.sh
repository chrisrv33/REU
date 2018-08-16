#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="abun"
#SBATCH -p batch
#SBATCH --array=51

module unload miniconda2
module load miniconda3

source activate PyEnv

cd ../ # working directory
FEATURES="./data/O_sativa_annotations.fa"
KMER_TABLE="./data/O_sativa_12_mers_Norm_GC.txt"

python ./scripts/001_assign_sequence_score_pipe.py <(cut -f1,${SLURM_ARRAY_TASK_ID} ${KMER_TABLE} | tail -n +2) "$FEATURES" 12 > ./results/parts/part_${SLURM_ARRAY_TASK_ID}.txt 
