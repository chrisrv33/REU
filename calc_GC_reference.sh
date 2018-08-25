#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --mem=40G
#SBATCH --output=gc%j.stdout
#SBATCH --error=gc%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="calcgc14mer_gccorr"
#SBATCH -p koeniglab

# script for raw table; runs calc_GC.py on python
# double-check the INFILEs!

INFILE=/rhome/cvaldez/data/kmer_count/14mer_reffinal.txt
OUTFILE=/rhome/cvaldez/bigdata/REU/results/calc_gc/O_sativa_14mers_reference.txt

# update software to python3
module unload miniconda2
module load miniconda3
conda create -n NewEnv3 python=3.6.4 # create new environment

# activate new envt
source activate NewEnv3

python calc_GC.py $INFILE $OUTFILE
