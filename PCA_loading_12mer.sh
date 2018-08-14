#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem=250G
#SBATCH --output=loading%j.stdout
#SBATCH --error=loading%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="loadingplot"
#SBATCH -p koeniglab

R=/rhome/cvaldez/bigdata/REU/scripts/PCA_loading_12mer.R

Rscript $R 
