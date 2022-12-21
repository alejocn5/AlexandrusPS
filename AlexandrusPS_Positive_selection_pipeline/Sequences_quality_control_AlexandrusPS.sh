#!/bin/bash




FastaSeq=./Fasta/*.pep.fasta

for Fsq in $FastaSeq
	do
 	FAS=`basename $Fsq`
 	F=$(echo "$FAS" | sed -nE 's/(.*)(\.pep\.fasta)/\1/p') 
	perl ./Code/APS1_IndexGenerator_QualityControl.pl ./Fasta/$F.pep.fasta ./Fasta/$F.dna.fasta
	rm *.cur.pep.fasta 	

done
	rm Specie_name_index_directory.txt
	rm CompiledSpecies.dna.fasta
	rm CompiledSpecies.pep.fasta

Error=Error_missed_sequences.txt
if [ ! -f $Error ]
then
echo "\n\n\nQUALITY CONTOL (1/2):ALL THE SEQUENCES ARE CANDIDATES FOR THE ANALYSIS!\n\n\n"
else

echo "QUALITY CONTOL (1/2):SOME OF THE HEADERS IN THE AMINO ACID FASTA FILE (CHECK FILE: Error_missed_sequences.txt) WHERE NOT FOUND THE DNA SEQUENCES\n"
	

fi 	

Errorh=Error_with_Fasta_header.txt
if [ ! -f $Error ]
	then
	echo "\n\n\nQUALITY CONTOL (2/2):NO EMPTY SEQUENCES OR FILES!\n\n\n"
else
	echo "\n\n\nQUALITY CONTOL (2/2):SOME OF THE HEADERS IN THE AMINO ACID OR DNA FASTA FILES ARE EMPTY\n\n\n"
	echo "\n\n\nthe analysis will ABORT, please check the headers of both files\n\n\n"
fi 

