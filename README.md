# AlexandrusPS: a user-friendly pipeline for genome-wide positive selection analysis 
This repository contains procedures and scripts  from AlexandrusPS:
### Introduction

AlexandrusPS is a high-throughput user-friendly pipeline designed to simplify the genome-wide positive selection analysis by deploying well-established protocols of CodeML [[1]](#1). This can be especially advantageous for researchers with no evolutionary or bioinformatics experience.
AlexandrusPS's main aim is to overcome the technical challenges of a genome-wide positive selection analysis such as i) the execution of an accurate orthology analysis as a precondition for positive selection analysis; ii) preparing and organizing configuration files for CodeML; iii)  doing a positive selection analysis on large sets of sequences and iv) generate an output that is easy to interpret including all relevant maximum likelihood (ML) and log ratio test (LRT) results.
The only input data AlexandrusPS needs are the CDS and amino acid sequences of interest. AlexandrusPS provides a simplified output that comprises a table including all relevant results which can be easily extracted for assessment and publication. AlexandrusPS produces and provides all intermediate data such as the results of the ProteinOrtho [[4]](#4) orthology analysis and the multiple alignments. Default parameters of all steps can be adjusted. 
### Requirements
The easiest way to run AlexandrusPS is to use its Docker image. You can download Docker here.

docker pull vivienschoonenberg/alexandrusps:0.6
Available tags can be found here.

How to Docker
Start an interactive bash shell with the alexandrusps container:

docker run --rm -it vivienschoonenberg/alexandrusps:0.6
You will be in proper location to run AlexandrusPS. To quit the container, type 'exit'.

To access local files (necessary), you can mount your home or a different folder in the container:

docker run --rm --mount "type=bind,src=/Users/$(id -un),dst=/app/$(id -un)" -u $(id -u):$(id -g) -it vivienschoonenberg/alexandrusps:0.6 
Here, src is the absolute path to the folder you would like to mount. Dst specifies the folder to be mounted in the "app" directory with your username/id. The app folder contains the AlexandrusPS pipeline as well, which is the folder you automatically enter when starting a container from the image (you can move up to the "app" folder using cd ..).

You can also use the mounted folder in the container to copy any result or output files to your own local system.

### 5 simple steps to run AlexandrusPS

#### Step 1 - Sequence name indexing and quality control 
For each species that you want to include in the analysis two FASTA files should be generated, one with the amino acid sequences and the other one with correspondent CDS sequences (the same as the amino acid sequences but as CDS sequences). It is crucial that both files have the same number of sequences and that each amino acid sequence and the corresponding CDS sequence have the same header. For example: if you want to analyze 6 different species, you should provide 12 FASTA files (6 '.cds.fasta' and 6 ‘.pep.fasta’ files), make sure to follow a similar structure as the example data set in the './Example’ (Fig. 2N) directory, see Figure 1.


![Fig1](https://user-images.githubusercontent.com/44226409/216979380-f96a7ad9-c6e5-446c-b0d5-3f0fa836e743.jpg)

Figure 1- Example sequence files with correct naming 

#### Step 2 - Enter to the main directory of AlexandrusPS (cd ‘./AlexandrusPS’) and paste the sequence FASTA files into the directory ‘./Fasta’.

#### Step 3 - Follow binomial nomenclature rules for naming the FASTA files, this formating ensures the proper functioning of the pipeline. Here a step by step example for human:
*1) Find the scientific name for human in binomial nomenclature ("two-term naming system") in which first term is genus or generic name => Homo and the second term is the specific name or specific epithet => sapiens
*2) Join the two terms by underline (_) => Homo_sapiens
*3) Add the termination character '.cds.fasta' for the CDS file and ‘.pep.fasta’ for the amino acid files = Homo_sapiens.cds.fasta (CDS FASTA file) and Homo_sapiens.pep.fasta (amino acid FASTA file).

Two important considerations are:
i) Both FASTA files need to have the same name, the only difference should be the file extension ('.cds.fasta' and ‘.pep.fasta’).
ii) AlexandrusPS includes the script APS1_IndexGenerator_QualityControl.pl which generates a species name index based on 6 letters from the binomial name - three from the genus (hom) and three from the specific epithet (sap) - resulting in species name index  ‘homsap’. Hence the user should make sure that the file names include only the species name (without special characters besides the mentioned ‘_’) and that the 6 letters do not overlap with the species name index of any other species included in the analysis.

