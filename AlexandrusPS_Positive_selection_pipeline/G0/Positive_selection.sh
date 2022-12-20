#!/bin/bash

# sudo apt  install expect



while read LI
do
list=../LIST/$LI


if [ ! -f $list ]
then
	echo "NO"
else
for l in $list
        do
	
	LIST=`basename $l`
	L=$(echo "$LIST" | sed -nE 's/(.*)(\.list)/\1/p') 
	echo "$L"
	echo "" > ../LIST/$LI.ttt
	mkdir ./Orthology_Groups/$L
 	mv ../LIST/$L.list ./Orthology_Groups/$L/.
##STEP 6: For each Orthology group selected in the STEP 3 extract the amino acid and DNA sequences
 	perl ./Code/APS7_Extract_Pep_sequences.pl ./Orthology_Groups/CompiledSpecies.pep.fasta ./Orthology_Groups/$L/$L.list
 	perl ./Code/APS8_Extract_Cds_sequences.pl ./Orthology_Groups/CompiledSpecies.cds.fasta ./Orthology_Groups/$L/$L.list

##STEP 7: simplifies the header of the CDS and amino acid fasta file
	perl ./Code/APS9_HeaderDictionary_pepCDS.pl ./Orthology_Groups/$L/$L.list.pep.fasta ./Orthology_Groups/$L/$L.list.cds.fasta
##STEP 8: Peptide alignment performed by PRANK
  	prank -d=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -o=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa
##STEP 9: Peptide alignment performed by PRANK in nexus format plus phylogenetic tree in nexus format
 	prank -d=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -o=./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa -f=nexus
##STEP 10: Rename and reformat nexus phylogenetic tree of STEP 9
 	perl ./Code/APS10_CleanNex_nex.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.nex
##STEP 11: Run pal2nal
 	/home/alejandro/Programs/pal2nal.v14/pal2nal.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.fas ./Orthology_Groups/$L/$L.list.cds.fasta.dict.fa -output fasta > ./Orthology_Groups/$L/$L.codonalign.fasta
##STEP 12: tree labelling according to branches
 	perl ./Code/APS11_bestSequencesForATree.pl ./Orthology_Groups/$L/$L.list.pep.fasta.dict.fa.best.nex.cl.head.dnd
##STEP 13: Generate parameter files for Site models
	perl ./Code/APS12_CreateCtl_ParameterDefParPG_M0.pl ./Data/Parameter_codeml_M0.txt ./Data/Deault_par.txt $L
	mv codeml$L.M0.ctl ./Orthology_Groups/$L/.
	perl ./Code/APS13_CreateCtl_ParameterDefParPG_SM.pl ./Data/Parameter_codeml_SM.txt ./Data/Deault_par.txt $L
	mv codeml$L.sm.ctl ./Orthology_Groups/$L/.
	perl ./Code/APS14_CreateCtl_ParameterDefParPG_SM8.pl ./Data/Parameter_codeml_SM8.txt ./Data/Deault_par.txt $L
	mv codeml$L.sm8.ctl ./Orthology_Groups/$L/.
##STEP 14: Run CODEML
 	cd ./Orthology_Groups/$L/
	yes | codeml codeml$L.M0.ctl
	yes | codeml codeml$L.sm.ctl
	yes | codeml codeml$L.sm8.ctl
##STEP 15: Quality control of the output from CODEML
perl ../../Code/APS15_quality_check.pl ./$L.sm.mlc ./$L.sm8.mlc ./$L.M0.mlc 
Error=ErrorInTable.txt
##STEP 16: Quality control of the output from CODEML
if [ ! -f $Error ]
then
	echo "TABLE COMPLETE\n"
	pwd
perl ../../Code/APS16_ExtractLRTandNP_positiveSelection.pl ./$L.sm.mlc ./$L.sm8.mlc ./$L.M0.mlc >> ../../../Final_table_positive_selection/PositiveSelectionTable.txt
	cd ../../
	tar -czvf ../Results/$L.tar.gz ./Orthology_Groups/$L
	rm -r ./Orthology_Groups/$L
	rm  ../LIST/$LI.ttt
else
echo "TABLE INCOMPLETE\n"
perl ../../Code/APS16_ExtractLRTandNP_positiveSelection.pl ./$L.sm.mlc ./$L.sm8.mlc ./$L.M0.mlc >> ../../../Failed_files/FailedPositiveSelectionTable.txt
	cd ../../
	tar -czvf ../Failed_files/$L.tar.gz ./Orthology_Groups/$L
	rm -r ./Orthology_Groups/$L
	rm  ../LIST/$LI.ttt
fi
 	done



sleep 2
	fi
done < ./list.txt
cd ../
#STEP 17:  calculation of LRT (log ratio tests)
 [ "$(ls -A ./LIST/)" ] && echo "Not Empty" ||  echo "" > site-specific-analysis.done 

