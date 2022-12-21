#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;





open my $PEP, "< $ARGV[0]";  
open my $CDS, "< $ARGV[1]";
open my $DICTI, "> $ARGV[0].dict";
open my $NEW_PEP, "> $ARGV[0].dict.fa"; 
open my $NEW_CDS, "> $ARGV[1].dict.fa"; 
my $S3_Ortholog_group_number = $ARGV[0];
my @A10_SplitOrthologNam_S3 = (split /\//, $S3_Ortholog_group_number);
my @A1_SplitOrthologNam_S3 = (split /\_/, $A10_SplitOrthologNam_S3[-1]);
print "$A1_SplitOrthologNam_S3[1]\n";


my %H3_KNweHeaderVFasOLPep_H1;
my %H4_KNweHeaderVFasOLCds_H2;
#Convert Pep Fasta to Hash (Key = header Value = secuence onle line)
my ($Ha1_KHeaderVFasOLPep, $H1_KHeaderVFasOLPep_Su5) = Su5_OneLineFASTA( $PEP);
my %H1_KHeaderVFasOLPep_Su5 = %$H1_KHeaderVFasOLPep_Su5;
#Convert cds Fasta to Hash (Key = header Value = secuence onle line)
my ($Ha2_KHeaderVFasOLCDS, $H2_KHeaderVFasOLCds_Su5) = Su5_OneLineFASTA( $CDS);
my %H2_KHeaderVFasOLCds_Su5 = %$H2_KHeaderVFasOLCds_Su5;


my $Count = 1;
#Foreach header in Pep fasta
foreach my $S1_KeyHead_h1 (keys %H1_KHeaderVFasOLPep_Su5) {
	#$S1 header with (>) >cjaponica@@@TRINITY_DN3056_c0_g2_i2.p1 $S2 header without (>) cjaponica@@@TRINITY_DN3056_c0_g2_i2.p1
	my $S2_KeyHeadNobigger_S1 = $S1_KeyHead_h1;
	$S2_KeyHeadNobigger_S1 =~ s/(>)(.*)/$2/g;
	#split Header with out (>) by @@@ , cjaponica@@@TRINITY_DN3056_c0_g2_i2.p1 and put in array (@Col_Header_S1)-> @Col_Header_S1 = [0]cjaponica[1]TRINITY_DN3056_c0_g2_i2.p1
	my @Col_Header_S1 = (split /\@\@\@/, $S2_KeyHeadNobigger_S1);
	#                            |\_$Col_Header_S1[0]\_         $A1_SplitOrthologNam_S3[1]           \_$Count\_         \t  $S1_KeyHead_h1\n
	#Generate a Dictionary filels|               _Name_OrthologGrupNumber(come from the pep file name)_sequenceNumber_  Tap headrer with (>) ->_cjaponica_1_7_	'>cjaponica@@@TRINITY_DN3056_c0_g2_i2.p1'
	print $DICTI "\_$Col_Header_S1[0]\_$A1_SplitOrthologNam_S3[1]\_$Count\_\t$S1_KeyHead_h1\n";
	#                             |>\_$Col_Header_S1[0]\_$A1_SplitOrthologNam_S3[1]                    \_$Count       \_\n $H1_KHeaderVFasOLPep_Su5{$S1_KeyHead_h1}\n
	#Generate pep with new headers|               _>Name_OrthologGrupNumber(come from the pep file name)_sequenceNumber_   Pep Secuence
	print $NEW_PEP ">\_$Col_Header_S1[0]\_$A1_SplitOrthologNam_S3[1]\_$Count\_\n$H1_KHeaderVFasOLPep_Su5{$S1_KeyHead_h1}\n";
		#                             |>\_$Col_Header_S1[0]\_$A1_SplitOrthologNam_S3[1]                     \_  $Count     \_  \n $H2_KHeaderVFasOLCds_Su5{$S1_KeyHead_h1}\n
	#Generate cds with new headers|               _>Name    _OrthologGrupNumber(come from the pep file name)_sequence Number_      cds Secuence
	print $NEW_CDS ">\_$Col_Header_S1[0]\_$A1_SplitOrthologNam_S3[1]\_$Count\_\n$H2_KHeaderVFasOLCds_Su5{$S1_KeyHead_h1}\n";
	$Count = $Count + 1;
}



sub Su5_OneLineFASTA {
	my $FAS = $_[0];
	

	my $line = <$FAS>;
	my @A6_Headers;
	$line =~ s/(.*)\s+/$1/g;
	push @A6_Headers, $line;
	my @A7_Seq;
	my %Ha4_KHeaderVFasta;
	my %H5_KHeaderVFastaOneline_Ha4;


	while ($line = <$FAS>){
	
		chomp $line;
		my $S7_Seq;
		if ($line=~m/^(?!>)/gi ) { 
				$S7_Seq = $line;
				push @A7_Seq, $S7_Seq;
   			}else { 
				$S7_Seq = join("", @A7_Seq);
				foreach my $S1 (@A7_Seq){
        			push @{ $Ha4_KHeaderVFasta{$A6_Headers[0]}}, $S1;
        		}
				@A7_Seq = ();
				@A6_Headers = ();
				push @A6_Headers, $line;
		}
	}
	my $S7_Seq = join("", @A7_Seq);

 	foreach my $S1 (@A7_Seq){
    	push @{ $Ha4_KHeaderVFasta{$A6_Headers[0]}}, $S1;
    }
	#--------------------------------------------------------------	print Dumper \@A6_Headers;

	#--------------------------------------------------------------	print Dumper \%Ha4_KHeaderVFasta;



	foreach my $S5_KeyHead_Ha4 (keys %Ha4_KHeaderVFasta) {
		my @array = @{$Ha4_KHeaderVFasta{$S5_KeyHead_Ha4}};
		my $S9_Seq = join("", @array);
		$H5_KHeaderVFastaOneline_Ha4{$S5_KeyHead_Ha4} = $S9_Seq;
	}

	return (\%Ha4_KHeaderVFasta, \%H5_KHeaderVFastaOneline_Ha4 );
}
exit;
