#!/bin/bash


pidof -s
	mv $input/Code .
	mv $input/Data .
	mv $input/Example .
	rm -r $input/G0/Orthology_Groups
	mv $input/G0 .
	mv $input/Usage_core_percentage .
	rm -r $input/Curated_Sequences
	rm -r $input/Orthology_Prediction

	
	rm  $input/Fasta/*.fasta
	rm -r $input/LIST
	mkdir $input/LIST
	rm -r $input/Data

	rm  $input/APS6_CoresGenerator.sh
	rm $input/G0/list.txt
	rm -r $input/G0/Orthology_Groups
while read SP
	do

	rm -r $input/G$SP


done < $input/Group.list



	rm $input/Group.list
	rm $input/Results/*
	rm $input/Failed_files/*
	rm $input/Final_table_positive_selection/*
	rm $input/site-specific-analysis.done	
	rm $input/Branch-specific-analysis.done
	rm $input/Results_Branch/*
	rm -r $input/Data
	rm -r $input/Fasta
	rm -r $input/LIST
	rm -r $input/Results
	rm -r $input/Results_Branch
	rm -r $input/Final_table_positive_selection
	rm -r $input/Failed_files
	rm $output/*
Error=Error_missed_sequences.txt
if [ ! -f $Error ]
then
echo "ALL GOOD!\n"
else

echo "HEADERS IN THE AMINO ACID FASTA FILE (CHECK FILE: Error_missed_sequences.txt) DO NOT MATCH WITH THE DNA SEQUENCES\n"
	rm Error_missed_sequences.txt	

fi 


