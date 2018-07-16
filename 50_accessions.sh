# requires coreutils (which includes gshuf)

# install coreutils
brew install coreutils 
	## this will include gshuf
sed '1d' 3000_Rice_Project.txt > accessions.txt
	## remove first row
awk '{ a[$1]++ } END { for (b in a) { print b } }' 3000_Rice_Project.txt > accessions.txt 
	## find all unique values in first column to show accessions
gshuf -n50 accessions.txt > 50_random.txt 
	## used for getting 50 random accessions
grep -f 50_random.txt 3000_Rice_Project.txt > chosen_accessions.txt 
	## chosen accessions were taken from the original file and converted 
awk '{print $3}' chosen_accessions.txt > ftp_links.txt 
	## isolates all FTP addresses

#files are found on /rhome/cvaldez/bigdata/REU/data/accession_genomes
