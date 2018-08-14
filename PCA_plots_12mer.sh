#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem=250G
#SBATCH --output=pca%j.stdout
#SBATCH --error=pca%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="pca12plot"
#SBATCH -p koeniglab

R=/rhome/cvaldez/bigdata/REU/scripts/PCA_plots_12mer.R

Rscript $R 
