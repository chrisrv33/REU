#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=200gb
#SBATCH --output=pp%j.stdout
#SBATCH --error=pp%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --job-name="post14"
#SBATCH -p intel

## TEMP is dir in RAM, WKDIR is directory containing individual K-mer count files, OUT is final merged count file

TEMP=/dev/shm
WKDIR=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/14-mer/combined_kmers/aggregates
OUT=$WKDIR/O_sativa_14mers.txt

## set working directory (where ind. K-mer count files are) 
cd $WKDIR

## join the first two files to make output 
FILE1="$(ls | head -n 1)" # first file
FILE2="$(ls | head -n 2 | tail -n 1)" # second file 

## make a list of the remaining files to iterate through
ls *.txt | tail -n +3 > $TEMP/list."$SLURM_JOB_ID".tmp # does not include 1st 2 files

## convert space to tabs
tr -s ' ' '\t' < "$FILE1" > $TEMP/"$FILE1.tmp"
tr -s ' ' '\t' < "$FILE2" > $TEMP/"$FILE2.tmp"

## sort file by K-mer 
sort $TEMP/"$FILE1.tmp" > $TEMP/"$FILE1.2.tmp"
sort $TEMP/"$FILE2.tmp" > $TEMP/"$FILE2.2.tmp"

## merge first two files to create master
join -1 1 -2 1 -a 1 -a 2 -e 0 -o 0,1.2,2.2 -t $'\t' $TEMP/"$FILE1.2.tmp" $TEMP/"$FILE2.2.tmp" > $TEMP/"$SLURM_JOB_ID".txt

## write header line 
NAME1=$(
if [[ "$FILE1" == *"IRIS"* ]]; then
	basename "$FILE1" | cut -d_ -f1-2
else
	basename "$FILE1" | cut -d_ -f1
fi
) # strip extension from filenames 

NAME2=$(
if [[ $FILE2 == *"IRIS"* ]]; then
	basename "$FILE2" | cut -d_ -f1-2
else
	basename "$FILE2" | cut -d_ -f1
fi
)

HEADER=$(echo "mer""\t""$NAME1""\t""$NAME2")

## remove temporary files
rm $TEMP/"$FILE1.tmp"; rm $TEMP/"$FILE1.2.tmp" ; rm $TEMP/"$FILE2.tmp"; rm $TEMP/"$FILE2.2.tmp" 

NUM="$(ls *.txt | tail -n +3 | wc -l)" # number of remaining files 

for i in `seq 1 $NUM` # do this for remaining files 
	do 
		FILE=$(head -n $i $TEMP/list."$SLURM_JOB_ID".tmp | tail -n 1)
		
		## convert space to tabs 
		tr -s ' ' '\t' < "$FILE" > $TEMP/"$FILE.tmp"
		
		## sort file by K-mer 
		sort $TEMP/"$FILE.tmp" > $TEMP/"$FILE.2.tmp" 
		
		## Merge with master table
		join -1 1 -2 1 -a 1 -a 2 -e 0 -o auto -t $'\t' $TEMP/"$SLURM_JOB_ID".txt $TEMP/"$FILE.2.tmp" > $TEMP/temp."$SLURM_JOB_ID".txt
		mv $TEMP/temp."$SLURM_JOB_ID".txt $TEMP/"$SLURM_JOB_ID".txt 
		
		## append Filename to header line 
		NAME=$(
		if [[ $FILE == *"IRIS"* ]]; then
			basename "$FILE" | cut -d_ -f1-2
		else
			basename "$FILE" | cut -d_ -f1
		fi
		) # grab filename
		
		HEADER="$(echo "$HEADER""\t""$NAME")"
		
		## remove temporary files
		rm $TEMP/"$FILE.tmp"; rm $TEMP/"$FILE.2.tmp"

	done 

## add header line to file 
sed '1s/^/'"$HEADER"'\n/' $TEMP/"$SLURM_JOB_ID".txt > $TEMP/temp."$SLURM_JOB_ID".txt
mv $TEMP/temp."$SLURM_JOB_ID".txt $OUT 

## remove temporary files 
rm $TEMP/list."$SLURM_JOB_ID".tmp $TEMP/"$SLURM_JOB_ID".txt
