#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=40G
#SBATCH --output=pl%j.stdout
#SBATCH --error=pl%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="14mercmb"
#SBATCH -p koeniglab

#combines all k-mers of all resequences according to its respective DNA-ID or filename

#set to 14 or 12-mer folder
OUTPUT=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/14-mer/combined_kmers
WRKDIR=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/14-mer
SEQLIST=/rhome/cvaldez/bigdata/REU/data/accession_genomes/50accessions.txt

cd $WRKDIR

for s in `cat $SEQLIST` 
	do cat *${s}*.txt > $OUTPUT/$s.txt 
done

