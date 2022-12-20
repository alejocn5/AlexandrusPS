#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);


my %H1_ConKheaderVscore_A1;
my %H2_KlineVheader_A1; 
my %H3_KheaderVseq;
my %Ha_ClineVcorrect_S2;


open my $FASTA, "< $ARGV[0]";
open my $List_Trans_pepEvid, "< $ARGV[1]";



open my $FinalFasta, "> $ARGV[1].pep.fasta";


my @A5_lineQuanti_S2;



##########################################################################################Generate hash H5 key header value ecuence one line Ha4 key header value array with the fasta secuence example >TRINITY_GG_13388_c0_g1_i1.p9 TRINITY_GG_13388_c0_g1~~TRINITY_GG_13388_c0_g1_i1.p9  ORF type:5prime_partial len:35 (+),score=2.34 TRINITY_GG_13388_c0_g1_i1:2-106(+)' => 'GAATATTTGATTCAGATTAATTTGACAACGAAGGAATTTGATTGTTGTGATTACGTAAATGGGTATCAGGGGCGAGATTATTTGTTAAACAGAGATCGAAAATAA',
my ($Ha4_KHeaderVFastaNoOneline, $H5_KHeaderVFastaOneline_Su5) = Su5_OneLineFASTA( $FASTA);
my %H5_KHeaderVFastaOneline_Su5 = %$H5_KHeaderVFastaOneline_Su5;
my %Ha4_KHeaderVFastaNoOneline = %$Ha4_KHeaderVFastaNoOneline;


#Extract Sequences from the /[POG_id].list file
	while (my $S1_listPepEv = <$List_Trans_pepEvid>){#2
        chomp $S1_listPepEv; 
		my ( $S2_hedearH5greped_S1H5 ) = grep {/>$S1_listPepEv/} keys %H5_KHeaderVFastaOneline_Su5;
		my $S3_headerNobiger_S2 = $S2_hedearH5greped_S1H5;
		$S3_headerNobiger_S2 =~ s/(>)(.*)/$2/g;
		print $FinalFasta "$S2_hedearH5greped_S1H5\n$H5_KHeaderVFastaOneline_Su5{$S2_hedearH5greped_S1H5}\n";

	}#2  
#Extract Sequences
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



	foreach my $S5_KeyHead_Ha4 (keys %Ha4_KHeaderVFasta) {
		my @array = @{$Ha4_KHeaderVFasta{$S5_KeyHead_Ha4}};
		my $S9_Seq = join("", @array);
		$H5_KHeaderVFastaOneline_Ha4{$S5_KeyHead_Ha4} = $S9_Seq;
	}

	return (\%Ha4_KHeaderVFasta, \%H5_KHeaderVFastaOneline_Ha4 );
}
exit;
