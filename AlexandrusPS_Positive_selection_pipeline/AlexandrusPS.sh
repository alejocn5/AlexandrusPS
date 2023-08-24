# #!/bin/bash

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


mkdir $input/Fasta
mkdir $input/LIST
mkdir $input/Results
mkdir $input/Results_Branch
mkdir $input/Final_table_positive_selection
mkdir $input/Failed_files

mv ./Code $input
mv ./Data $input
mv ./G0 $input
mv ./Usage_core_percentage $input
cp $input/*.fasta $input/Fasta/.

#STEP 1: Index generator, Name of headers and sequences modification, prepare files for orthology prediction, quality control
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\nSTEP 1: Index generator, Name of headers and sequences modification, prepare files for orthology prediction, quality control\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
 FastaSeq=$input/Fasta/*.pep.fasta
 	echo "\n\n\nPerforming sequences quality control\n\n\n"
	mkdir $input/Curated_Sequences
	mkdir $input/Orthology_Prediction
	nproc > $input/Data/Number_cores.txt

for Fsq in $FastaSeq
	do
 	FAS=`basename $Fsq`
 	F=$(echo "$FAS" | sed -nE 's/(.*)(\.pep\.fasta)/\1/p')
echo "$input/Fasta/$F.pep.fasta $input/Fasta/$F.cds.fasta"
	perl $input/Code/APS1_IndexGenerator_QualityControl.pl $input/Fasta/$F.pep.fasta $input/Fasta/$F.cds.fasta
	mv *.cur.pep.fasta $input/Orthology_Prediction/.
done

	mv CompiledSpecies.cds.fasta $input/Curated_Sequences/.
	mv CompiledSpecies.pep.fasta $input/Curated_Sequences/.
	cp Specie_name_index_directory.txt $output
	mv Specie_name_index_directory.txt $input/Curated_Sequences/.


Error=Error_missed_sequences.txt
if [ ! -f $Error ]
	then
	echo "\n\n\nQUALITY CONTROL (1/2):ALL THE SEQUENCES ARE CANDIDATES FOR THE ANALYSIS!\n\n\n"
else
	echo "\n\n\nQUALITY CONTROL (1/2):SOME OF THE HEADERS IN THE AMINO ACID FASTA FILE (CHECK FILE: Error_missed_sequences.txt) WHERE NOT FOUND THE DNA SEQUENCES\n\n\n"
	echo "\n\n\nthe analysis will continue with the sequences that passed the quality control\n\n\n"
fi 	
	
Errorh=Error_with_Fasta_header.txt
if [ ! -f $Errorh ]
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
	ls
	cd $input/Orthology_Prediction
	ls
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
	ls
	cp ../Code/APS3_CleanProteinOrthoTabe.R .
	ls
	Rscript APS3_CleanProteinOrthoTabe.R
	rm APS3_CleanProteinOrthoTabe.R
	perl ../Code/APS4_OptimalProteinOrthoGroups.pl ProteinOrthoTable.proteinortho.fill
	mv *_.list ../LIST/.
	ls
	cd ../..
	perl $input/Code/APS5_CoreCalculator.pl $input/Data/Number_cores.txt $input/Usage_core_percentage/usage_core_percentage.txt
	cp $input/Code/APS6_CoresGenerator.sh $input/.
	mv ./Group.list $input
	mkdir $input/G0/Orthology_Groups
	cp $input/Curated_Sequences/* $input/G0/Orthology_Groups/.
	 ls $input/LIST/ >> $input/G0/list.txt
	cd $input
	sh APS6_CoresGenerator.sh
else
	 echo "\n\n\nQUALITY CONTOL (2/2):SOME OF THE HEADERS IN THE AMINO ACID OR DNA FASTA FILES ARE EMPTY\n\n\n"
	 echo "\n\n\nthe analysis will ABORT, please check the headers of both files\n\n\n"
fi 	


while read SP
do
	cd ./G$SP/
	screen -S G$SP -d -m  sh Positive_selection.sh
	cd ../
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

	cd ../
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "\n\n\n FINISH!!	\n\n\n"
	echo "============================================================================================================================"
	echo "============================================================================================================================"
	echo "============================================================================================================================\n\n\n"
# copy all output files to user provided output folder
echo "copying files to output folder ..."

cp -R $input/Orthology_Prediction $output/.
cp -R $input/Final_table_positive_selection $output/.
cp -R $input/Results $output/.
cp -R $input/Failed_files $output/.
cp -R $input/Results_Branch $output/.

 echo "All done!"






