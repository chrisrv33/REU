#creates all DNA-IDs/filenames for the chosen 50 accessions

#text of all filenames in the folder 

WORKDIR=/rhome/cvaldez/bigdata/REU/results/K-merCounts/all/whole_genome/12-mer
OUT=/rhome/cvaldez/bigdata/REU/data/accession_genomes

cd $WORKDIR

#list all raw data
ls -I combined_kmers -I all_K-mer.txt > all_K-mer.txt

#isolate all unique IRIS files
grep 'IRIS' all_K-mer.txt > IRIS.txt
cut -d_ -f1-2 IRIS.txt > IRIScut.txt
uniq IRIScut.txt > IRIS.txt

#isolate all unique non-IRIS files
grep -v 'IRIS' all_K-mer.txt > nonIRIS.txt
cut -d_ -f1 nonIRIS.txt > nonIRIScut.txt
uniq nonIRIScut.txt > nonIRIS.txt

#combine all files
cat nonIRIS.txt IRIS.txt > 50accessions.txt
mv 50accessions.txt $OUT

#delete unnecessary files
rm *cut.txt; rm *IRIS.txt ; rm all_K-mer.txt
