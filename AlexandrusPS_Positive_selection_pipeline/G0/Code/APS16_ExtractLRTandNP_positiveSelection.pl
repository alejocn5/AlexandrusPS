#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;





open my $NEX, "< $ARGV[0]";
open my $M8SS, "< $ARGV[1]";
open my $M0SS, "< $ARGV[2]";

my $GroupNumber = $ARGV[0]; 
my @Col_ID = (split /\_/, $GroupNumber); 


my @A1_lineNex_S1;
my $S2_SpStart_A1;
my $S2_SpEnd_A1;
my $M0;
my $M1;
my $M2;
my $M3;
my $M7;
my $M8;
my @Species;
my @Coordenates;
my %Hash_of_models;
my %positive_site;
my @m8A;
my @m0A;

while (my $S1_liNex = <$NEX>){#2
    chomp $S1_liNex; 
    push  @A1_lineNex_S1, $S1_liNex; 
}#2 
while (my $m8 = <$M8SS>){#2
    chomp $m8; 
    push  @m8A, $m8; 
}#2 
while (my $m0 = <$M0SS>){#2
    chomp $m0; 
    push  @m0A, $m0; 
}#2 


my $S3_NexTreeNumber_A1;
my $count;
my @A2_TableNumRef_s4; 
for (my $i= 0 ; $i <= $#A1_lineNex_S1 ; $i ++){

	if  ( $A1_lineNex_S1[$i]=~ /^#/){
		my $specie = $A1_lineNex_S1[$i];
		$specie =~ s/(\#)(.*)(\:)\s+(\_)(.*)(\_)(.*)(\_)(.*)(\_)/$5/g;
		$specie =~ s/(.*)(\s+)/$1/g;
		my @Col_Sp = (split /\s+/, $specie);
		push  @Species, $Col_Sp[0]; 
	}
	elsif ($A1_lineNex_S1[$i]=~ /^Model 0/){
		$M0 = $i;
		push  @Coordenates, $i; 	
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 1/  ){
		$M1 = $i;
		push  @Coordenates, $i;		
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 2/  ){
		$M2 = $i;
		push  @Coordenates, $i;
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 3/  ){
		$M3 = $i;
		push  @Coordenates, $i;
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 7/  ){
		$M7 = $i;
		push  @Coordenates, $i;						
	}else{
        next;
	} 
}
my $size = @A1_lineNex_S1;
push @Coordenates, $size;


my $c = 0;
foreach my $mis_scad (@Coordenates){

	my $Begin = $Coordenates[$c-1];
	my $End = $Coordenates[$c]-1;
	 
	for (my $i= $Begin ; $i <= $End ; $i ++){
		my @Col_line = (split /\s+/, $A1_lineNex_S1[$i]);
		my $sizeLine = @Col_line;
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $A1_lineNex_S1[$i]=~ /^lnL/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;
			my @Col_ln = (split /\s+/, $A1_lineNex_S1[$i]);
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		&Models_np_lnL($Col_name[0],$Mod,$NP,$Col_ln[4]);

		}elsif ($A1_lineNex_S1[$i]=~ /^p\:/ && $A1_lineNex_S1[$Begin]=~ /^Model 1/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			
			my @Col_P_M1 = (split /\s+/, $A1_lineNex_S1[$i]);
			$Hash_of_models{"M1_p0"} = "$Col_P_M1[1]";
			$Hash_of_models{"M1_p1"} = "$Col_P_M1[2]";	
		}elsif ($A1_lineNex_S1[$i]=~ /^w\:/ && $A1_lineNex_S1[$Begin]=~ /^Model 1/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			
			my @Col_P_M1 = (split /\s+/, $A1_lineNex_S1[$i]);
			$Hash_of_models{"M1_w0"} = "$Col_P_M1[1]";
			$Hash_of_models{"M1_w1"} = "$Col_P_M1[2]";
		}elsif ($A1_lineNex_S1[$i]=~ /^\s+p/ && $A1_lineNex_S1[$Begin]=~ /^Model 7/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			my @Col_P_M7 = (split /\s+/, $A1_lineNex_S1[$i]);
			$Hash_of_models{"M7_p"} = "$Col_P_M7[-4]";
			$Hash_of_models{"M7_q"} = "$Col_P_M7[-1]";
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/ && $Col_sig[-1]=~ /^\*/&& $Col_sig[-2]=~ /^\*/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;	 
		push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]\*\*";
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/ && $Col_sig[-1]=~ /^\*/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;	 
		push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]\*";
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
		$Mod =~ s/(.*)(\:)/$1/g;
    	push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]";
		push  @Coordenates, $i;						
		}else{
        	next;
		}
	}
$c = $c +1;	
}

