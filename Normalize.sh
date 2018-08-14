#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=250G
#SBATCH --output=norm%j.stdout
#SBATCH --error=norm%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="norm"
#SBATCH -p koeniglab

R=/rhome/cvaldez/bigdata/REU/scripts/norm_gc_correction/Normalize.R


Rscript $R