#### Step 4 - Quality control of your sequences (highly recommended to perform before running ./AlexandrusPS.sh)
After you added your sequence FASTA files to the './Fasta’ directory (Fig. 2K)  and before you run AlexandrusPS.sh, we highly recommend to run the script ‘Sequences_quality_control_AlexandrusPS.sh’ (Fig. 2A) to check whether your sequence files ('.cds.fasta' and ‘.pep.fasta’) are suitable for positive selection analysis with AlexandrusPS. In case your sequences (either one or both) are not suitable for AlexandrusPS you will find one or two error files (‘Error_missed_sequences.txt’ (Fig. 3A) and/or ‘Error_with_Fasta_header.txt’') (Fig. 3B) in the main directory in which you executed ‘Sequences_quality_control_AlexandrusPS.sh’ (Fig. 2A). If after running the script none of these files appear it means your sequence files are usable for the analysis. The content of the error files is described and explained in this github repository under the section ‘Troubleshooting errors that you may encounter during quality control’. The quality control is performed by the Perl script  'APS1_IndexGenerator_QualityControl.pl’ which is also called and executed by  ‘Sequences_quality_control_AlexandrusPS.sh’ (Fig. 2A).

Note that this quality control is by default executed by the AlexandrusPS pipeline. The pipeline will continue the analysis with the sequences that pass the quality control even if there are some sequences in ‘Error_missed_sequences.txt’ by excluding these from the analysis. It will however interrupt the process if it finds the file ‘Error_with_Fasta_header.txt’.


![Fig2](https://user-images.githubusercontent.com/44226409/216979602-a10177a7-9d26-4254-889d-bbe031bedeb1.jpg)


Figure 2. Content of the main directory of AlexandrusPS before execution of AlexandrusPS.sh

![Fig3](https://user-images.githubusercontent.com/44226409/216979702-7ec0fe17-46fb-4118-80c0-b14e871baa60.jpg)


Figure 3. Error files A) Not all amino acids sequences in the ‘.pep.fasta’ file are represented in the '.cds.fasta' file,  B) The headers in the ‘.pep.fasta’ and '.cds.fasta' files are different. 


![Fig4](https://user-images.githubusercontent.com/44226409/216979802-f08f75f7-7e2b-43a1-b26c-480fdaae7ef0.jpg)


Fig. 4. Content of the main directory of AlexandrusPS after execution of AlexandrusPS.sh

Troubleshooting errors that you may encounter during quality control
In the quality control step AlexandrusPS looks for two main errors in the FASTA files: 
* i) Not all amino acids sequences in the ‘.pep.fasta’ file are represented in the '.cds.fasta' file, in which case, the script Sequences_quality_control_AlexandrusPS.sh will generate an error file ‘Error_missed_sequences.txt’ (Fig. 3A) with all the peptide sequences which could not be found in the .cds.fasta file.
* ii) The FASTA file is empty or/and contains empty FASTA entries (header but no sequence) or/and the '.pep.fasta' and the '.cds.fasta' files do not contain the same amount of sequences. In case any of these errors occur it will generate an empty file “Error_with_Fasta_header.txt” (Fig. 3B). If you encounter this error file, we recommend that you re-check the FASTA files and in particular the headers of your FASTA files ('.cds.fasta' and ‘.pep.fasta’). In general 1) avoid the use of special characters and 2) try to make your headers as short and simple as possible. 
In case any of these two error files are generated AlexandrusPS will stop execution.

#### Step 5 - After confirming that no error files were generated in step 4, AlexandrusPS can be executed from the main directory by typing ‘./AlexandrusPS.sh’ (Fig. 2D) in terminal.


### Example
To run the example, navigate to the main directory of the pipeline (Fig. 2) in your terminal and start the analysis by typing  './Example_AlexandrusPS.sh’ (Fig. 2B).

This executable will transfer the FASTA files from the example directory to the FASTA directory and execute AlexandrusPS.sh with the example dataset provided together with the pipeline.

The output of this example analysis will include the following result: five of the six protein ortho groups included in the analysis are found to be under positive selection (HLA-DPA1, TLR1, NKG7, CD4, TLR8) and one without positive selection (NUP62CL). 

