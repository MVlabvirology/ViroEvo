#!/bin/bash

for file in *.gz; do trimmomatic SE -phred33 $file $file.trimmed LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:75 -threads 16; done
for file in *.trimmed; do gzip $file; done

FILES=$(find . -name '*.fa')
for f in $FILES
do
   # build the index
        bowtie2-build $f "${f%%.fa}";
done
wait


for file in *.trimmed.gz;do
python3 ViReMa.py YA.fa $file ${file%.trimmed.gz*}.virema.SAM --MicroInDel_Length 1 --Seed 20 --N 1 --X 8 --Aligner bowtie --Defuzz 3 -BED --Output_Dir ${file%.trimmed.gz*}
done