for (my $i= 0 ; $i <= $#m8A ; $i ++){
		my @Col_line = (split /\s+/, $m8A[$i]);
		my $sizeLine = @Col_line;
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $m8A[$i]=~ /^lnL/){

			my @Col_ln = (split /\s+/, $m8A[$i]);
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		$Hash_of_models{"M8\_lnL"} = "$Col_ln[4]";
		$Hash_of_models{"M8\_np"} = "$NP";
		}elsif ($m8A[$i]=~ /^\s+p0/ ){
			my @Col_P_M8 = (split /\s+/, $m8A[$i]);
			$Hash_of_models{"M8_p0"} = "$Col_P_M8[-7]";
			$Hash_of_models{"M8_p"} = "$Col_P_M8[-4]";
			$Hash_of_models{"M8_q"} = "$Col_P_M8[-1]";	
		}elsif ($m8A[$i]=~ /^\s+\(p1/ ){
			my @Col_P_M8 = (split /\s+/, $m8A[$i]);
			my $M8p =  $Col_P_M8[-4];
			$M8p =~ s/(.*)(\))/$1/g;
			$Hash_of_models{"M8_p1"} = $M8p;
			$Hash_of_models{"M8_w"} = "$Col_P_M8[-1]";
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&   $Col_sig[-1]=~ /^\*/&& $Col_sig[-2]=~ /^\*/){
		push @{ $positive_site{"M8_PSS"}}, "$Col_line[1]$Col_line[2]\*\*";
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ && $Col_sig[-1]=~ /^\*/){
		push @{ $positive_site{"M8_PSS"}}, "$Col_line[1]$Col_line[2]\*";
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ ){
		push @{ $positive_site{"M8_PSS"}}, "$Col_line[1]$Col_line[2]";					
		}else{
        	next;
		}
	}

for (my $i= 0 ; $i <= $#m0A ; $i ++){
		my @Col_line = (split /\s+/, $m0A[$i]);
		my $sizeLine = @Col_line;
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $m0A[$i]=~ /^omega/){
			my @Col_ln = (split /\s+/, $m0A[$i]);
		 my $NP = $Col_ln[3];
		 $Hash_of_models{"M0_w"} = "$NP";
			
		}else{
        	next;
		}
	}



my @Variables = ("ID", "SP", "M0_lnL", "M0_np", "M0_w", "M1_lnL", "M1_np", "M1_p0", "M1_p1", "M1_w0", "M1_w1", "M2_lnL", "M2_np", "M3_lnL", "M3_np", "M7_lnL", "M7_np", "M7_p", "M7_q", "M8_lnL", "M8_np", "M8_p0", "M8_p", "M8_q", "M8_p1", "M8_w", "M0_PSS", "M1_PSS", "M2_PSS", "M3_PSS", "M7_PSS", "M8_PSS"); 



my @sorted_Species = sort @Species;
my $Species = join(",", @sorted_Species);
foreach my $Key_ps (keys %positive_site) {
	my @Uniq = uniq @{$positive_site{$Key_ps}};
	my $PSS = join(",",@Uniq) ;
	$Hash_of_models{"$Key_ps"} = $PSS;
}

$Hash_of_models{"ID"} = "$Col_ID[-2]";
$Hash_of_models{"SP"} = "$Species";

foreach my $key (@Variables){
	if (exists($Hash_of_models{$key})){
  		next;
		  
	}else{
        $Hash_of_models{$key} = "NA";	
	}
}


print "$Hash_of_models{ID}\t$Hash_of_models{SP}\t$Hash_of_models{M0_lnL}\t$Hash_of_models{M0_np}\t$Hash_of_models{M0_w}\t$Hash_of_models{M1_lnL}\t$Hash_of_models{M1_np}\t$Hash_of_models{M1_p0}\t$Hash_of_models{M1_p1}\t$Hash_of_models{M1_w0}\t$Hash_of_models{M1_w1}\t$Hash_of_models{M2_lnL}\t$Hash_of_models{M2_np}\t$Hash_of_models{M3_lnL}\t$Hash_of_models{M3_np}\t$Hash_of_models{M7_lnL}\t$Hash_of_models{M7_np}\t$Hash_of_models{M7_p}\t$Hash_of_models{M7_q}\t$Hash_of_models{M8_lnL}\t$Hash_of_models{M8_np}\t$Hash_of_models{M8_p0}\t$Hash_of_models{M8_p}\t$Hash_of_models{M8_q}\t$Hash_of_models{M8_p1}\t$Hash_of_models{M8_w}\t$Hash_of_models{M0_PSS}\t$Hash_of_models{M1_PSS}\t$Hash_of_models{M2_PSS}\t$Hash_of_models{M3_PSS}\t$Hash_of_models{M7_PSS}\t$Hash_of_models{M8_PSS}\n";




sub Split_Phylip{
my $Line = $_[0];
my @Split;

 

	if (length $Line){
		@Split = (split //, $Line);
		return \@Split;
	}else{
		push  @Split, 0;
		push  @Split, 0;
		push  @Split, 0;
		push  @Split, 0;
		return \@Split;

	}

}

sub Models_np_lnL{
my $Model = $_[0];
my $Number = $_[1];
my $np = $_[2];
my $lnL = $_[3];

	if ($Model=~ /^Model/){
		$Hash_of_models{"M$Number\_lnL"} = "$lnL";
		$Hash_of_models{"M$Number\_np"} = "$np";
	}else{
		print "";
	}
}


