# AlexandrusPS [TPS_66] 

This repository contains procedures and scripts from AlexandrusPS:
* [Installation](#installation)
    + [Recommended - deploy with Docker](#recommended---deploy-with-docker)
      - [How to Docker](#how-to-docker)
    + [Manual installation and requirements](#manual-installation-and-requirements)
* [5 simple steps to run AlexandrusPS](#5-simple-steps-to-run-alexandrusps)
    + [Example](#example)

## Installation
### Recommended - deploy with Docker

The easiest way to run AlexandrusPS is to use its Docker image. You can download Docker [here](https://docs.docker.com/get-docker/).

```
docker pull vivienschoonenberg/alexandrusps:0.6
```

Available tags can be found [here](https://hub.docker.com/repository/docker/vivienschoonenberg/alexandrusps).

#### How to Docker

Start an interactive bash shell with the alexandrusps container:

```
docker run --rm -it vivienschoonenberg/alexandrusps:0.6
```
You will be in proper location to run AlexandrusPS. To quit the container, type 'exit'.

To access local files (necessary), you can mount your home or a different folder in the container:

```
docker run --rm --mount "type=bind,src=/Users/$(id -un),dst=/app/$(id -un)" -u $(id -u):$(id -g) -it vivienschoonenberg/alexandrusps:0.6 
```
Here, src is the absolute path to the folder you would like to mount. Dst specifies the folder to be mounted in the "app" directory with your username/id. The app folder contains the AlexandrusPS pipeline as well, which is the folder you automatically enter when starting a container from the image (you can move up to the "app" folder using ``` cd .. ```).

You can also use the mounted folder in the container to copy any result or output files to your own local system.

### Manual installation and requirements
Although AlexandrusPS was devised to run without any previous installation given the docker containers,  the user is given the choice to install independently all the programs and modules to run.

-------------
#### Perl
+ Perl 5: https://www.perl.org/
* The following perl modules  are required, you can install them using cpan
    + Data::Dumper
    + List::MoreUtils qw(uniq)
    + Array::Utils qw(:all)
    + String::ShellQuote qw(shell_quote)
    + List::Util
    + POSIX
#### R

+ R: https://www.r-project.org/
* Install the following libraries
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
+ PAML software package, which includes codeml (http://abacus.gene.ucl.ac.uk/software/paml.html) - v4.8a or v4.7
#### Linux Screen
* Screen is usually installed by default on all major Linux distributions, for that check the current version of Screen with (screen –version). 
+ sudo apt install screen
-------------


## 5 simple steps to run AlexandrusPS
#### Step 1 
For each specie to analyze it is necessary to generate two fasta files, one with the amino acid sequences and the other with correspondent cds sequences (the same amino acid sequences but in DNA). It means: 1) Both files should have the same number of sequences and 2) each amino acid sequence should have their pair represented in the cds fasta file with the same header. For example: if you want to analyze 6 different species, you should have 12 fasta file (6 .cds.fasta and 6 .pep.fasta), follow a similar structure as the example data set in the ./Example folder, see Figure [TPS_72]

#### Step 2
Enter to the main folder of AlexandrusPS (cd ./AlexandrusPS_Positive_selection_pipeline) [TPS_71] and in the folder ./Fasta paste the cds and amino acid sequences.

#### Step 3
Follow Binomial nomenclature for naming the fasta files, this formatting ensures the correct work of the pipeline, for this, we will go step by step taking as an example Human

1) Take the scientific name in binomial nomenclature ("two-term naming system") (Homo sapiens) where the first term is genus or generic name  = Homo and the second term is the specific name or specific epithet = sapiens

2) join the two terms by underline (_) = Homo_sapiens

3) add the termination character (.cds.fasta) for the cds/dna file and (.pep.fasta) to the amino acid files = Homo_sapiens.cds.fasta (cds fasta file) and Homo_sapiens.pep.fasta (amino acid fasta file).

Two important considerations i) both fasta files need to have the same name, just change the termination character (.cds.fasta and .pep.fasta) ii) AlexandrusPS through the script APS1_IndexGenerator_QualityControl.pl generate a specie name index based on 6 letters from the name (three from the genus (hom) and three from the specific epithet (sap) ending in specie name index = homsap), so the user needs to be sure that the file is only named with the specie name (no special characters) and the user needs to be sure that the 6 letters do not overlap with the specie name index of the name of other specie in the folder.

#### Step 4
Quality control of your sequences (_highly recommended_)

After you put your sequences in the Fasta directory and before you run AlexandrusPS.sh, We highly recommend you to run the script “Sequences_quality_control_AlexandrusPS.sh'' to check if your sequences (.cds.fasta and .pep.fasta) are suitable for Positive selection analysis with Alexandrus. In case your sequences (either or both) are NOT suitable for AlexandrusPS you will find one or two error files “Error_missed_sequences.txt'' and/or “Error_with_Fasta_header.txt'', those files will appear in the main folder (where you execute Sequences_quality_control_AlexandrusPS.sh)[TPS_71] if after run the script none of these files appears it means your sequences are optimal for the study. The meaning of those files is described in the section of this GitHub “some errors that you may encounter during the quality control“.

This quality control is performed by the perl script APS1_IndexGenerator_QualityControl.pl

**Note** that this quality control is included by default in AlexandrusPS.sh, it will continue the analysis with the sequences that pass the quality control even there are some sequences in “Error_missed_sequences.txt”, but will interrupt the process if  finds the file  “Error_with_Fasta_header.txt”.

**Some errors that you may encounter during the quality control**

AlexandrusPS in the quality control looks for two main errors in the fasta files i) not all amino acids sequences ( .pep.fasta) are represented in the .cds.fasta file, in that case, the script Sequences_quality_control_AlexandrusPS.sh  will generate an error file “Error_missed_sequences.txt” with all the peptide sequences which could not be found in the .cds.fasta file ii) check that the resulting file does not contain empty fasta sequences (header but no sequence), contain empty files and check that the .pep.fasta file and the .cds.fasta file contain the same amount of sequences, in case one of those assumptions are false it will generate an empty file “Error_with_Fasta_header.txt”. If you encounter this error file, we recommend that you re-check the headers of your fasta files (.cds.fasta and .pep.fasta) and 1) avoid the use of special characters and 2) try to make your headers short and simple.


#### Step 5
after you confirm that no error files are generated in step 4, you can  execute AlexandrusPS from the main folder you just type in terminal  ./AlexandrusPS.sh

-------------

### Example
To run the example, Get into the the main folder Foto [TPS_71]  open a terminal and  type in terminal  ./Example_AlexandrusPS.sh

This executable will transfer the fasta files from the example folder to the fasta folder and execute AlexandrusPS.sh 

The output will be that  five of the seven protein ortho groups will be under positive selection ( NKG7) one without positive selection (NUP62CL) and  one to show how looks a protein that have problems to be analyzed with codml (CACNG3) [TPS_59]).TPS_35, TPS_74 
