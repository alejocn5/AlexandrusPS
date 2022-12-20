#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;





open my $DIC, "< $ARGV[0]";
open my $TREEsp, "< $ARGV[1]";
#perl AC-PS000004_TreeGenerator_PS-branchModel_AC178.pl  _7_.list.pep.fasta.dict Ensembl78__9primates__with_taxon_id__unrooted.tre

my %H1_SpeciesTree;
my %Species_ID;
my %Sp_Name;
my $ID;

open my $FL, ">> FileList.txt";
open my $TL, ">> TreeList.txt";

while (my $S2_LinDic = <$DIC>){
    chomp $S2_LinDic;
    my @Col_LinDic_S2 = (split /\_/, $S2_LinDic);

    $Species_ID{"\_$Col_LinDic_S2[1]\_"} = "\_$Col_LinDic_S2[1]\_$Col_LinDic_S2[2]\_$Col_LinDic_S2[3]\_";
    $ID = "\_$Col_LinDic_S2[2]\_";
    #my $T = $tree;

    #$T =~ s/\_$Col_LinDic_S2[1]\_/\_$Col_LinDic_S2[1]\_\#1/ig;

} 
    #------------------------------------------------
    print Dumper \%Species_ID;

while (my $linGenTREEsp = <$TREEsp>){
    chomp $linGenTREEsp; 
    my $TREEsp = $linGenTREEsp;
    my ($Tree) = &Change_names_tree( \%Species_ID, $TREEsp);
    open my $OUT, "> $ID.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$ID"; 
    print $TL "$ID.BranchAnalyTree"; 
} 

#------------------------------------------------print Dumper \%H1_SpeciesTree;

 


#.BranchAnalyTree



sub Change_names_tree {
    my ($SpID, $Tree) = @_;
    my %spID = %{shift()}; 
#------------------------------------------------------------------------------------------------------print Dumper \ %spID;
    foreach my $KeySP (keys %spID) {
        $Tree =~ s/$KeySP/$spID{$KeySP}/ig;
	}
   return $Tree; 

}