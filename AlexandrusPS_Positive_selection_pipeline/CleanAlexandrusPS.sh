#!/bin/bash




pidof -s
	rm -r ./Curated_Sequences
	rm -r ./Orthology_Prediction
	
	rm  ./Fasta/*.fasta
	rm -r ./LIST
	mkdir ./LIST
	rm -r ./Data

	rm  APS6_CoresGenerator.sh
	rm ./G0/list.txt
	rm  ./G0/Orthology_Groups/* 
while read SP
	do

	rm -r G$SP


done < ./Group.list

	rm  Group.list
	rm ./Results/*
	rm ./Failed_files/*
	rm ./Final_table_positive_selection/*
	rm site-specific-analysis.done	
	rm Branch-specific-analysis.done
	rm ./Results_Branch/*
Error=Error_missed_sequences.txt
if [ ! -f $Error ]
then
echo "ALL GOOD!\n"
else

echo "HEADERS IN THE AMINO ACID FASTA FILE (CHECK FILE: Error_missed_sequences.txt) DO NOT MATCH WITH THE DNA SEQUENCES\n"
	rm Error_missed_sequences.txt	

fi 

# for l in $list

# list=./Orthology_Groups/*.list


# for l in $list
#         do

# 	LIST=`basename $l`
# 	L=$(echo "$LIST" | sed -nE 's/(.*)(\.list)/\1/p') 
# 	echo "$L"
# 	mkdir ./Orthology_Groups/$L
# 	mv ./Orthology_Groups/$L.list ./Orthology_Groups/$L/.
# 	perl ./Code/0_AC-C0000001_Extract_Pep_sequences.pl ./Orthology_Groups/All_GF_PepEvidenceHighCoverageNam.pep.fasta ./Orthology_Groups/$L/$L.list
# 	perl ./Code/1_AC-C0000001_Extract_Cds_sequences.pl ./Orthology_Groups/All_GF_PepEvidenceHighCoverageNam.cds.fasta ./Orthology_Groups/$L/$L.list

# #Change Names and create a dictionary
# 	perl ./Code/3_AC-B0000166_HeaderDictionary_pepCDS.pl ./Orthology_Groups/$L/$L.list.pep.fasta ./Orthology_Groups/$L/$L.list.cds.fasta
# #Create Species Tree SpeciesTree.nex
# 	perl ./Code/4_AC-B0000166_CreateSpeciesTree_Ctl.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict
# #Peptide aligment
#  	prank -d=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -o=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa
# #Netwick tree
# 	prank -d=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -o=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -f=nexus
# #Convert Fortmat
# 	perl ./Code/5_AC-B0000166_CleanNex_nex_V5.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.nex
# #Run pal2nal.pl
# 	/home/alejandro/Programs/pal2nal.v14/pal2nal.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.fas ./Orthology_Groups/$L/$L.list.cds.fasta.dict.fa -output fasta > ./Orthology_Groups/$L/$L.codonalign.fasta
# #Generate Gen tree
# 	perl ./Code/6_bestSequencesForATree.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.nex.cl.head.dnd
# #Generate Parameter file Gen Tree
# 	perl ./Code/11_AC-B0000166_CreateCtl_ParameterDefParPG_M0.pl ./Data/Parameter_codeml_M0.txt ./Data/Deault_par.txt $L
# 	mv codeml$L.M0.ctl ./Orthology_Groups/$L/.
# #Generate Parameter file Species Tree
# 	perl ./Code/9_AC-B0000166_CreateCtl_ParameterDefParPG_SM.pl ./Data/Parameter_codeml_SM.txt ./Data/Deault_par.txt $L
# 	mv codeml$L.sm.ctl ./Orthology_Groups/$L/.
# 	perl ./Code/10_AC-B0000166_CreateCtl_ParameterDefParPG_SM8.pl ./Data/Parameter_codeml_SM8.txt ./Data/Deault_par.txt $L
# 	mv codeml$L.sm8.ctl ./Orthology_Groups/$L/.
# #Run codeml Gen Tree
# 	cd ./Orthology_Groups/$L/
# 	yes | codeml codeml$L.M0.ctl
# #Run codeml Species Tree
# 	yes | codeml codeml$L.sm.ctl
# 	yes | codeml codeml$L.sm8.ctl
# #Clean
# 	mv $L.sm.mlc ../../Results/.
# 	mv $L.M0.mlc ../../Results/.
# 	mv $L.sm8.mlc ../../Results/.

# 	cd ../../
# 	tar -czvf ./Results/$L.tar.gz ./Orthology_Groups/$L
# 	rm -r ./Orthology_Groups/$L
# done


