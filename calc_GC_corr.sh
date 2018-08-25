#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --mem=100G
#SBATCH --output=gc%j.stdout
#SBATCH --error=gc%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="calcgc14mer_gccorr"
#SBATCH -p koeniglab

# script for GC corrected table; runs calc_GC.py on python

INFILE=/rhome/cvaldez/results/gc_correct/O_sativa_14mers_Norm_GC.txt
TEMP=/rhome/cvaldez/results/gc_correct/cut.txt
OUTFILE=/rhome/cvaldez/bigdata/REU/results/calc_gc/O_sativa_14mers_GC_corr.txt

# for GC-corrected table, rm GC content column
cut -f2- $INFILE > $TEMP

# update software to python3
module unload miniconda2
module load miniconda3
conda create -n NewEnv3 python=3.6.4 # create new environment

# activate new envt
source activate NewEnv3

python calc_GC.py $TEMP $OUTFILE

rm $TEMP
