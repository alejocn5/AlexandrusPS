#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use POSIX;

#ENSSLDG00000005995:1-16	ENSSLDG00000005995	100.000	15	0	0	1	15	2	16	3.27e-06	32.3
 #0 	 qseqid 	 query (e.g., gene) sequence id	(ENSSLDG00000005995:1-16)
 #1 	 sseqid 	 subject (e.g., reference genome) sequence id	(ENSSLDG00000005995)
 #2 	 pident 	 percentage of identical matches #100.000
 #3 	 length 	 alignment length	(15)
 #4 	 mismatch 	 number of mismatches (0)
 #5 	 gapopen 	 number of gap openings (0)
 #6 	 qstart 	 start of alignment in query	(1)
 #7 	 qend 	 end of alignment in query	(15)
 #8 	 sstart 	 start of alignment in subject	(2)
 #9 	 send 	 end of alignment in subject	(16)
 #10 	 evalue 	 expect value	(2.27e-06)
 #11 	 bitscore 	 bit score (32.3)

###########################################################
########################################################
#NUMERO DE RAMAS PERMITIDAS PARA GENERAR UN GRUPO

my $S2_NumberOfBranches = 3;


##########################################################
#########################################################


open my $TREE, "< $ARGV[0]";

my @A1_treeLines_S1;
my @A2_IdOrderTree_S1;
my %H2_KidVrank_A2;
my %H3_KrankVID;
my %H4_Kid_Vbracket;
my %H5_KidVPairgroup_S10;
my %H8_KidVSubBranchgroup_S16;
my %H6_KidVbranch_Ha2; # Here the Key is the ID from ensembl and the value is the branch group was formed from Ha2 a hash of array where the key is the branch group and the valeu si the array with the ID from ensbm from the same branch
my %H7_KidVBraRanPair_H2H5H6; # hash key => ID ensembl | Value=> Branch Number_Rank in the tree_Pair group Number | come from hashes H2,H5 and H6 
my %H9_TreeForChange;
my @A9_TreeForChange;
my @A10_TreeLinesWithNumbers_A9;


#open my $BEDmod, "> $ARGV[0].listNumberBranch";
#open my $TreeMOD, "> $ARGV[0].NumberBranch.dnd";
open my $TreeGen, "> $ARGV[0].GenTree.nex";

 


 
while (my $S1_treeLine = <$TREE>){#2
        chomp $S1_treeLine;
	push @A9_TreeForChange, "$S1_treeLine"; 
		if  ($S1_treeLine eq "\("){
		push @A1_treeLines_S1, "1\@\@\@$S1_treeLine";
		
	}else{
		push @A1_treeLines_S1, "0\@\@\@$S1_treeLine";
#------------------------------------------------------------------------------------------------------print " $S1_treeLine\n";
		my $S4_KeyIDH3_S1 = $S1_treeLine;
		$S4_KeyIDH3_S1 =~ s/(.*)(\:)(.*)/$1/g;
		my $last_caracter_string = chop($S1_treeLine);
#------------------------------------------------------------------------------------------------------print "$S4_KeyIDH3_S1 AND $char \n"; #Imprime l
		$H4_Kid_Vbracket{$S4_KeyIDH3_S1} = $last_caracter_string;
		my ($S3_ListIDS_Orden) = &Su4_Select_Only_ID( $S1_treeLine);
		push @A2_IdOrderTree_S1, "$S3_ListIDS_Orden";
	}
         
}
#------------------------------------------------------------------------------------------------------
print Dumper \@A1_treeLines_S1;
#------------------------------------------------------------------------------------------------------print Dumper \@A2_IdOrderTree_S1;