### AlexandrusPS applications and functionalities
The following explains all the substeps and scripts (in perl or R) that are executed sequentially once AlexandrusPS has been initialized, focusing on:
* 1) Function 
* 2) Input files
* 3) Output
                   
#### SUBSTEP 1: Index generation, FASTA header and sequence modification, preparation of files for orthology prediction and quality control.

**Function:** Some of the downstream programs of the pipeline struggle with lengthy headers or species names. Such problems are circumvented with the script  'APS1_IndexGenerator_QualityControl.pl’ which creates a species name index based on the user-provided binomial name. Using this index the script:
* i) generates FASTA filenames (for .pep.fasta and '.cds.fasta') compatible with other downstream scripts used in AlexandrusPS 
* ii) adds the index to the headers of the sequences in each FASTA file
* iii) generates a species name index directory enabling the user to retrace the association between the used index and the species’ binomial name 
* iv) The new headers of the amino acid FASTA file (‘.cur.pep.fasta’) will be used for orthology prediction
* v) compiles the new headers of all species in one file (CompiledSpecies.pep.fasta and CompiledSpecies.cds.fasta) (Fig. 4C)
* vi) as described before, this SUBSTEP also executes the initial quality control of the sequence files.



**Input files:** Species_1.pep.fasta and Species_1.cds.fasta


**Output:** the output files of  'APS1_IndexGenerator_QualityControl.pl’ will be located in two new directories created by AlexandrusPS: 
* ‘./Curated_Sequences’ which will contain the ‘CompiledSpecies.pep.fasta’ and ‘CompiledSpecies.cds.fasta’ files (Fig. 4C)
* ‘./Orthology_Prediction’ which will contain the ‘.cur.pep.fasta’ files (Fig. 4A).

#### SUBSTEP 2: Orthology prediction by ProteinOrtho [[4]](#4)
**Function:** Executes ProteinOrtho.


**Input files:** In SUBSTEP 1 AlexandrusPS.sh generates a list of the cur.pep.fasta files (list_of_pepFiles.txt) in the './Orthology_Prediction’ directory (Fig. 4A). This list is the only argument for the script ‘./Code/APS1_IndexGenerator_QualityControl.pl’ (Fig. 2M). 


**Output:** ‘./Orthology_Prediction directory/ProteinOrthoTable.proteinortho’ (Fig. 4A)
#### SUBSTEP 3: Selection of the orthology clusters from ProteinOrtho that are suitable for the positive selection analysis
**Function:** Selects ProteinOrtho clusters (orthology groups or OGC) which are suitable for positive selection analysis by the following criteria (produced by  'APS4_OptimalProteinOrthoGroups.pl’): 
* 1) OGC encompassing at least three species 
* 2) 1-to-1 orthologs (absence of paralogs in any species of the orthologous cluster). 
The script extracts the headers of the sequences of the ProteinOrtho clusters which fulfill the requirements for the positive selection analysis, and generates a list with all the ProteinOrtho clusters that will be part of the positive selection analysis. 


**Input files:** Original output table from the ProteinOrtho analysis (ProteinOrthoTable.proteinortho)


**Output:** Filtered table of Proteinortho table with OGCs which fulfill the requirements ('./Orthology_Prediction/ProteinOrthoTable.proteinortho.fill') (Fig. 4A), the list of orthologous gene cluster IDs (OGC_id) and files with the headers of all proteins from each orthologous gene cluster named by OGC_id located in './LIST/[_OGC_id_].list' (Fig. 3H).



#### SUBSTEP 4: Calculation of the correct number of cores that will be used for Alexandrus.sh
**Function:** Find the number of CPU cores that will be used for the AlexandrusPS positive selection analysis part considering the desired usage percentage provided by the user and leaving 2 free cores for continuing normal usage of the computer, thus avoiding a computer system collapse. The executing script is ‘./Code/APS5_CoreCalculator.pl’ (Fig. 2M) and the default usage value is 100%.


**Input files:** In the directory './Usage_core_percentage/usage_core_percentage.txt’ (Fig. 2E) the user can change the desired usage percent (just the number without the percent symbol - defaults to 100).


**Output:** ‘./Data/Number_cores.txt.calculated’ (Fig. 4B), the number of cores to be used results from the formula: 
(desired usage percent) * (number of CPU cores available on the computer - 2) / 100

