#!/bin/bash

Rscript AC-B0000164_Filter_proteinOrtho_table.R

perl 0_AC-B0000166_listForPSOirthoOutput_AC163_PO.pl AC-B0000163_POGF_all.proteinortho.fill




mkdir ./Orthology_Groups/_2_
mv ./Orthology_Groups/_2_.list ./Orthology_Groups/_2_/.
perl ./Code/0_AC-C0000001_Extract_Pep_sequences.pl ./Orthology_Groups/All_GF_PepEvidenceHighCoverageNam.pep.fasta ./Orthology_Groups/_2_/_2_.list
perl ./Code/1_AC-C0000001_Extract_Cds_sequences.pl ./Orthology_Groups/All_GF_PepEvidenceHighCoverageNam.cds.fasta ./Orthology_Groups/_2_/_2_.list

#Change Names and create a dictionary
perl ./Code/3_AC-B0000166_HeaderDictionary_pepCDS.pl ./Orthology_Groups/_2_/_2_.list.pep.fasta ./Orthology_Groups/_2_/_2_.list.cds.fasta
#Create Species Tree SpeciesTree.nex
perl ./Code/4_AC-B0000166_CreateSpeciesTree_Ctl.pl ./Orthology_Groups/_2_/_2_.list.pep.fasta.dict
#Peptide aligment
 prank -d=./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa -o=./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa
#Netwick tree
prank -d=./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa -o=./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa -f=nexus
#Convert Fortmat
perl ./Code/5_AC-B0000166_CleanNex_nex_V5.pl ./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa.best.nex

/home/alejandro/Programs/pal2nal.v14/pal2nal.pl ./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa.best.fas ./Orthology_Groups/_2_/_2_.list.cds.fasta.dict.fa -output fasta > ./Orthology_Groups/_2_/_2_.codonalign.fasta

perl ./Code/6_bestSequencesForATree.pl ./Orthology_Groups/_2_/_2_.list.pep.fasta.dict.fa.best.nex.cl.head.dnd
perl ./Code/7_AC-B0000166_CreateCtl_ParameterDefParPG_GT.pl ./Data/Parameter_codeml.txt ./Data/Deault_par.txt _2_
mv codeml_2_.gt.ctl ./Orthology_Groups/_2_/.
perl ./Code/8_AC-B0000166_CreateCtl_ParameterDefParPG_ST.pl ./Data/Parameter_codeml.txt ./Data/Deault_par.txt _2_
mv codeml_2_.st.ctl ./Orthology_Groups/_2_/.
 cd ./Orthology_Groups/_2_/

codeml codeml_2_.gt.ctl
expect "Press Enter to continue" { send "\r" }
codeml codeml_2_.st.ctl
expect "Press Enter to continue" { send "\r" }

mv _2_.st.mlc ../../Results/.
mv _2_.gt.mlc ../../Results/.

cd ../../

tar -czvf ./Results/_2_.tar.gz ./Orthology_Groups/_2_
rm -r ./Orthology_Groups/_2_
