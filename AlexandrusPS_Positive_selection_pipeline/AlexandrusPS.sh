#!/bin/bash

#Hi
helpFunction()
{
   echo ""
   echo "Usage: $0 -i Fasta directory -o Output directory"
   echo -e "\t-i Directory containing all FASTA input files"
   echo -e "\t-o Directory to write output of AlexandrusPS"
   exit 1 # Exit script after printing help
}

# pasre arguments from the command line
while getopts "i:o:" opt
do
    case "$opt" in
        i) input="$OPTARG";;
		o) output="$OPTARG";;
		?) helpFunction ;; # print helpfunction
    esac
done
echo "FastaFiles: $input";
echo "input: $input/*.fasta";
echo "output: $output/.";

# copy the input fasta from user to "Fasta" directory
cp $input/*.fasta ./Fasta/.

#STEP 1: Index generator, Name of headers and sequences modification, prepare files for orthology prediction, quality control
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 1: Index generator, Name of headers and sequences modification, prepare files for orthology prediction, quality control\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
FastaSeq=./Fasta/*.pep.fasta
 	echo "\n\n\nPerforming sequences quality control\n\n\n"
	mkdir ./Curated_Sequences
	mkdir ./Orthology_Prediction
	mkdir ./Data
	nproc > ./Data/Number_cores.txt

for Fsq in $FastaSeq
	do
 	FAS=`basename $Fsq`
 	F=$(echo "$FAS" | sed -nE 's/(.*)(\.pep\.fasta)/\1/p')
echo "./Fasta/$F.pep.fasta ./Fasta/$F.cds.fasta"

	perl ./Code/APS1_IndexGenerator_QualityControl.pl ./Fasta/$F.pep.fasta ./Fasta/$F.cds.fasta
	mv *.cur.pep.fasta ./Orthology_Prediction/.
		

done
	mv CompiledSpecies.cds.fasta ./Curated_Sequences/.
	mv CompiledSpecies.pep.fasta ./Curated_Sequences/.
	mv Specie_name_index_directory.txt ./Curated_Sequences/.


Error=Error_missed_sequences.txt
if [ ! -f $Error ]
	then
	echo "\n\n\nQUALITY CONTROL (1/2):ALL THE SEQUENCES ARE CANDIDATES FOR THE ANALYSIS!\n\n\n"
else
	echo "\n\n\nQUALITY CONTROL (1/2):SOME OF THE HEADERS IN THE AMINO ACID FASTA FILE (CHECK FILE: Error_missed_sequences.txt) WHERE NOT FOUND THE DNA SEQUENCES\n\n\n"
	echo "\n\n\nthe analysis will continue with the sequences that passed the quality control\n\n\n"
fi 	
	
Errorh=Error_with_Fasta_header.txt
if [ ! -f $Error ]
	then
	echo "\n\n\nQUALITY CONTROL (2/2):NO EMPTY SEQUENCES OR FILES!\n\n\n"
#STEP 2: Orthology prediction by ProteinOrtho
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 2: Orthology prediction by ProteinOrtho\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"
	cd ./Orthology_Prediction
	ls -I list_of_pepFiles.txt > list_of_pepFiles.txt
	perl ../Code/APS2_ProteinOrthoScriptGenerator.pl list_of_pepFiles.txt 
	sh ProteinOrthoTable_executable.sh
	rm *.cur.pep.fasta*
	rm list_of_pepFiles.txt
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 3: Select the Orthology clusters  suitables for Positive selection analysis\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"

	cp ../Code/APS3_CleanProteinOrthoTabe.R .
	Rscript APS3_CleanProteinOrthoTabe.R
	rm APS3_CleanProteinOrthoTabe.R
	perl ../Code/APS4_OptimalProteinOrthoGroups.pl ProteinOrthoTable.proteinortho.fill
	 mv *_.list ../LIST/.
	cd ..
	perl ./Code/APS5_CoreCalculator.pl ./Data/Number_cores.txt ./Usage_core_percentage/usage_core_percentage.txt
	cp ./Code/APS6_CoresGenerator.sh .
	cp ./Curated_Sequences/* ./G0/Orthology_Groups/.
	 ls ./LIST/ >> ./G0/list.txt
	sh APS6_CoresGenerator.sh

else
	echo "\n\n\nQUALITY CONTOL (2/2):SOME OF THE HEADERS IN THE AMINO ACID OR DNA FASTA FILES ARE EMPTY\n\n\n"
	echo "\n\n\nthe analysis will ABORT, please check the headers of both files\n\n\n"
fi 


while read SP
do
	cd ./G$SP/
	#sh Positive_selection.sh
	screen -S G$SP -d -m  sh Positive_selection.sh
	cd ../
	#screen -d -m sh Positive_selection.sh
	sleep 5


done < ./Group.list
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 4-16: Codon alignment  - Run CODEML -Extract information for calculation of LRT (log ratio tests).\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"

while [ ! -f site-specific-analysis.done ]; do sleep 1; done

	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 17:  calculation of LRT (log ratio tests).\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"

Rscript ./Code/APS18_Calculate_LTR.R
#sh APS17_prove.sh
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 18-21:  Generate parameter files for Branch-Site models - Run CODEML -Extract information for calculation of LRT (log ratio tests)\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"
while read SP
do
	cp ./Final_table_positive_selection/List_GUPS.txt ./G$SP/.	
	cd ./G$SP/
	#sh BranchSiteAnalisys.sh
	screen -S G$SP\_BS -d -m  sh BranchSiteAnalisys.sh
	cd ../
	#screen -d -m sh Positive_selection.sh
	sleep 5


done < ./Group.list

while [ ! -f Branch-specific-analysis.done ]; do sleep 1; done

	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\n STEP 22: calculation of LRT (log ratio tests)	\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"

Rscript ./Code/APS23_BranchSiteAnalysis.R



	

	rm -r ./LIST
	mkdir ./LIST
	rm  APS6_CoresGenerator.sh
	rm ./G0/list.txt
	rm  ./G0/Orthology_Groups/* 
while read SP
	do
	rm -r G$SP
done < ./Group.list
	rm  Group.list
	rm site-specific-analysis.done	
	rm Branch-specific-analysis.done


	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\n FINISH!!	\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"
# copy all output files to user provided output folder
echo "copying files to output folder ..."

cp -R ./Orthology_Prediction $output/.
cp -R ./Final_table_positive_selection $output/.
cp -R ./Data $output/.
cp -R ./Curated_Sequences $output/.
cp -R ./Results $output/.
cp -R ./Results_Branch $output/.

echo "All done!"
#screen -d -m sh CleanAlexandrusPS.sh
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


