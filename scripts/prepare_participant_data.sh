#/bin/bash

# Run this script from the `participant` directory

#### text files ####

echo "This directory contains the following sub-directories:

- 'covid19' - SARS-CoV-2 data collected in different countries, including genome sequences in FASTA format and their classification as variants of concern in CSV files.
- 'molecules' - text files in 'Protein Data Bank' format, which include information about the atomic structure of different molecules.
- 'sequencing' - gene annotation for an organism in 'GTF' format and a directory with (fake) sequencing data from two runs of the machine; each sample is composed of two files with suffix '_1' and '_2'." > README.txt

echo "Books to read:

- R for Data Science - https://r4ds.had.co.nz/
- Modern Statistics for Modern Biology - https://www.huber.embl.de/msmb/
- Statistical Rethinking - check in the library for the book, but lectures available here: https://www.youtube.com/playlist?list=PLDcUM9US4XdMROZ57-OIRtIK0aOynbgZN
" > things.txt

#### covid19 ####

mkdir coronavirus/variants

# variant tables were pulled from SARS-CoV-2 workshop and not recreated here
# see https://github.com/cambiotraining/sars-cov-2-genomics

# protein sequences were obtained from:
# https://www.ncbi.nlm.nih.gov/nuccore/1798174254
# On the top-right: 
# Send to > Coding Sequences > FASTA protein > Create File
# The output file was named `sequences.txt` and I simplified the name and gzipped the file:
cat sequences.txt | sed 's/.*gene=/>/g' | sed 's/] .*protein=/ protein=/g' | sed 's/] .*//g' | gzip > proteins.fa.gz


#### molecules ####

# data from the original Carpentries lesson
wget https://swcarpentry.github.io/shell-novice/data/shell-lesson-data.zip
unzip shell-lesson-data.zip
mv shell-lesson-data/exercise-data/proteins/ molecules
rm -r shell-lesson-data shell-lesson-data.zip


#### sequencing ####

mkdir -p sequencing/{run1,run2}

# download gene annotation
wget -O sequencing/gene_annotation.gtf.gz http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz

# generate random sequencing reads
wget https://raw.githubusercontent.com/johanzi/fastq_generator/master/fastq_generator.py

# run 1 directory
for i in sampleA sampleB sampleC sampleD
do 
  python fastq_generator.py generate_random_fastq_PE 100 200 > temp.fastq 

  # extract lines before matching `/2` (i.e. read 1)
  # https://askubuntu.com/a/1284775
  sed -n '/\/2/q;p' temp.fastq | gzip > sequencing/run1/${i}_1.fq.gz

  # extract lines after matching `/2` (i.e. read 2)
  # https://stackoverflow.com/a/32569573/5023162
  sed -ne '/\/2/,$ p' temp.fastq | gzip > sequencing/run1/${i}_2.fq.gz
done 

# run 2 directory
for i in sampleE sampleF
do 
  python fastq_generator.py generate_random_fastq_PE 100 200 > temp.fastq 
  sed -n '/\/2/q;p' temp.fastq | gzip > sequencing/run2/${i}_1.fq.gz
  sed -ne '/\/2/,$ p' temp.fastq | gzip > sequencing/run2/${i}_2.fq.gz
done 


rm fastq_generator.py temp.fastq