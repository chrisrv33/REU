#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --mem=40G
#SBATCH --output=gc%j.stdout
#SBATCH --error=gc%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="gc12mer"
#SBATCH -p koeniglab

INFILE=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/12-mer/combined_kmers/aggregates/O_sativa_12mers.txt
OUTFILE=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/12-mer/combined_kmers/aggregates/O_sativa_12mers_annot_GC.txt

# update software to python3
module unload miniconda2
module load miniconda3
conda create -n NewEnv3 python=3.6.4 # create new environment

# activate new envt
source activate NewEnv3

python annot_mers_gc_content.py $INFILE $OUTFILE