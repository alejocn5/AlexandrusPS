# AlexandrusPS [TPS_66] 


This repository contains procedures and scripts  from AlexandrusPS:


### Requirements
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
