#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;
use Cwd;

#recomendations: check that all the sequences are represented in both fasta files (.pep.fasta and .cds.fasta), with the same headers, also we recommend those headers should be simple (no special characters)  and short as possible.
#This script generate a Specie name index, which is simply the sum of the three first letters of the genus and the three first letters of the specific epithet of a binomial nomenclature
#also, do quality control of the sequences:  look that all the sequences in the peptide file exist in the dna file, if one of the protein sequences is absent in the dna sequence file, generate an error file with those sequences allowing the user to check the reason. 
# what to do if I find sequences in the missed_sequences.txt file?
#-look in the .cds.fasta that you provided the exact header(s) that appears in missed_sequences.txt, if you find the exact header in this file, delete any special character in the headers or make the headers as simple (no special characters)  and short as possible.
#Input = Fasta file
open my $PEP, "< $ARGV[0]";
open my $CDS, "< $ARGV[1]";
my $directory = $ARGV[2];
# Get the absolute path of the provided directory
$directory = Cwd::abs_path($directory);

my @A1_pepHeader_h1;
my @A2_pepSeq_h1;
my @A3_cdsHeader_h2;
my @A4_CdsSeq_h2;

my ($Ha1_KHeaderVFastaNoOnelinePEP, $H1_KHeaderVFastaOnelinePEP_Su5) = Su5_OneLineFASTA( $PEP);
my %H1_KHeaderVFastaOnelinePEP_Su5 = %$H1_KHeaderVFastaOnelinePEP_Su5;


my ($Ha2_KHeaderVFastaNoOnelineCDS, $H2_KHeaderVFastaOnelineCDS_Su5) = Su5_OneLineFASTA( $CDS);
my %H2_KHeaderVFastaOnelineCDS_Su5 = %$H2_KHeaderVFastaOnelineCDS_Su5;


my $S1_FastaName = "$ARGV[0]";
my $Scientific_name;
 
