#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --mem=40G
#SBATCH --output=gc%j.stdout
#SBATCH --error=gc%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="calcgc12mer_gccorr"
#SBATCH -p koeniglab

# script for raw table; runs calc_GC.py on python
# double-check the INFILEs!

INFILE=/rhome/cvaldez/results/KmerCounts/all/whole_genome/12-mer/combined_kmers/aggregates/O_sativa_12mers.txt
OUTFILE=/rhome/cvaldez/bigdata/REU/results/calc_gc/O_sativa_12mers_raw.txt

# update software to python3
module unload miniconda2
module load miniconda3
conda create -n NewEnv3 python=3.6.4 # create new environment

# activate new envt
source activate NewEnv3

python calc_GC.py $INFILE $OUTFILE
