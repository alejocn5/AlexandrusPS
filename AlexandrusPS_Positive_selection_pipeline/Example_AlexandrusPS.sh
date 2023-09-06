#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -i Working directory"
   echo -e "\t-i Working directory, FASTA input files will be copied to this location"
   exit 1 # Exit script after printing help
}

# pasre arguments from the command line - working directory for example to run in (outside container)
while getopts "i:" opt
do
    case "$opt" in
        i) input="$OPTARG";;
		?) helpFunction ;; # print helpfunction
    esac
done

echo "input: $input";

# make output folder
mkdir $input/output

#copy fasta files to outside of container to working directory passed by user
cp ./Example/*.fasta $input/.

sh AlexandrusPS.sh -i $input -o $input/output

# FastaSeq=./Fasta/*.pep.fasta
# 	mkdir ./Curated_Sequences
# 	mkdir ./Orthology_Prediction
# for Fsq in $FastaSeq
# 	do
#  	FAS=`basename $Fsq`
#  	F=$(echo "$FAS" | sed -nE 's/(.*)(\.pep\.fasta)/\1/p') 
#  	echo "$F"
# 	perl ./Code/APS1_Fasta_Name_correction.pl ./Fasta/$F.pep.fasta ./Fasta/$F.dna.fasta
# 	mv *.cur.pep.fasta ./Orthology_Prediction/.	

# done
# 	mv Specie_name_index_directory.txt ./Curated_Sequences/.
# 	mv CompiledSpecies.dna.fasta ./Curated_Sequences/.
# 	mv CompiledSpecies.pep.fasta ./Curated_Sequences/.
	

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