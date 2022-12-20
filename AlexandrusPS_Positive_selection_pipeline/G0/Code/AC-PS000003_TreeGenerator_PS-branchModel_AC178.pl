#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;




#perl AC-PS000003_TreeGenerator_PS-branchModel_AC178.pl _7_.list.pep.fasta.dict _Homsap_.tree _Caljac_.tree _Gorgor_.tree _Pantro_.tree _Chlsab_.tree _Nomleu_.tree _Papanu_.tree _Ponabe_.tree _Macmul_.tree
open my $DIC, "< $ARGV[0]";
open my $Homsap, "< $ARGV[1]";
open my $Caljac, "< $ARGV[2]";
open my $Gorgor, "< $ARGV[3]";
open my $Pantro, "< $ARGV[4]";
open my $Chlsab, "< $ARGV[5]";
open my $Nomleu, "< $ARGV[6]";
open my $Papanu, "< $ARGV[7]";
open my $Ponabe, "< $ARGV[8]";
open my $Macmul, "< $ARGV[9]";


my %H1_SpeciesTree;
my %Species_ID;
my %Sp_Name;

open my $FL, ">> FileList.txt";
open my $TL, ">> TreeList.txt";

while (my $S2_LinDic = <$DIC>){
    chomp $S2_LinDic;
    my @Col_LinDic_S2 = (split /\_/, $S2_LinDic);

    $Species_ID{"\_$Col_LinDic_S2[1]\_"} = "\_$Col_LinDic_S2[1]\_$Col_LinDic_S2[2]\_$Col_LinDic_S2[3]\_";
    $Sp_Name{"$Col_LinDic_S2[1]"} = "$Col_LinDic_S2[1]\_$Col_LinDic_S2[2]\_";
    #my $T = $tree;
    #$T =~ s/\_$Col_LinDic_S2[1]\_/\_$Col_LinDic_S2[1]\_\#1/ig;

} 
    #------------------------------------------------
    print Dumper \%Sp_Name;

while (my $linGenHomsap = <$Homsap>){
    chomp $linGenHomsap; 
    my $Homsap = $linGenHomsap;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Homsap);
    open my $OUT, "> $Sp_Name{Homsap}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Homsap}\n"; 
    print $TL "$Sp_Name{Homsap}.BranchAnalyTree\n"; 
} 

#------------------------------------------------print Dumper \%H1_SpeciesTree;
while (my $linGenCaljac = <$Caljac>){
    chomp $linGenCaljac; 
    my $Caljac = $linGenCaljac;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Caljac);
    open my $OUT, "> $Sp_Name{Caljac}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Caljac}\n"; 
    print $TL "$Sp_Name{Caljac}.BranchAnalyTree\n"; 
} 
 
while (my $linGenGorgor = <$Gorgor>){
    chomp $linGenGorgor; 
    my $Gorgor = $linGenGorgor;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Gorgor);
    open my $OUT, "> $Sp_Name{Gorgor}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Gorgor}\n"; 
    print $TL "$Sp_Name{Gorgor}.BranchAnalyTree\n"; 
} 

while (my $linGenPantro = <$Pantro>){
    chomp $linGenPantro; 
    my $Pantro = $linGenPantro;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Pantro);
    open my $OUT, "> $Sp_Name{Pantro}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Pantro}\n"; 
    print $TL "$Sp_Name{Pantro}.BranchAnalyTree\n"; 
} 
#.BranchAnalyTree

while (my $linGenChlsab = <$Chlsab>){
    chomp $linGenChlsab; 
    my $Chlsab = $linGenChlsab;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Chlsab);
    open my $OUT, "> $Sp_Name{Chlsab}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Chlsab}\n"; 
    print $TL "$Sp_Name{Chlsab}.BranchAnalyTree\n"; 
} 

while (my $linGenNomleu = <$Nomleu>){
    chomp $linGenNomleu; 
    my $Nomleu = $linGenNomleu;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Nomleu);
    open my $OUT, "> $Sp_Name{Nomleu}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Nomleu}\n"; 
    print $TL "$Sp_Name{Nomleu}.BranchAnalyTree\n"; 
} 

while (my $linGenPapanu = <$Papanu>){
    chomp $linGenPapanu; 
    my $Papanu = $linGenPapanu;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Papanu);
    open my $OUT, "> $Sp_Name{Papanu}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Papanu}\n"; 
    print $TL "$Sp_Name{Papanu}.BranchAnalyTree\n"; 
} 

while (my $linGenPonabe = <$Ponabe>){
    chomp $linGenPonabe; 
    my $Ponabe = $linGenPonabe;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Ponabe);
    open my $OUT, "> $Sp_Name{Ponabe}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Ponabe}\n"; 
    print $TL "$Sp_Name{Ponabe}.BranchAnalyTree\n"; 
} 

while (my $linGenMacmul = <$Macmul>){
    chomp $linGenMacmul; 
    my $Macmul = $linGenMacmul;
    my ($Tree) = &Change_names_tree( \%Species_ID, $Macmul);
    open my $OUT, "> $Sp_Name{Macmul}.BranchAnalyTree";
    print $OUT "$Tree"; 
    print $FL "$Sp_Name{Macmul}\n"; 
    print $TL "$Sp_Name{Macmul}.BranchAnalyTree\n"; 
} 

sub Change_names_tree {
    my ($SpID, $Tree) = @_;
    my %spID = %{shift()}; 
#------------------------------------------------------------------------------------------------------print Dumper \ %spID;
    foreach my $KeySP (keys %spID) {
        $Tree =~ s/$KeySP/$spID{$KeySP}/ig;
	}
   return $Tree; 

}