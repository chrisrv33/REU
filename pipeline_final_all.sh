#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=40G
#SBATCH --output=pl%j.stdout
#SBATCH --error=pl%j.stderr
#SBATCH --mail-user=chrisrolandvaldez@gmail.com
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH --job-name="pl24,942-25,115"
#SBATCH --array=1-175


# software versions
# samtools 1.8; trimmomatic 0.36; bedtools 2.27.1; jellyfish 2.2.9; bwa 0.7.17

# load required modules (slurm)
module load trimmomatic/0.36 jellyfish/2.2.9 bedtools/2.27.1 bwa/0.7.17

# make variables for location of PtMt reference, location of picard, trimmomatic, adapter file
WORKINGDIR=..
REFERENCE=/rhome/cvaldez/bigdata/REU/data/reference/Oryza_sativa.IRGSP-1.0.dna.chromosome.Mt.Pt.fa
ADAPTERDIR=/rhome/cvaldez/bigdata/REU/results/adapter
RESULTSDIR=/rhome/cvaldez/bigdata/REU/results
SEQLIST=/rhome/cvaldez/bigdata/REU/data/accession_genomes/11_all_ftp_links.txt

cd $WORKINGDIR # cd to working directory

FILE=$(head -n $SLURM_ARRAY_TASK_ID $SEQLIST | tail -n 1)


if [[ "$FILE" == *"IRIS"* ]] ; then
        LIBTYPE="IRIS" # paired end

        # get basename of file, stripping at "_" just enough to remove "1" and "2"
        NAME=$(basename "$FILE" | cut -d "_" -f1-7)
else
    	LIBTYPE="nonIRIS" # single end
    	
        # get basename of file, enough to remove "1" and "2"
        NAME=$(basename "$FILE" | cut -d "_" -f1-6)

fi

mkdir -pv /scratch/cvaldez/$NAME # making directories
TEMP_DIR=/scratch/cvaldez/$NAME # putting variable to made directory

for i in $(echo $FILE | tr ";" "\n")
        do
          	wget -nv -P $TEMP_DIR "$i"
        done


java -jar $TRIMMOMATIC PE -threads 8 \
$TEMP_DIR/"$NAME"_1.fq.gz $TEMP_DIR/"$NAME"_2.fq.gz \
$TEMP_DIR/"$NAME"_1_trimmed_paired.fq.gz $TEMP_DIR/"$NAME"_1_unpaired.fq.gz \
$TEMP_DIR/"$NAME"_2_trimmed_paired.fq.gz $TEMP_DIR/"$NAME"_2_unpaired.fq.gz \
ILLUMINACLIP:"$ADAPTERDIR"/PE_all.fa:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36

       	# map to mitochondria and plastid genomes (cat'd together)
bwa mem -t 8 -M $REFERENCE $TEMP_DIR/"$NAME"_1_trimmed_paired.fq.gz $TEMP_DIR/"$NAME"_2_trimmed_paired.fq.gz > $TEMP_DIR/"$NAME".s$

# mapping stats
samtools flagstat $TEMP_DIR/"$NAME".sam > $RESULTSDIR/mappingstats/"$NAME"_mapstats.txt

# sam to sorted bam
samtools view -bS $TEMP_DIR/"$NAME".sam | samtools sort -T $TEMP_DIR/temp_Pt - -o $TEMP_DIR/"$NAME".bam

# extract unmapped reads
samtools view -f4 -b $TEMP_DIR/"$NAME".bam > $TEMP_DIR/"$NAME".unmapped.bam

# export unmapped reads from original reads
bedtools bamtofastq -i $TEMP_DIR/"$NAME".unmapped.bam -fq $TEMP_DIR/"$NAME".unmapped.fq

# Count 12-mers
jellyfish count -C -m 12 -s 3G -t 8 -o $TEMP_DIR/"$NAME".jf $TEMP_DIR/"$NAME".unmapped.fq
jellyfish dump -tc $TEMP_DIR/"$NAME".jf > $RESULTSDIR/K-merCounts/all/whole_genome/all_12-mer/pipeline_kmer/"$NAME"_12.txt

# Count 14-mers
# jellyfish count -C -m 14 -s 3G -t 8 -o $TEMP_DIR/"$NAME".jf $TEMP_DIR/"$NAME".unmapped.fq
# jellyfish dump -tc $TEMP_DIR/"$NAME".jf > $RESULTSDIR/K-merCounts/all/whole_genome/14-mer/pipeline_kmer/"$NAME"_14.txt

# clean up
rm -r $TEMP_DIR