#Split the path of the file
	my @A1_Splitpath_S1 = (split /\//, $S1_FastaName);
#Leave just the Specie name
	my @A2_NameSpecie_A1 = (split /\./, $A1_Splitpath_S1[-1]);
#Extract cientific name
	$Scientific_name = $A2_NameSpecie_A1[0];
	my $seqType = $A2_NameSpecie_A1[-2];
	my @A3_NameSpecie_A2 = (split /\_/, $Scientific_name);
#generate the Specie name Index of 6 leters (3 from the genus and 3 from the specific epithet)
my $genus = $A3_NameSpecie_A2[0];
my $specific_epithet = $A3_NameSpecie_A2[1];
	my @A4_genusReduction_A3 = (split //, $genus);
	my @A5_specificEpithetReduction_A3 = (split //, $specific_epithet);
my $Specie_name_Index = "$A4_genusReduction_A3[0]$A4_genusReduction_A3[1]$A4_genusReduction_A3[2]$A5_specificEpithetReduction_A3[0]$A5_specificEpithetReduction_A3[1]$A5_specificEpithetReduction_A3[2]";
open my $SPNewPEP, "> $directory/$Specie_name_Index.cur.pep.fasta";
open my $AllSPpep, ">> $directory/CompiledSpecies.pep.fasta";
open my $AllSPcds, ">> $directory/CompiledSpecies.cds.fasta";
open my $dic, ">> $directory/Specie_name_index_directory.txt";
print $dic "$Specie_name_Index\t$Scientific_name\n";
#Add Index to the header, and generate Error file for missed sequences
	foreach my $S1_KeyHead_h1 (keys %H1_KHeaderVFastaOnelinePEP_Su5) {
				my $Fasta_sequence_pep = $H1_KHeaderVFastaOnelinePEP_Su5{$S1_KeyHead_h1};
				my $Fasta_sequence_cds = $H2_KHeaderVFastaOnelineCDS_Su5{$S1_KeyHead_h1};
				my $S2_KeyHeadPEP_h1 = $S1_KeyHead_h1;
				my $S3_KeyHeadCDS_h1 = $S1_KeyHead_h1;
				$S2_KeyHeadPEP_h1 =~ s/(>)(.*)/$2/g;
				$S3_KeyHeadCDS_h1 =~ s/(>)(.*)/$2/g;
			if (exists($H2_KHeaderVFastaOnelineCDS_Su5{$S1_KeyHead_h1})){					
					print "";

			print $AllSPcds ">$Specie_name_Index\@\@\@$S3_KeyHeadCDS_h1\n$Fasta_sequence_cds\n";
			push @A3_cdsHeader_h2, ">$Specie_name_Index\@\@\@$S3_KeyHeadCDS_h1"; 
			push @A4_CdsSeq_h2, $Fasta_sequence_cds; 	
				}else{
					open my $Missed_file, ">> $directory/Error_missed_sequences.txt";

					print $Missed_file "$S1_KeyHead_h1\n$Fasta_sequence_pep\n"; 
			}
		
			print $SPNewPEP ">$Specie_name_Index\@\@\@$S2_KeyHeadPEP_h1\n$Fasta_sequence_pep\n";
			print $AllSPpep ">$Specie_name_Index\@\@\@$S2_KeyHeadPEP_h1\n$Fasta_sequence_pep\n";
			push @A1_pepHeader_h1, ">$Specie_name_Index\@\@\@$S2_KeyHeadPEP_h1"; 
			push @A2_pepSeq_h1, $Fasta_sequence_pep;	

	}
#check that the resulting file does not contain empty fasta sequences (header but no sequence), contain empty files and the pep.fasta file and the .cds.fasta file contain the same amount of sequences, in case one of those assumptions are false it will generate an empty file “Error_with_Fasta_header.txt
my @A1_pepHeaderUNIQ_h1 = uniq @A1_pepHeader_h1;
my $S4_pepHeader_h1 = @A1_pepHeaderUNIQ_h1;
my @A2_pepSeqUNIQ_h1= uniq @A2_pepSeq_h1;
my $S5_pepSeq_h1 = @A2_pepSeqUNIQ_h1;
my @A3_cdsHeaderUNIQ_h2 = uniq @A3_cdsHeader_h2;
my $S6_cdsHeader_h2 = @A3_cdsHeaderUNIQ_h2;
my @A4_CdsSeqUNIQ_h2 = uniq @A4_CdsSeq_h2; 
my $S7_CdsSeq_h2 = @A4_CdsSeqUNIQ_h2;

#
my ($CreateErrorFile) = &Error_file_empty_fasta_Files( $S4_pepHeader_h1, $S5_pepSeq_h1, $S6_cdsHeader_h2, $S7_CdsSeq_h2);

sub Error_file_empty_fasta_Files {
    my ($pepHeader, $pepSeq, $cdsHeader, $cdsSeq) = @_;
	if  ($pepHeader <= 1  || $pepSeq <= 1  || $CDSemptynes <= 1  || $cdsHeader <= 1  || $cdsSeq <= 1 ){
		open my $Error_seq, ">> $directory/Error_with_Fasta_header.txt";
		print $Error_seq "";
	}else{
        print "";
	}
}



sub empty {
    my ($Header, $Seq) = @_;
    if  ($Header > 0  && $Seq > 0){
		return "1";
	}else{
        return "0";
	}


}

sub NoEmptyHeaders {
    my ($Header, $Seq) = @_;
    if  ($Header == $Seq){
		return "1";
	}else{
        return "0";
	}

}

sub CDScomparablePEP {
    my ($HeaderCDS, $HeaderPEP) = @_;
    if  ($HeaderCDS == $HeaderPEP){
		return "1";
	}else{
        return "0";
	}

}
#Convert Fasta file to a hash (Key = header Value= sequence)
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
