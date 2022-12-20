#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;





open my $NEX, "< $ARGV[0]";
open my $TAB, "> $ARGV[0].dict";
open my $NEW_NEX, "> $ARGV[0].cl.nex";
open my $NEW_NEX_H, "> $ARGV[0].cl.head.nex";   

my @A1_lineNex_S1;
my %H1_KnumberIntreeVheader_S4;
my @A4_FinalArrayPhulip_A1;

while (my $S1_liNex = <$NEX>){#2
    chomp $S1_liNex; 
    push  @A1_lineNex_S1, $S1_liNex; 
}#2 


my $S2_ConversionTableNumber_A1;
my $S3_NexTreeNumber_A1;
my $count = 0;
my @A2_TableNumRef_s4; 
for (my $i= 0 ; $i <= $#A1_lineNex_S1 ; $i ++){

	if  ( $A1_lineNex_S1[$i]=~ /^ translate/){
		$S2_ConversionTableNumber_A1 = $i;
	}
	elsif ($A1_lineNex_S1[$i]=~ /^ tree/){
		$S3_NexTreeNumber_A1 = $i;					
	}else{
        next;
	} 
}

for (my $i= $S2_ConversionTableNumber_A1+1 ; $i < $S3_NexTreeNumber_A1-1 ; $i ++){
	my $S4_lineTable = $A1_lineNex_S1[$i];
	$S4_lineTable =~ s/(.*)(\')(.*)(\')/$1\t$3/g;
	my @Col_Table = (split /\s+/, $S4_lineTable);
	my @Col_coma = (split /\,/, $Col_Table[2]);
	print $TAB "$Col_Table[1]\t$Col_coma[0]\n";
	push  @A2_TableNumRef_s4, $Col_Table[1];
	$H1_KnumberIntreeVheader_S4{$Col_Table[1]} = $Col_coma[0];
}
my @A3_rev_TableNumRef_A2 = reverse @A2_TableNumRef_s4;

my @Split_nex;
for (my $i= $S3_NexTreeNumber_A1+1 ; $i < $#A1_lineNex_S1 ; $i ++){
	print $NEW_NEX "$A1_lineNex_S1[$i]\n";
	my $Tree ="$A1_lineNex_S1[$i]";
		foreach my $Num_Table (@A3_rev_TableNumRef_A2){
			my $Num = "$Num_Table\:";
			my $new = $Tree =~ s/$Num/$H1_KnumberIntreeVheader_S4{$Num_Table}\:/r;
			$Tree = $new;
			
		}
		print $NEW_NEX_H "$Tree\n";
		@Split_nex = (split /\(/, $Tree);
		
}
;
foreach my $Num_Table (@Split_nex){
	my @Split_tab = (split //, $Num_Table);

	my $nu = @Split_tab;
	if  ($nu == 0){
		push  @A4_FinalArrayPhulip_A1, "(";
	}else{
	push  @A4_FinalArrayPhulip_A1, "(";
        my $ProtReal = &Split_Phylip("$Num_Table");
	}
}
shift @A4_FinalArrayPhulip_A1;

open my $PHY, "> $ARGV[0].cl.head.dnd";
foreach my $out (@A4_FinalArrayPhulip_A1){
	print $PHY "$out\n";
	print  "$out\n";
}

exit;

sub Split_Phylip{
my $Line = $_[0];
my @Split = (split /\)/, $Line);

		
		my $last_one = pop @Split;
				push @Split, "$last_one\#";

	foreach my $linSplit (@Split){
		my @Split_pun = (split /\,/, $linSplit);
		
		


		my @Split_space = (split //, $linSplit);
		my $Number = @Split_pun;
		if  ( $Number == 2 && $Split_space[-1]=~ /\#/){
			$linSplit =~ s/(.*)(\#)/$1/g;
			push  @A4_FinalArrayPhulip_A1, $linSplit;
		}
		elsif ($Number >= 2 && $Split_space[-1]!~ /\#/ ){
			my @Split_coma = (split /\,/, $linSplit);
			push  @A4_FinalArrayPhulip_A1, "$Split_coma[0]\,";
			push  @A4_FinalArrayPhulip_A1, "$Split_coma[-1]\)";
		}elsif ($Number < 2 && $Split_space[-1]=~ /\#/ ){
			$linSplit =~ s/(.*)(\#)/$1/g;
			push  @A4_FinalArrayPhulip_A1, $linSplit;				
		}else{
			my @Split_coma = (split /\,/, $linSplit);
			push  @A4_FinalArrayPhulip_A1, "$Split_coma[0]\)";
		} 
	}
}
