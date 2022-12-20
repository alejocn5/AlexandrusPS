#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;


#forDelete ###@###
##################################
my $Number_of_Species_allowed = 4;
###################################

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

while (my $S1_LinTabPO = <$PO_TABLE>){#2
    chomp $S1_LinTabPO; 
	#push @A4_TabPO_S1, $S1_LinTabPO;
	my @A1_ColLinTabPO_S1 = (split /\s+/, $S1_LinTabPO);
	&Delete_simgle_groups( \@A1_ColLinTabPO_S1, $S1_LinTabPO);
	my $S2_POGroup_A1 = pop @A1_ColLinTabPO_S1;
#---------------------------------------------print Dumper \@A1_ColLinTabPO_S1;
	my $S3_SizeColLinTabPO_A1 = &NumberOfSpecies(\@A1_ColLinTabPO_S1);
	my @A2_ColLinComPO_S1 = (split /\,/, $S1_LinTabPO);
		my $S4_SizeColColTabPO_A2 = @A2_ColLinComPO_S1;

	if  ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 == 12){
			push @A10_OneToMore_OURbusco_orthologs, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 == 12){
		push @A8_OneToOne_OURbusco_orthologs, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 > 1  && $S3_SizeColLinTabPO_A1 > $Limit){
		push @A3_Paralogs_S1, $S1_LinTabPO;
	}elsif ($S4_SizeColColTabPO_A2 == 1  && $S3_SizeColLinTabPO_A1 > $Limit){
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

foreach my $S5_TabPO_A4 (@A4_TabPO_S1) {
	my @A11_ColLinTabPO_S5 = (split /\s+/, $S5_TabPO_A4);
	my $S6_POGroup_A11 = pop @A11_ColLinTabPO_S5;
		for (my $i= 0 ; $i <= $#A11_ColLinTabPO_S5 ; $i ++){
		my @A12_Colcoma;
		my $Convertion;
		my @Convertionup;

			 if  ($i == 0 ){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @CEW1, $S6_con;
				}
			 }elsif ($i == 1){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @DF5006, $S6_con;
				}
			}elsif ($i == 2){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @DF5012, $S6_con;
				}
			}elsif ($i == 3){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @MT8872, $S6_con;
				}
			}elsif ($i == 4){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @cbrenneri, $S6_con;
				}
			}elsif ($i == 5){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @cbriggsae, $S6_con;
				}
			}elsif ($i == 6){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @celegans, $S6_con;
				}
			}elsif ($i == 7){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @cinopinata, $S6_con;
				}
			}elsif ($i == 8){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @cjaponica, $S6_con;
				}
			}elsif ($i == 9){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @cremanei, $S6_con;
				}											
			}elsif ($i == 10){
				@A12_Colcoma = (split /\,/, $A11_ColLinTabPO_S5[$i]);
				($Convertion) = &Upset_convertion( \@A12_Colcoma, $S6_POGroup_A11);
				@Convertionup = @$Convertion;
				foreach my $S6_con (@Convertionup) {
					push @ppacificus, $S6_con;
				}

			 }else{
        	 	next;
			 } 
		@A12_Colcoma = ();
		@Convertionup = ();	 
		}
}

shift @CEW1;
shift @DF5006;
shift @DF5012;
shift @MT8872;
shift @cbrenneri;
shift @cbriggsae;
shift @celegans;
shift @cinopinata;
shift @cjaponica;
shift @cremanei;
shift @ppacificus;

#---------------------------------------------print Dumper \@MT8872;
my @Sizes;

my $CEW1s = @CEW1;
push @Sizes, $CEW1s-1;
my $DF5006s = @DF5006;
push @Sizes, $DF5006s-1;
my $DF5012s = @DF5012;
push @Sizes, $DF5012s-1;
my $MT8872s = @MT8872;
push @Sizes, $MT8872s-1;
my $cbrenneris = @cbrenneri;
push @Sizes, $cbrenneris-1;
my $cbriggsaes = @cbriggsae;
push @Sizes, $cbriggsaes-1;
my $celeganss = @celegans;
push @Sizes, $celeganss-1;
my $cinopinatas = @cinopinata;
push @Sizes, $cinopinatas-1;
my $cjaponicas = @cjaponica;
push @Sizes, $cjaponicas-1;
my $cremaneis = @cremanei;
push @Sizes, $cremaneis-1;
my $ppacificuss = @ppacificus;
push @Sizes, $ppacificuss-1;
my @sorted_Sizes = sort { $a <=> $b } @Sizes;
#---------------------------------------------print Dumper \@sorted_Sizes;

my $CEW1;
my $DF5006;
my $DF5012;
my $MT8872;
my $cbrenneri;
my $cbriggsae;
my $celegans;
my $cinopinata;
my $cjaponica;
my $cremanei;
my $ppacificus;

my $HighSize = pop @sorted_Sizes;
open my $CL, "> $ARGV[0].Clean";
foreach my $S6_TabClean (@A4_TabPO_S1) {
	print $CL "$S6_TabClean\n";
}
#open my $UP, "> $ARGV[0].upsetTable";

#print $UP "CEW1\,DF5006\,DF5012\,MT8872\,cbrenneri\,cbriggsae\,celegans\,cinopinata\,cjaponica\,cremanei\,ppacificus\n";
# for (my $i= 0 ; $i <= $HighSize ; $i ++){
# 	($CEW1) = &Upset_Table( \@CEW1, $i, $CEW1s);
# 	($DF5006) = &Upset_Table( \@DF5006, $i, $DF5006s);
# 	($DF5012) = &Upset_Table( \@DF5012, $i, $DF5012s);
# 	($MT8872) = &Upset_Table( \@MT8872, $i, $MT8872s);
# 	($cbrenneri) = &Upset_Table( \@cbrenneri, $i, $cbrenneris);
# 	($cbriggsae) = &Upset_Table( \@cbriggsae, $i, $cbriggsaes);
# 	($celegans) = &Upset_Table( \@celegans, $i, $celeganss);
# 	($cinopinata) = &Upset_Table( \@cinopinata, $i, $cinopinatas);
# 	($cjaponica) = &Upset_Table( \@cjaponica, $i, $cjaponicas);
# 	($cremanei) = &Upset_Table( \@cremanei, $i, $cremaneis);
# 	($ppacificus) = &Upset_Table( \@ppacificus, $i, $ppacificuss);
# my $line =  "$CEW1$DF5006$DF5012$MT8872$cbrenneri$cbriggsae$celegans$cinopinata$cjaponica$cremanei$ppacificus\n";	
# $line =~ s/(.*)(\,)/$1/g;
# print $UP "$line";	
# }	



				

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
