#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;




open my $Parameter_codeml, "< $ARGV[0]";
open my $Parameter_codeml_Def, "< $ARGV[1]";
my $Orthology_group = "$ARGV[2]";

open my $OutGenTree, "> codeml$Orthology_group.gt8.ctl";

my %H1_Parameters;
my %H2_ParametersDef;

while (my $linPara = <$Parameter_codeml>){#2
    chomp $linPara;
    if  ($linPara =~ /^#/){
        next;
	}else{
        my @Col_Parameter = (split /\=/, $linPara);
        $H1_Parameters{"$Col_Parameter[0]"} = "$Col_Parameter[1]"; 
    }
}#2  

while (my $linParaDef = <$Parameter_codeml_Def>){#2
    chomp $linParaDef;
    if  ($linParaDef =~ /^#/){
        next;
	}else{
        my @Col_ParameterDef = (split /\=/, $linParaDef); 
        $H2_ParametersDef{"$Col_ParameterDef[0]"} = "$Col_ParameterDef[1]"; 
	}
}#2 
#---------------------------------------------------------print $OutGenTree Dumper \%H2_ParametersDef;
#      seqfile = _1_.codonalign.fasta 
print $OutGenTree "\tseqfile \= $Orthology_group.codonalign.fasta\n";
#     treefile = _1_.pep.fa.dict.fa.best.nex.cl.head.nex _1_.pep.fa.dict.fa.best.nex.cl.head.dnd.GenTree.nex
print $OutGenTree "\ttreefile \= $Orthology_group.list.pep.fasta.dict.fa.best.nex.cl.head.dnd.GenTree.nex\n";
#      outfile = _1_.mlc
print $OutGenTree "\toutfile \= $Orthology_group.gt8.mlc\n\n";
#	noisy = 9 
my ($noisy) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "noisy");  
print $OutGenTree "\tnoisy \= $noisy\n";
#   verbose = 1
my ($verbose) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "verbose");  
print $OutGenTree "\tverbose \= $verbose\n";
#   runmode = 0
my ($runmode) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "runmode");  
print $OutGenTree "\trunmode \= $runmode\n\n";
#   seqtype = 1
my ($seqtype) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "seqtype");  
print $OutGenTree "\tseqtype \= $seqtype\n";
#   CodonFreq = 2
my ($CodonFreq) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "CodonFreq");  
print $OutGenTree "\tCodonFreq \= $CodonFreq\n\n";
#   *        ndata = 10
my ($ndata) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "ndata");  
print $OutGenTree "\*\tndata \= $ndata\n";
#   clock = 0
my ($clock) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "clock");  
print $OutGenTree "\tclock \= $clock\n";
#   aaDist = 0
my ($aaDist) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "aaDist");  
print $OutGenTree "\taaDist \= $aaDist\n";
#   aaRatefile = dat/jones.dat
my ($aaRatefile) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "aaRatefile");  
print $OutGenTree "\taaRatefile \= $aaRatefile\n\n";
#    model = 2
my ($model) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "model");  
print $OutGenTree "\tmodel \= $model\n\n";
#   NSsites = 0
my ($NSsites) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "NSsites");  
print $OutGenTree "\tNSsites \= $NSsites\n\n";
#   icode = 0
my ($icode) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "icode");  
print $OutGenTree "\ticode \= $icode\n";
#   Mgene = 0
my ($Mgene) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "Mgene");  
print $OutGenTree "\tMgene \= $Mgene\n\n";
#   fix_kappa = 0
my ($fix_kappa) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "fix_kappa");  
print $OutGenTree "\tfix_kappa \= $fix_kappa\n";
#   kappa = 2
my ($kappa) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "kappa");  
print $OutGenTree "\tkappa \= $kappa\n";
#   fix_omega = 0
my ($fix_omega) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "fix_omega");  
print $OutGenTree "\tfix_omega \= $fix_omega\n";
#   omega = .4
my ($omega) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "omega");  
print $OutGenTree "\tomega \= $omega\n\n";
#   fix_alpha = 1
my ($fix_alpha) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "fix_alpha");  
print $OutGenTree "\tfix_alpha \= $fix_alpha\n";
#   alpha = 0.
my ($alpha) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "alpha");  
print $OutGenTree "\talpha \= $alpha\n";
#   Malpha = 0
my ($Malpha) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "Malpha");  
print $OutGenTree "\tMalpha \= $Malpha\n";
#   ncatG = 8
my ($ncatG) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "ncatG");  
print $OutGenTree "\tncatG \= $ncatG\n\n";
#   getSE = 0
my ($getSE) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "getSE");  
print $OutGenTree "\tgetSE \= $getSE\n";
#   RateAncestor = 1
my ($RateAncestor) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "RateAncestor");  
print $OutGenTree "\tRateAncestor \= $RateAncestor\n\n";
#   Small_Diff = .5e-6
my ($Small_Diff) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "Small_Diff");  
print $OutGenTree "\tSmall_Diff \= $Small_Diff\n";
#   cleandata = 1
my ($cleandata) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "cleandata");  
print $OutGenTree "\tcleandata \= $cleandata\n";
#   * fix_blength = -1
my ($fix_blength) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "fix_blength");  
print $OutGenTree "\*\tfix_blength \= $fix_blength\n";
#   method = 0
my ($method) = &Fill_parameters( \%H1_Parameters, \%H2_ParametersDef, "method");  
print $OutGenTree "\tmethod \= $method\n\n";




# exit;

sub Fill_parameters {
    my %Par = %{shift()};
    my %ParDef = %{ shift() };
    my $name  = shift;

	if (exists($Par{$name})){
	    my $P = $Par{$name};
        return $P;
	}else{
        my $P = $ParDef{$name};
        return $P;
	}
}

