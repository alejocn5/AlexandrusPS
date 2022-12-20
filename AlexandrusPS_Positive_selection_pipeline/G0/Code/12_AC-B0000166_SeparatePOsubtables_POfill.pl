#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;
use POSIX;


#forDelete ###@###
##################################
my $Number_of_Species_allowed = 4;
my $Jobs = 5; 
###################################

my $numberOfjobs = $Jobs -1;

my $Limit = $Number_of_Species_allowed -1;
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
my %Ha1_NumberSpeciesPPOG;
my %H2_PPOG_line;
my %H3_Size;
my %H4_jobs;

while (my $S1_LinTabPO = <$PO_TABLE>){#2
    chomp $S1_LinTabPO; 
	#push @A4_TabPO_S1, $S1_LinTabPO;
	my @A1_ColLinTabPO_S1 = (split /\s+/, $S1_LinTabPO);
	&Delete_simgle_groups( \@A1_ColLinTabPO_S1, $S1_LinTabPO);
	my $S2_POGroup_A1 = pop @A1_ColLinTabPO_S1;

	my $S3_SizeColLinTabPO_A1 = &NumberOfSpecies(\@A1_ColLinTabPO_S1);
	my @A2_ColLinComPO_S1 = (split /\,/, $S1_LinTabPO);
		my $S4_SizeColColTabPO_A2 = @A2_ColLinComPO_S1;

	if  ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 == 12){
			next;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 == 12){
		next;
	}elsif ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 > $Limit){
		next;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 > $Limit){
		
		push @{ $Ha1_NumberSpeciesPPOG{$S3_SizeColLinTabPO_A1}}, $S2_POGroup_A1;
		$H2_PPOG_line{$S2_POGroup_A1} =  $S1_LinTabPO;
			&SingleOrthologsForPositiveSelection( \@A1_ColLinTabPO_S1, $S2_POGroup_A1);
	}else{
        next;
	}	 
}#2  

	foreach my $key (keys %Ha1_NumberSpeciesPPOG) {
		
		my $Size =@{$Ha1_NumberSpeciesPPOG{$key}};
		my $jobs = $Size/$numberOfjobs;
		my $Jobsflor = floor($jobs);
		
		$H3_Size{$key} =  $Size;
		$H4_jobs{$key} =  $Jobsflor;
	}


#---------------------------------------------print Dumper \%Ha1_NumberSpeciesPPOG;
#---------------------------------------------print Dumper \%H4_jobs;
my %Ha2_ranksForGruping;
foreach my $key (keys %H3_Size) {
	
		for (my $i= 0 ; $i < $H3_Size{$key} ; $i += $H4_jobs{$key}){
		push @{ $Ha2_ranksForGruping{$key}}, $i;
		}
		push @{ $Ha2_ranksForGruping{$key}}, $H3_Size{$key};
}
#---------------------------------------------print Dumper \%Ha2_ranksForGruping;
my %HaJobsGroups;
foreach my $keyRank (sort {$b<=>$a} keys %Ha2_ranksForGruping) {
	my @limitsGroups = @{$Ha2_ranksForGruping{$keyRank}};
		for (my $i= 1 ; $i <= $#limitsGroups ; $i ++){
				my @list = @{$Ha1_NumberSpeciesPPOG{$keyRank}};
			for (my $a= $limitsGroups[$i-1] ; $a <= $limitsGroups[$i] ; $a ++){
				push @{ $HaJobsGroups{$i}}, $H2_PPOG_line{$list[$a]};
			}
		}

}

foreach my $key (keys %HaJobsGroups) {
print "$key\n";
open my $Groups, "> $ARGV[0]\_G$key.job";
	foreach my $lines (@{$HaJobsGroups{$key}}){
		print $Groups "$lines\n";
	}
}
#---------------------------------------------print Dumper \%HaJobsGroups;

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
	###@###ppen my $LIST, "> \_$PO_Group_number\_.list";
	foreach my $S2S2_line (@Species_list) {
		###@###print $LIST "$S2S2_line\n";
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

sub Delete_simgle_groups {
	my ($Groups, $Line) = @_;
    my @Groups = @{ $Groups };
	my @NumberGroups;
	#---------------------------------------------	print Dumper \@{$array_ref;
	my $g = pop @Groups;
  	
	foreach my $S4S1_line (@Groups) { #<- treat the ref as an array
    
		if ($S4S1_line =~ /^\*/){
			print "";
		}else{
			push @NumberGroups, $S4S1_line;
		}
 	}
my $S3_SizeNumberGroups = @NumberGroups;

		if ($S3_SizeNumberGroups > 1){
			push @A4_TabPO_S1, $Line;
			
		}else{
			print "";
		}
	
	
	
}

exit;
