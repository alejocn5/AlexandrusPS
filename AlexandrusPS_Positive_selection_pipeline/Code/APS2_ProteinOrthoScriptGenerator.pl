#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;



open my $LIST_PEP, "< $ARGV[0]";

my $S2_numberOf_CPUS;

my @A1_orthologyFileList_S1;

while (my $S1_ListPepFiles = <$LIST_PEP>){
    chomp $S1_ListPepFiles; 
    push @A1_orthologyFileList_S1, $S1_ListPepFiles; 
}
#----------------------------------------------------------------print Dumper \@A1_orthologyFileList_S1;

$S2_numberOf_CPUS = "14";

my $S3_list_of_files_A1 = join(" ", @A1_orthologyFileList_S1);

open my $OUT, "> ../Orthology_Prediction/ProteinOrthoTable_executable.sh";

print $OUT "proteinortho -project=ProteinOrthoTable -cpus=$S2_numberOf_CPUS $S3_list_of_files_A1\n";
