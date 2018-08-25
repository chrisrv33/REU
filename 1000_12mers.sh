#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem=40G
#SBATCH --output=12mer%j.stdout
#SBATCH --error=12mer%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="1000_12mer"
#SBATCH -p batch

R=/rhome/cvaldez/bigdata/REU/scripts/post_hoc_analysis/1000_12mers_random.R

Rscript $R 