my $count = 1; 
my $rango = 1;
for (my $i= 0 ; $i <= $#A2_IdOrderTree_S1 ; $i += $count){
	if  ($A2_IdOrderTree_S1[$i] eq 0){
		next;
	}else{
	       	$H2_KidVrank_A2{"$A2_IdOrderTree_S1[$i]"} = $rango;
		$H3_KrankVID{$rango} = "$A2_IdOrderTree_S1[$i]";
		$rango = $rango + 1;
	}
}
#------------------------------------------------------------------------------------------------------print Dumper \%Ha2_KgroupVid_A1; 
my ($Ha2_KgroupVid_A1) = &Su2_FirstGroup( \@A1_treeLines_S1, $S2_NumberOfBranches);
my %Ha2_KgroupVid_A1 = %$Ha2_KgroupVid_A1;
#
#------------------------------------------------------------------------------------------------------print " H2_KidVrank_A2 Key = ID ensembl Value = rank, order\n";
#------------------------------------------------------------------------------------------------------print Dumper \%H2_KidVrank_A2;
#------------------------------------------------------------------------------------------------------print " H4_Kid_Vbracket Key = ID ensembl Value = ) or ,\n";
#------------------------------------------------------------------------------------------------------print Dumper \%H4_Kid_Vbracket;
#------------------------------------------------------------------------------------------------------print " H3_KrankVID Key = rank, order  Value = ID ensembl \n";
#------------------------------------------------------------------------------------------------------print Dumper \%H3_KrankVID;

foreach my $key (keys %Ha2_KgroupVid_A1) {
	foreach my $mis_scad (@{$Ha2_KgroupVid_A1{$key}}){
	#print $BEDmod "$mis_scad	$key\n";
	$H6_KidVbranch_Ha2{$mis_scad} = $key;

	}
}


#my $string = "Me encanta perl";
#my $char = chop($string);
#print "$char"; #Imprime l


sub Su4_Select_Only_ID{
my ($S1_treeLine) = @_;
my $S2_treeLine;
	if  ($S1_treeLine =~ /^:/){
		my $empty = 0;
	}else{
	$S1_treeLine =~ s/(.*)(\:)(.*)/$1/g;
	$S2_treeLine = $S1_treeLine;
	return ( $S2_treeLine);
	}
#---------------------------------------------------------------------------print Dumper \ @Su2A1_open_Su1A2;
}
#---------------------------------------------------------------------------print Dumper \ %Ha2_KgroupVid_A1;
my $S10_PairGroup_S9 = 1;
foreach my $key_Ha2 (keys %Ha2_KgroupVid_A1) {
my @A5_RankLocalArray_S6;
my $S9_VpuntComaPar_H4;
my $S8_Vid_H3;
my $S11_Vid_H3;

	foreach my $S5_ID_Ha2 (@{$Ha2_KgroupVid_A1{$key_Ha2}}){
	
		my $S6_RankTree_H2 = $H2_KidVrank_A2{$S5_ID_Ha2};
		#print  "$S6_RankTree_H2\n";
		push @A5_RankLocalArray_S6, $S6_RankTree_H2; 
	}
my @A6_SortRankLocArr_A5 = sort { $a <=> $b } @A5_RankLocalArray_S6;
#---------------------------------------------------------------------------print Dumper \ @A6_SortRankLocArr_A5;
		for (my $i= 1 ; $i <= $#A6_SortRankLocArr_A5 ; $i++){
		$S8_Vid_H3 = $H3_KrankVID{$A6_SortRankLocArr_A5[$i-1]};
		$S11_Vid_H3 = $H3_KrankVID{$A6_SortRankLocArr_A5[$i]};
		$S9_VpuntComaPar_H4 = $H4_Kid_Vbracket{$S8_Vid_H3};
#---------------------------------------------------------------------------print  "$S9_VpuntComaPar_H4\n";
			if ($S9_VpuntComaPar_H4 =~ /^,/){
			$H5_KidVPairgroup_S10{$S11_Vid_H3} = "$S10_PairGroup_S9";
			$H5_KidVPairgroup_S10{$S8_Vid_H3} = "$S10_PairGroup_S9";
			$S10_PairGroup_S9 = $S10_PairGroup_S9 + 1;
			}else{
                	$H5_KidVPairgroup_S10{$S11_Vid_H3} = "0";
			}
		}

}
#-----------------------------------------------------------------------------------print Dumper \%H5_KidVPairgroup_S10;
my $S16_SubBranchgroup_S21 = 1;
foreach my $key_Ha2 (keys %Ha2_KgroupVid_A1) {
my @A5_RankLocalArray_S23;
my $S21_VpuntComaPar_H4;
my $S20_Vid_H3;
my $S17_Vid_H3;

	foreach my $S22_ID_Ha2 (@{$Ha2_KgroupVid_A1{$key_Ha2}}){
		my $S23_RankTree_H2 = $H2_KidVrank_A2{$S22_ID_Ha2};
#-----------------------------------------------------------------------------------print Dumper \@{$Ha2_KgroupVid_A1{$key_Ha2}};
		push @A5_RankLocalArray_S23, $S23_RankTree_H2; 
	}
my @A6_SortRankLocArr_A5 = sort { $a <=> $b } @A5_RankLocalArray_S23;
my $S23_sizeArray_A6 = @A6_SortRankLocArr_A5 -1;
#print "$S23_sizeArray_A6\n";
#---------------------------------------------------------------------------print Dumper \ @A6_SortRankLocArr_A5;
	for (my $i= 0 ; $i <= $#A6_SortRankLocArr_A5 ; $i++){
		if ($i  <= $S23_sizeArray_A6){
		$S17_Vid_H3 = $H3_KrankVID{$A6_SortRankLocArr_A5[$i]};
		}else{
		$S17_Vid_H3 = $H3_KrankVID{$A6_SortRankLocArr_A5[$i - 1 ]}		
		}
		$S20_Vid_H3 = $H3_KrankVID{$A6_SortRankLocArr_A5[$i-1]};
		$S21_VpuntComaPar_H4 = $H4_Kid_Vbracket{$S20_Vid_H3};
			if ($S21_VpuntComaPar_H4 =~ /^,/ ){
			$S16_SubBranchgroup_S21 = $S16_SubBranchgroup_S21 + 1;
			$H8_KidVSubBranchgroup_S16{$S20_Vid_H3} = "$S16_SubBranchgroup_S21";
			}else{
                	$H8_KidVSubBranchgroup_S16{$S17_Vid_H3} = "$S16_SubBranchgroup_S21";
			$H8_KidVSubBranchgroup_S16{$S20_Vid_H3} = "$S16_SubBranchgroup_S21";
			}
	}
}

