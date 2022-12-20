#!/bin/bash

# sudo apt  install expect


#solo hay que cambiar el pad donde estan las secuencias en aminoacidos: /caceronn/Data/Genes_putativos_immune_tunicate/
#echo "ID\tSP\tM0_lnL\tM0_np\tbsM0_lnL\tbsM0_np\tbsM0H0_lnL\tbsM0H0_np\tbsM0H1_lnL\tbsM0H1_np" > ../../../../Branch_models/Branch_models_BranchSite_models_Table.txt
while read LI
 do
list=../Results/_$LI\_.tar.gz

if [ ! -f $list ]
then
	echo "NO"
else
echo "YES"
echo "" > ../LIST/$LI.ttt
mv ../Results/_$LI\_.tar.gz .
tar -xvf _$LI\_.tar.gz
 cd Orthology_Groups/_$LI\_

#STEP 18:  Label single Species for Branch_site analysis.
 perl ../../Code/APS19_TreeGeneratorCombinator.pl _$LI\_.list.pep.fasta.dict.fa.best.nex.cl.head.dnd.GenTree.nex
#STEP 19: Generate parameter files for Branch-Site models
    while read T
    do
    perl    ../../Code/APS20_CreateCtl_ParameterDefParPG_BSM0.pl ../../Data/Parameter_codeml_M0BS.txt ../../Data/Default_par.txt $T
    perl    ../../Code/APS21_CreateCtl_ParameterDefParPG_BSM0H0.pl ../../Data/Parameter_codeml_M2BSH0.txt ../../Data/Default_par.txt $T
    perl    ../../Code/APS22_CreateCtl_ParameterDefParPG_BSM0H1.pl ../../Data/Parameter_codeml_M2BSH1.txt ../../Data/Default_par.txt $T
    done < ./TreeList.txt
    while read F
    do
#STEP 20: Run CODEML
    yes | codeml  codeml_$F\_.bsm0.ctl
    yes | codeml  codeml_$F\_.bsm0h0.ctl
    yes | codeml  codeml_$F\_.bsm0h1.ctl 
    done < ./FileList.txt
    # #echo "ID\tSP\tM0_lnL\tM0_np\tbsM0_lnL\tbsM0_np\tbsM0H0_lnL\tbsM0H0_np\tbsM0H1_lnL\tbsM0H1_np" > ../../../Branch_models/Branch_models_BranchSite_models_Table.txt
    while read F
    do
    echo ""
#STEP 21:  Extract information for calculation of LRT (log ratio tests).    
    perl ../../Code/APS23_ExtractLRTandNP_positiveSelectionBranchSite.pl ./\_$LI\_.sm.mlc ./$F\_.bsm0.mlc ./$F\_.bsm0h0.mlc ./$F\_.bsm0h1.mlc >> ../../../Final_table_positive_selection/Branch_models_BranchSite_models_Table.txt
    done < ./FileList.txt
    cd ../
	tar -czvf \_$LI\_bs.tar.gz \_$LI\_
	rm -r \_$LI\_
    #rm -r ./Orthology_Groups
	mv \_$LI\_bs.tar.gz ../../Results_Branch/.
	cd ..
	rm \_$LI\_.tar.gz
	rm  ../LIST/$LI.ttt
fi    


done < ../Final_table_positive_selection/List_GUPS.txt
cd ../
 [ "$(ls -A ./LIST/)" ] && echo "Not Empty" ||  echo "" > Branch-specific-analysis.done 