Fig. 5. Contents of directory G0 (Fig. 2I)
#### SUBSTEP 5: For each Orthology group selected in SUBSTEP 3 extract the CDS sequences
**Function:** In this substep the sequences of the orthologs of all relevant orthologous gene clusters are extracted from the sequence FASTA files that were provided by the user. The resulting files are used for the subsequent alignment of the CDS sequences, a crucial step for the positive selection analysis. The executing scripts are './G0/Code/APS7_Extract_Pep_sequences.pl and’ './G0/Code/APS8_Extract_Cds_sequences.pl’ (Fig. 5A).


**Input files:**  './G0/Orthology_Groups/CompiledSpecies.pep.fasta’, './G0/Orthology_Groups/CompiledSpecies.cds.fasta’ (prepared in SUBSTEP 1) and './G0/Orthology_Groups/[_OGC_id_]/[_OGC_id_].list’ (prepared in SUBSTEP 3) (Fig. 5C).


**Output:** The FASTA files that will be used for the alignments  './G0/Orthology_Groups/[_OGC_id_].list.cds.fasta’ and ‘[_OGC_id_].list.pep.fasta’ (Fig. 5C).

#### SUBSTEP 6: Simplification of the headers of the CDS and amino acid FASTA files

**Function:** The script  'APS9_HeaderDictionary_pepCDS.pl’, generates new amino acid and CDS FASTA files (.dict.fa) with simplified headers leaving just the species name index (see SUBSTEP 2) followed by [_OGC_id_] and a number assigned in the OGC's alignment. It also generates a dictionary associating the new with the old headers (original headers provided by the user), for both amino acid and CDS FASTA files (.fasta.dict).



**Input files:** FASTA files generated in SUBSTEP 5 ([_OGC_id_].list.cds.fasta and [_OGC_id_].list.pep.fasta )



**Output:** 1) Dictionaries: ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict’ and ‘./G0/Orthology_Groups/[_OGC_id_].list.cds.fasta.dict’ 
2) FASTA files: ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa’ and  ‘./G0/Orthology_Groups/[_OGC_id_].list.cds.fasta.dict.fa’ (Fig. 5C)

#### SUBSTEP 7: Peptide alignment performed by PRANK [[2]](#2)
**Function:** CodeML is based on codon alignments, for that reason peptide alignment of all proteins in the respective orthologous groups is performed using PRANK.


**Input files:** './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa’ (prepared in SUBSTEP 6) (Fig. 5C)


**Output:** Alignment files './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.fas’ (Fig. 5C)

#### SUBSTEP 8: Peptide alignment performed by PRANK in nexus format plus phylogenetic tree in nexus format
**Function:** CodeML needs peptide alignment information and phylogenetic gene trees in nexus format. The executing program PRANK provides these formats.
Input : ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa’ (Fig. 5C)


**Output:** ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex’ (Fig. 5C)

#### SUBSTEP 9: Rename and reformat nexus phylogenetic tree of SUBSTEP 8
**Function:** CODEML requires a phylogenetic tree with headers of the FASTA file. As PRANK does not provide this, the script  ‘./G0/Code/APS10_CleanNex_nex.pl’ (Fig. 5A) takes the nexus alignment (‘.best.nex’) of SUBSTEP 9, extracts the phylogenetic tree (‘.best.nex.cl.nex’) and the numeration of each species and the association with the header from the alignment (‘.best.nex.dict’) and replaces the automated numeration generated by PRANK with the header of the FASTA file in the phylogenetic tree (‘.best.nex.cl.head.nex’). The script also changes nexus to dnd format making this compatible with other downstream steps (‘.best.nex.cl.head.dnd’).


**Input files:** nexus file of SUBSTEP 9 ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex’ (Fig. 5C)


**Output:** 
1) Phylogenetic tree from PRANK in nexus format: './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.nex’ (Fig. 5C)
2) Dictionary associating the numeration generated by PRANK with the header of the amino acid FASTA file './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.dict’ (Fig. 5C)
3) Nexus tree with species names:  './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.head.nex’ (Fig. 5C)
4) Format change from nexus to dnd  './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.head.dnd’ (Fig. 5C)
#### SUBSTEP 10: Run pal2nal [[3]](#3)

**Function:** As CodeML is a codon‐based model the multiple sequence alignment of proteins (‘.pep.fasta.dict.fa.best.fas’) and the corresponding CDS (.list.cds.fasta.dict.fa) sequences need to be converted into a codon alignment (.codonalign.fasta). This is achieved using pal2nal.


