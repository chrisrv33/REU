#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=250G
#SBATCH --output=gcc%j.stdout
#SBATCH --error=gcc%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="gcc12"
#SBATCH -p koeniglab

R=/rhome/cvaldez/bigdata/REU/scripts/GC_correct.R

Rscript $R 
