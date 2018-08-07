#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=250G
#SBATCH --output=pca%j.stdout
#SBATCH --error=pca%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="pca14"
#SBATCH -p koeniglab

R=/rhome/cvaldez/bigdata/REU/scripts/PCA_14mer.R

Rscript $R 