**Input files:** 
1) Multiple sequence alignments of proteins generated in SUBSTEP 8 './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.fas’
2) CDS sequences generated in SUBSTEP 7 './G0/Orthology_Groups/[_OGC_id_].list.cds.fasta.dict.fa’


**Output:** CDS codon alignment:  './G0/Orthology_Groups/[_OGC_id_].codonalign.fasta’ (Fig. 5C)
#### SUBSTEP 11: Tree labeling according to branches
**Function:** In order to enable branch analysis any tree needs to be provided with the corresponding labels.


**Input files:** './G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.head.dnd’ (Fig. 5C)


**Output:** ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.head.dnd.GenTree.nex’ (Fig. 5C)
#### SUBSTEP 12: Generate configuration files for site-specific models
**Function:** Generates configuration files to run site-specific model analyses that fit seven codon substitution models: M0 (‘'./G0/Code/APS12_CreateCtl_ParameterDefParPG_M0.pl’) (Fig. 5A), M1a, M2a, M3, M7 (‘'./G0/Code/APS13_CreateCtl_ParameterDefParPG_SM.pl’) (Fig. 5A), M8 and M8a (‘'./G0/Code/APS14_CreateCtl_ParameterDefParPG_SM8.pl’) (Fig. 5A). It uses the configuration file './Data/Parameter_codeml_M0.txt’  (for APS12), './Data/Parameter_codeml_SM.txt’  (for APS13)  or ''./G0/Data/Parameter_codeml_SM8.txt’ (for APS14) (Fig. 5B) (these configuration files can be modified by the user) and a default configuration file ('./G0/Data/Default_par.txt) that fills any lacking information in the executed configuration file (./G0/Data/Parameter_codeml_M0.txt) (Fig. 5B).


**Input files:** ‘./G0/Data/Parameter_codeml_M0.txt’ (for APS12) or ‘./G0/Data/Parameter_codeml_SM.txt’ (for APS13) or ’./G0/Data/ Parameter_codeml_SM8.txt’ (for APS13) and ‘./G0/Data/Default_par.txt’ (Fig. 5B)


**Output:** Configuration files './G0/Orthology_Groups/codeml[_OGC_id_].M0.ctl’, './G0/Orthology_Groups/codeml[_OGC_id_].sm8.ctl’ and  './G0/Orthology_Groups/codeml[_OGC_id_].sm.ctl’ (Fig. 5C)
#### SUBSTEP 13: Run CodeML for site-specific models
**Function:** Run CodeML using the configuration files (.ctl) generated in SUBSTEP 12.


**Input files:** Configuration files ‘./G0/Orthology_Groups/codeml[_OGC_id_].M0.ctl’, ‘./G0/Orthology_Groups/codeml[_OGC_id_].sm8.ctl’ and ‘./G0/Orthology_Groups/codeml[_OGC_id_].sm.ctl’ (Fig. 5C)


**Output:** configuration files ‘./G0/Orthology_Groups/codeml[_OGC_id_].M0.mlc’,
‘./G0/Orthology_Groups/codeml[_OGC_id_].sm8.mlc’ and  ‘./G0/Orthology_Groups/codeml[_OGC_id_].sm.mlc’ (Fig. 5C)

#### SUBSTEP 14: Quality control of the CodeML output
**Function:** In cases when CodeML cannot perform the analysis, the output from CodeML does not contain the information necessary for LRT (log ratio tests) calculation. To exclude these instances from the global results output they are marked for exclusion.


**Input files:** All CodeML output files‘./G0/Orthology_Groups/codeml[_OGC_id_].M0.mlc’,
‘./G0/Orthology_Groups/codeml[_OGC_id_].sm8.mlc’ and  ‘./G0/Orthology_Groups/codeml[_OGC_id_].sm.mlc’ (Fig. 5C)







