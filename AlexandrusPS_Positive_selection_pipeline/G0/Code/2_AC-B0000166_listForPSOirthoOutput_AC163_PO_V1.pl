#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;


#forDelete 


open my $PO_TABLE, "< $ARGV[0]";

my @CEW1;
my @DF5006;
my @DF5012;
my @MT8872;
my @cbrenneri;
my @cbriggsae;
my @celegans;
my @cinopinata;
my @cjaponica;
my @cremanei;
my @ppacificus;

my @A3_Paralogs_S1;
my @A4_TabPO_S1;
my @A7_Summary;
my @A8_OneToOne_OURbusco_orthologs;
my @A9_Orthologs_Groups_with_no_Paralogs_for_PS;
my @A10_OneToMore_OURbusco_orthologs;

while (my $S1_LinTabPO = <$PO_TABLE>){#2
    chomp $S1_LinTabPO; 
    push @A4_TabPO_S1, $S1_LinTabPO;
	my @A1_ColLinTabPO_S1 = (split /\s+/, $S1_LinTabPO);
	my $S2_POGroup_A1 = pop @A1_ColLinTabPO_S1;
#---------------------------------------------print Dumper \@A1_ColLinTabPO_S1;
	my $S3_SizeColLinTabPO_A1 = &NumberOfSpecies(\@A1_ColLinTabPO_S1);
	my @A2_ColLinComPO_S1 = (split /\,/, $S1_LinTabPO);
		my $S4_SizeColColTabPO_A2 = @A2_ColLinComPO_S1;

	if  ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 == 12){
			push @A10_OneToMore_OURbusco_orthologs, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 == 12){
		push @A8_OneToOne_OURbusco_orthologs, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 > 3){
		push @A3_Paralogs_S1, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 > 3){
		push @A9_Orthologs_Groups_with_no_Paralogs_for_PS, $S1_LinTabPO;
			&SingleOrthologsForPositiveSelection( \@A1_ColLinTabPO_S1, $S2_POGroup_A1);
	}else{
        next;
	}	 
}#2  
my $TotalNumberOfOrthologyGroups = @A4_TabPO_S1;
my $OneToOneOthologs = @A8_OneToOne_OURbusco_orthologs;
my $Orthologs_Groups_with_no_Paralogs_for_PS = @A9_Orthologs_Groups_with_no_Paralogs_for_PS;
my $Orthologs_Groups_with_Paralogs_for_PS = @A3_Paralogs_S1;
my $Total_Number_of_Orthology_Groups_with_in_all_species_with_at_least_one_Orthologs = @A10_OneToMore_OURbusco_orthologs;
open my $SUMMARY, "> $ARGV[0].Summary";
print $SUMMARY "Total_Number_of_Orthology_Groups\t$TotalNumberOfOrthologyGroups\n";
print $SUMMARY "Total_Number_of_Orthology_Groups_with_One_to_One_Orthologs\t$OneToOneOthologs\n";
print $SUMMARY "Total_Number_of_Orthology_Groups_with_in_all_species_with_at_least_one_Orthologs\t$Total_Number_of_Orthology_Groups_with_in_all_species_with_at_least_one_Orthologs\n";
print $SUMMARY "Orthologs_Groups_with_no_Paralogs_for_Positive_Selection\t$Orthologs_Groups_with_no_Paralogs_for_PS\n";
print $SUMMARY "Orthologs_Groups_with_Paralogs_for_Positive_Selection\t$Orthologs_Groups_with_Paralogs_for_PS\n";
#---------------------------------------------print Dumper \@A3_Paralogs_S1;

	



				

sub Upset_Table {
    my ($line, $I, $size) = @_;
    my @line = @{ $line };
	my @line_list; 
	if  ($I <= $size ){
		return $line[$I];
	}else{
        return "\,";
	} 
}	



sub Upset_convertion {
    my ($line, $Group) = @_;
    my @line = @{ $line };
	my @line_list;  

  foreach my $S4S2_line (@line) { #<- treat the ref as an array
    
	if ($S4S2_line =~ /^\*/){
		push @line_list, "\,";
	}else{
		push @line_list, "$Group,";
	}
	#---------------------------------------------print Dumper \@line_list;
	
  }
return \@line_list;

}






sub SingleOrthologsForPositiveSelection {
    my ($Species, $PO_Group_number) = @_;
    my @Species = @{ $Species };
	my @Species_list;  

  foreach my $S1S2_line (@Species) { #<- treat the ref as an array
    
	if ($S1S2_line =~ /^\*/){
		print "";
	}else{
		push @Species_list, $S1S2_line;
	}
  }
   #----------------------------------------------------------------------------------   print Dumper \@Species_list;
	open my $LIST, "> \_$PO_Group_number\_.list";
	foreach my $S2S2_line (@Species_list) {
		print $LIST "$S2S2_line\n";
	}	

}

sub NumberOfSpecies {
	my $array_ref = shift;
	my @NumberGroups;
	#---------------------------------------------	print Dumper \@{$array_ref;
	
  	
	foreach my $S4S1_line (@{$array_ref}) { #<- treat the ref as an array
    
		if ($S4S1_line =~ /^\*/){
			print "";
		}else{
			push @NumberGroups, $S4S1_line;
		}
 	}

	my $S3_SizeNumberGroups = @NumberGroups;
	return $S3_SizeNumberGroups;
	
}


exit;
