#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=50G
#SBATCH --output=pl%j.stdout
#SBATCH --error=pl%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="agg12mer26-50"
#SBATCH -p koeniglab

# this aggregates all files on the concatenated files from combining_files.sh
# make sure to change folders for 12- or 14-mer
# for 14-mers, aggregates were separated to distribute processing
# make sure to make a .txt file of DNA-IDs or filenames to use and edit on $SEQLIST

OUTPUT=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/12-mer/combined_kmers/aggregates
WORKINGDIR=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/12-mer/combined_kmers

SEQLIST=/rhome/cvaldez/bigdata/REU/data/'50accessions.txt'

cd $WORKINGDIR

while read p; do
awk '{
    arr[$1]+=$2
   }
   END {
     for (key in arr) printf("%s\t%s\n", key, arr[key])
   }' "$p".txt \
   | sort +0n -1 > /$OUTPUT/"$p"_agg.txt
done < $SEQLIST

cd $WORKINGDIR
rm *.txt # remove all concatenated files