#-----------------------------------------------------------------------------------print Dumper \%H8_KidVSubBranchgroup_S16;

#H2_KidVrank_A2 Key = ID ensembl Value = rank,

foreach my $S12_Kid_H2 (keys %H2_KidVrank_A2) {
	my $S13_Vrank_H2 = $H2_KidVrank_A2{$S12_Kid_H2};
	my $S14_Vpair_H5 = $H5_KidVPairgroup_S10{$S12_Kid_H2};
	my $S15_Vbranch_H6 = $H6_KidVbranch_Ha2{$S12_Kid_H2};
	my $S24_VSubbranch_H6 = $H8_KidVSubBranchgroup_S16{$S12_Kid_H2};
	$H7_KidVBraRanPair_H2H5H6{$S12_Kid_H2} = "\#$S24_VSubbranch_H6";	
	$H9_TreeForChange{$S12_Kid_H2} = "$S12_Kid_H2\_$S15_Vbranch_H6\_$S13_Vrank_H2\_$S24_VSubbranch_H6\_$S14_Vpair_H5\_";
}
#-----------------------------------------------------------------------------------print Dumper \%H7_KidVBraRanPair_H2H5H6;

#foreach my $key (keys %H7_KidVBraRanPair_H2H5H6) {
	#print $BEDmod "$key$H7_KidVBraRanPair_H2H5H6{$key}\n";