**Output:** In case of missing data  will create a file called ErrorInTable.txt, which is used to condition SUBSTEP 15 
Figure 6. Outputs files in ./Final_table_positive_selection (Fig. 2J) after AlexandrusPS.sh finishes 
#### SUBSTEP 15:  Extract information for calculation of LRTs (log ratio tests) for site-specific models
**Function:** The output files of CodeML (.mlc files) which include the site-specific models performed in SUBSTEP 13 need parsing to extract the information needed for LRT calculation. This task is performed by the script ‘./G0/Code/APS16_ExtractLRTandNP_positiveSelection.pl’ (Fig. 5A) which extracts: log likelihood (lnL), the number of parameters (np) for each model, omega for M0, M8, p0 and p1 for M1 and M8, w0 and w1 for M1 and the positive selection sites (PSS, aminoacid under selection) for all the models.


**Input files:** All the output files of CodeML './G0/Orthology_Groups/codeml[_OGC_id_].M0.mlc’,
‘./G0/Orthology_Groups/codeml[_OGC_id_].sm8.mlc’ and  './G0/Orthology_Groups/codeml[_OGC_id_].sm.mlc’ (Fig. 5C)


**Output:** If all the models have complete information the table './Final_table_positive_selection/PositiveSelectionTable.txt’ (Fig. 6F) will be filled with data. If important CodeML values such as the likelihood (lnL) and/or the number of parameters (np) are missing, the table ./Failed_files/FailedPositiveSelectionTable.txt (Fig. 2L) will be filled with any available information and absent data replaced with NAs. 
#### SUBSTEP 16: LRT calculation (log ratio tests) for site-specific models
**Function:** LRT calculation and FDR correction based on the data in table  ‘./Final_table_positive_selection/PositiveSelectionTable.txt’ (Fig. 6F) is performed by R script ‘./G0/Code/APS18_Calculate_LTR.R. (Fig. 5A). 


**Input files:** Table './Final_table_positive_selection/PositiveSelectionTable.txt’ (Fig. 6F).


**Output:** A table including only the genes under positive selection at the site-specific level './Final_table_positive_selection/GenesUnderPositiveSelection.txt’ (Fig. 6G). All intermediate files (from SUBSTEP 5 to 16) of all genes that do not show signals of positive selection will be compressed in ‘./Results/[_OGC_id_].tar.gz’ (Fig. 2G).
#### SUBSTEP 17:  Label single species for branch-site analysis.
**Function:** In order to assess positive selection for individual branches of the phylogeny, this substep generates an equal number of trees as species in the orthology group - for each a different species is labeled as the foreground branch, leaving the rest of the species as background branches. This is performed by the script ‘./G0/Code/APS19_TreeGeneratorCombinator.pl’ (Fig. 5A).


**Input files:** Table ‘./G0/Orthology_Groups/[_OGC_id_].list.pep.fasta.dict.fa.best.nex.cl.head.dnd.GenTree.nex’ from SUBSTEP 11 (Fig. 5C)


**Output:** Labeled tree for each species in the respective orthology group ‘./G0/Orthology_Groups/[species_name_index][_OGC_id_].BranchAnalyTree’ and a list of trees TreeList.txt (Fig. 5C)
#### SUBSTEP 18: Generate configuration files for branch and branch-site models
**Function:** Generates configuration files to run branch-site model analyses that fit seven codon substitution models: M0  (‘./G0/Code/APS20_CreateCtl_ParameterDefParPG_BSM0.pl’), H0 (‘./G0/Code/APS21_CreateCtl_ParameterDefParPG_BSM0H0.pl’) (Fig. 5A), and H1  (‘./G0/Code/APS22_CreateCtl_ParameterDefParPG_BSM0H1.pl’) (Fig. 5A), using the configuration file ‘./Data/Parameter_codeml_M0BS.txt’ (Fig. 5A) (for APS20) or ‘./G0/Data/Parameter_codeml_M2BSH0.txt‘  (for APS21)  or ‘./G0/Data/Parameter_codeml_M2BSH1.txt’ (for APS22) (these files can be modified by the user) and a default configuration file (./G0/Data/Default_par.txt) that fills any gap in the executed CodeML configuration files (Fig. 5B).


**Input files:** './G0/Data/Parameter_codeml_M0BS.txt’ (for APS20) or ‘./G0/Data/Parameter_codeml_M2BSH0.txt’ (for APS21) or’./G0/Data/ Parameter_codeml_M2BSH1.txt’ (for APS22) and  ‘./G0/Data/Default_par.txt.’ (Fig. 5B)


**Output:** Configuration files ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0.ctl’, ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h0.ctl’ and ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h1.ctl’ (Fig. 5C)

