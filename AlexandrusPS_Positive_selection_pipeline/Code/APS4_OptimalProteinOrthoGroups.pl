#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;


#minimum number of species in orthology cluster
##################################
my $Number_of_Species_allowed = 3;
###################################

my $Limit = $Number_of_Species_allowed -1;
open my $PO_TABLE, "< $ARGV[0]";
open my $LIST_IDS, ">> ProteinOrthoTable.proteinortho.fill.list";



my @A3_Paralogs_S1;
my @A4_TabPO_S1;
my @A7_Summary;
my @A8_OneToOne_OURbusco_orthologs;
my @A9_Orthologs_Groups_with_no_Paralogs_for_PS;
my @A10_OneToMore_OURbusco_orthologs;

while (my $S1_LinTabPO = <$PO_TABLE>){#2
    chomp $S1_LinTabPO; 
	my @A1_ColLinTabPO_S1 = (split /\s+/, $S1_LinTabPO);
	my $S12_NumberOfSpeciesEvaluated = @A1_ColLinTabPO_S1 -1;
	#print "$S12_NumberOfSpeciesEvaluated\n";
	# $S2_POGroup_A1 = Protein ortho ID
	my $S2_POGroup_A1 = pop @A1_ColLinTabPO_S1;
#---------------------------------------------print Dumper \@A1_ColLinTabPO_S1;
	#Count number of species in the orthology Cluster, the number is in $S3_SizeColLinTabPO_A1
	my $S3_SizeColLinTabPO_A1 = &NumberOfSpecies(\@A1_ColLinTabPO_S1);
	my @A2_ColLinComPO_S1 = (split /\,/, $S1_LinTabPO);
		my $S4_SizeColColTabPO_A2 = @A2_ColLinComPO_S1;
	#if there is a species with a paralog and is present in all species
	if  ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 == $S12_NumberOfSpeciesEvaluated){
			push @A10_OneToMore_OURbusco_orthologs, $S1_LinTabPO;
	#if there is 1-to-1 orthologs and is present in all species
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 == $S12_NumberOfSpeciesEvaluated){
		push @A8_OneToOne_OURbusco_orthologs, $S1_LinTabPO;
		&SingleOrthologsForPositiveSelection( \@A1_ColLinTabPO_S1, $S2_POGroup_A1);
	#if there is a species with a paralog and have the minimum number of species in orthology cluster
	}elsif ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 > $Limit){
		push @A3_Paralogs_S1, $S1_LinTabPO;
	#if there is 1-to-1 orthologs and have the minimum number of species in orthology cluster
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 > $Limit){
		push @A9_Orthologs_Groups_with_no_Paralogs_for_PS, $S1_LinTabPO;
		#Create list file
			&SingleOrthologsForPositiveSelection( \@A1_ColLinTabPO_S1, $S2_POGroup_A1);
	}else{
        next;
	}	 
}#2  





sub SingleOrthologsForPositiveSelection {
    my ($Species, $PO_Group_number) = @_;
    my @Species = @{ $Species };
	my @Species_list;
   #----------------------------------------------------------------------------------    print Dumper \@Species;

  foreach my $S1S2_line (@Species) { #<- treat the ref as an array
    
	if ($S1S2_line =~ /^\*/ ){
		print "";
	}else{
				push @Species_list, $S1S2_line;

	}
  }
  #----------------------------------------------------------------------------------   print Dumper \@All;
   #----------------------------------------------------------------------------------    print Dumper \@Species_list;
      #----------------------------------------------------------------------------------	  print Dumper \@Eurha;

	my $Size_Caeno = @Species_list; 
	&Create_File_Caeno( \@Species_list, $Size_Caeno, $PO_Group_number); 

	#----------------------------------------------------------------------------------print Dumper \@Species_list;

	

}

sub Create_File_Caeno {
	    my ($Species_list, $Size, $PO_Group_number) = @_;
    my @Species_list = @{ $Species_list };

	
	
#----------------------------------------------------------------------------------print Dumper \@Species_list;
		if  ($Size >= $Number_of_Species_allowed){
			print  $LIST_IDS "\_$PO_Group_number\_.list\n";
			open my $LIST, "> \_$PO_Group_number\_.list";
			foreach my $S2S2_line (@Species_list) {
				print $LIST "$S2S2_line\n";
				
			}
			}else{
        		print "";
		}

}


#Count the number of species that are in each Orthology Cluster
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