#}
my $Branch;
foreach my $S25_TreeLine_A9 (@A9_TreeForChange){

		if ($S25_TreeLine_A9 =~ /^\(/ || $S25_TreeLine_A9 =~ /^\:/){
			my @Col_end1 = (split //, "$S25_TreeLine_A9");
#-------------------------print Dumper \@Col_end1;
			#push @A10_TreeLinesWithNumbers_A9, $S25_TreeLine_A9;
			#print "$Branch\n";
			my ($Number_end) = &Su6_NummerBranch( \@Col_end1, $Branch);
			#print "$Number_end\n";
			push @A10_TreeLinesWithNumbers_A9, "$Number_end";
			}else{
				my @Col_allBed_lin = (split /\:/, $S25_TreeLine_A9);
				#print "$H9_TreeForChange{$Col_allBed_lin[0]}\n";
				my $Numbers = "$H9_TreeForChange{$Col_allBed_lin[0]}";
				my @Col_Num = (split /\_/, "$H9_TreeForChange{$Col_allBed_lin[0]}");
				
#-------------------------print Dumper \@Col_Num;
								
				my @Col_end = (split //, "$Col_allBed_lin[1]");
#-------------------------print Dumper \@Col_end;
print "\_$Col_Num[1]\_$Col_Num[2]\_$Col_Num[3]\_\#$Col_Num[7]$Col_end[-1]\n";
			#push @A10_TreeLinesWithNumbers_A9, "$H9_TreeForChange{$Col_allBed_lin[0]}\:$Col_allBed_lin[1]";
			push @A10_TreeLinesWithNumbers_A9, "\_$Col_Num[1]\_$Col_Num[2]\_$Col_Num[3]\_\#$Col_Num[7]$Col_end[-1]";
             #print "$H9_TreeForChange{$Col_allBed_lin[0]}\:$Col_allBed_lin[1]\n";
			 $Branch =  "\#$Col_Num[7]";        	
		}
}
my $NewickFormat = join("", @A10_TreeLinesWithNumbers_A9);
print $TreeGen "$NewickFormat\n";
#foreach my $S26_TreeLine_A10 (@A10_TreeLinesWithNumbers_A9){
		#print $TreeMOD "$S26_TreeLine_A10\n";
#}
#--------------------------------------------------#---------------------------------print Dumper \@A10_TreeLinesWithNumbers_A9;

#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################

sub Su2_FirstGroup{
	my ($A1_treeLine_S1, $S2_NumberOfBranches) = @_;
	my @A1_treeLine_S1 = @{ $A1_treeLine_S1 };
my %H1_PreHa; 
my %Ha1_FirstShape_A1;
my $Su2S4_NumberBranch_Su1S3 = 0;
my @Su2A1_open_Su1A2;
foreach my $S2_Num_A1 (@A1_treeLine_S1){
	if  ($S2_Num_A1 =~ /^1\@\@\@/){
		push @Su2A1_open_Su1A2, $S2_Num_A1;
		#print "$Su2S4_NumberBranch_Su1S3 ) $S2_Num_A1\n";
#-----------------------------------------------------------------------------------print Dumper \@Su2A1_open_Su1A2;		
	}else{
		my $Su2S5_NumberElementsA_Su2A1 = @Su2A1_open_Su1A2;
#-------------------------------------------------------------------------------------------print "ID $S2_Num_A1 \n";	
        	my ($NeuNumberBranch_Su3S5) = &Su3_FS_Branch($Su2S5_NumberElementsA_Su2A1, $Su2S4_NumberBranch_Su1S3, $S2_NumberOfBranches);
		my ($I, $B) = &Su1_first_shape($NeuNumberBranch_Su3S5, $S2_Num_A1);
		$H1_PreHa{$I} = $B;
#------------------------------------------------------------------------------------------------------print "ID I=$I group B=$B \n";
#------------------------------------------------------------------------------------------------------print Dumper \@Su2A1_open_Su1A2;
		@Su2A1_open_Su1A2 = ();
#------------------------------------------------------------------------------------------------------print "Actual group $Su2S4_NumberBranch_Su1S3 \n";
		$Su2S4_NumberBranch_Su1S3 = $NeuNumberBranch_Su3S5;
#------------------------------------------------------------------------------------------------------print "New group $Su2S4_NumberBranch_Su1S3 \n";
#------------------------------------------------------------------------------------------------------print Dumper \%H1_PreHa;
	}
}
#------------------------------------------------------------------------------------------------------print Dumper \%H1_PreHa;
foreach my $Su5S5_KeyID_h1 (keys %H1_PreHa) {

if  ($Su5S5_KeyID_h1 eq "\@\@\@"){
	next;
	}else{

	my $Su5S6_ValGroup_H1 = $H1_PreHa{$Su5S5_KeyID_h1};

        push @{ $Ha1_FirstShape_A1{$Su5S6_ValGroup_H1}}, $Su5S5_KeyID_h1;
	}
}
#print " Ha1\n";
#------------------------------------------------------------------------------------------------------print Dumper \%Ha1_FirstShape_A1;
#------------------------------------------------------------------------------------------------------print Dumper \ @IDS;
return \%Ha1_FirstShape_A1;
 }

sub Su1_first_shape{
my $IDBr;
my ($Branch, $ID) = @_;

my @Col_allBed_lin = (split /\@\@\@/, $ID);
#------------------------------------------------------------------------------------------------------print Dumper \ @Col_allBed_lin;
$ID = $Col_allBed_lin[1];


	if  ($ID =~ /^:/){
		$ID ="\@\@\@";
		$Branch ="\@\@\@";
		#$H1_PreHa{"\@\@\@"} = "\@\@\@";
	return ( $ID, $Branch);	
	}else{
	$ID =~ s/(.*)(\:)(.*)/$1/g;
	return ( $ID, $Branch);
	}
#my ($A) = &Su1_first_shape_Hash($IDBr);

}


		

#-------------------------------------------------------------------------------------print Dumper \@TreeLin;
#-------------------------------------------------------------------------------------print "$aproximation\n";



sub Su3_FS_Branch{
my ($Su3S1_NumberElementsA_Su2A1, $Su3S4_NumberBranch_Su1S3, $S2_NumberOfBranches) = @_;

	if  ($Su3S1_NumberElementsA_Su2A1 >= $S2_NumberOfBranches){
		my $Su3S5_NeuNumberBranch_Su3S4 = $Su3S4_NumberBranch_Su1S3 + 1;
	return ( $Su3S5_NeuNumberBranch_Su3S4);
	}else{
		my $Su3S5_NeuNumberBranch_Su3S4 = $Su3S4_NumberBranch_Su1S3;
	return ( $Su3S5_NeuNumberBranch_Su3S4);
        	
	}
#---------------------------------------------------------------------------print Dumper \ @Su2A1_open_Su1A2;
}

sub Su6_NummerBranch{
	my ($A1_treeLine_S1, $S2_NumberOfBranches) = @_;
	my @A1_treeLine_S1 = @{ $A1_treeLine_S1 };

my @Su2A1_open_Su1A2;

	if  ("$A1_treeLine_S1[0]" eq "\(" ){
	#if  ("$A1_treeLine_S1[0]" eq "\:" && "$A1_treeLine_S1[-1]" eq "\," ){
		#push @Su2A1_open_Su1A2, $S2_Num_A1;
		#print "$S2_NumberOfBranches$A1_treeLine_S1[-1]\n";
		print " Hola $A1_treeLine_S1[0]\n";
		return "$A1_treeLine_S1[0]";
		
#-----------------------------------------------------------------------------------print Dumper \@Su2A1_open_Su1A2;		
	}elsif ("$A1_treeLine_S1[0]" eq "\:" && "$A1_treeLine_S1[-1]" eq "\)" || "$A1_treeLine_S1[-1]" eq "\;"){
		#print "$A1_treeLine_S1[-1]\n";
		return "$A1_treeLine_S1[-1]";
	}elsif ("$A1_treeLine_S1[0]" eq "\:" && "$A1_treeLine_S1[-1]" eq "\," || "$A1_treeLine_S1[-1]" ne "\;"){
		
		#print "$S2_NumberOfBranches$A1_treeLine_S1[-1]\n";
		return "$S2_NumberOfBranches$A1_treeLine_S1[-1]";
		
#------------------------------------------------------------------------------------------------------print "New group $Su2S4_NumberBranch_Su1S3 \n";
#------------------------------------------------------------------------------------------------------print Dumper \%H1_PreHa;
	}

}