#### SUBSTEP 19: Run CodeML for branch and branch-site models
**Function:** Run CodeML with the configuration files (.ctl) generated in SUBSTEP 18.


**Input files:** Configuration files ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0.ctl’, ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h0.ctl’ and ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h1.ctl’ (Fig. 5C)


**Output:** CodeML output files ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0.mlc’, ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h0.mlc’ and ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h1.mlc’ (Fig. 5C).
#### SUBSTEP 20:  Extract information for LRT (log ratio tests) calculation for branch and branch-site models
**Function:**  The CodeML output files (.mlc files) of the branch and branch-site model analyses performed in SUBSTEP 19 need to be parsed for the information needed for LRT calculation. This is performed by the script './G0/Code/APS23_ExtractLRTandNP_positiveSelectionBranchSite.pl’ (Fig. 5A) which extracts: likelihood (lnL) and number of parameters (np) for each model.


**Input files:** Full CodeML output ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0.mlc’, ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h0.mlc’ and  ‘./G0/Orthology_Groups/codeml[species_name_index][_OGC_id_].bsm0h1.mlc’ (Fig. 5C)


**Output:** Table including all relevant data for LRT calculation ‘./Final_table_positive_selection/Branch_models_BranchSite_models_Table.txt’ (Fig. 6B)
#### SUBSTEP 21: LRT (log ratio tests) calculation for branch and branch-site models
**Function:** LRT calculation and FDR correction based on the data in table  ‘./Final_table_positive_selection/Branch_models_BranchSite_models_Table.txt’ (Fig. 6B) performed by the R script ‘./G0/Code/APS23_BranchSiteAnalysis.R’. (Fig. 5A). 


**Input files:**  Table including all relevant data for LRT calculation from SUBSTEP 20 ‘./Final_table_positive_selection/Branch_models_BranchSite_models_Table.txt.


**Output:** Table including only genes under positive selection at the branch and branch-site level ‘./Final_table_positive_selection/Branch_model.txt’ (Fig. 6A) and ‘./Final_table_positive_selection/Branch_site_model.txt’ (Fig. 6C). The intermediate files (from SUBSTEP 5 to 21) will be compressed in (‘./Results_Branch/[_OGC_id_]bs.tar.gz’) (Fig. 2F).

### Alternative to Docker
AlexandrusPS was devised to run without any previous installation given the docker container. Nevertheless, the user is given the choice to install all the necessary programs and modules independently.
#### Perl
+ Perl 5: https://www.perl.org/
* The following perl modules are required and can be installed them using cpan:
+ Data::Dumper
+ List::MoreUtils qw(uniq)
+ Array::Utils qw(:all)
+ String::ShellQuote qw(shell_quote)
+ List::Util
+ POSIX

#### R version 4.0.5

+ R: https://www.r-project.org/
* The following libraries are necessary:

+ dplyr
+ ggplot2
+ caret
+ reshape2
+ ggpubr
+ RColorBrewer
+ stringr
+ viridis
+ Rstatix

#### Protein orthology search
+ ProteinOrtho (https://www.bioinf.uni-leipzig.de/Software/proteinortho/) v6.06
#### Aligners
+ PRANK multiple sequence aligner (http://wasabiapp.org/software/prank/) v.170427
+ PAL2NAL http://www.bork.embl.de/pal2nal/#Download v14
#### PAML
The PAML software package includes CodeML (http://abacus.gene.ucl.ac.uk/software/paml.html) - v4.8a or v4.7


## References
<a id="1">[1]</a> 
Yang, Z. (2007). 
PAML 4: phylogenetic analysis by maximum likelihood. 
Molecular biology and evolution, 24(8), 1586-1591.

<a id="2">[2]</a>
Löytynoja, A. (2014). Phylogeny-aware alignment with PRANK. Multiple sequence alignment methods, 155-170.

<a id="3">[3]</a>
Suyama, M., Torrents, D., & Bork, P. (2006). PAL2NAL: robust conversion of protein sequence alignments into the corresponding codon alignments. Nucleic acids research, 34(suppl_2), W609-W612.

<a id="4">[4]</a>
Lechner, M., Findeiß, S., Steiner, L., Marz, M., Stadler, P. F., & Prohaska, S. J. (2011). Proteinortho: detection of (co-) orthologs in large-scale analysis. BMC bioinformatics, 12(1), 1-9.
