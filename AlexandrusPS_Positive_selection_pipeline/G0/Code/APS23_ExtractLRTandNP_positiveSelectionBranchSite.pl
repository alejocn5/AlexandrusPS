#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;





open my $NEX, "< $ARGV[0]";
open my $BSM0, "< $ARGV[1]";
open my $BSM0H0, "< $ARGV[2]";
open my $BSM0H1, "< $ARGV[3]";

my $GroupNumber = $ARGV[1]; 
$GroupNumber =~ s/(\.\/)(.*)(\.bsm0.mlc)/$2/g;

#----------------------------------------------------------------print Dumper \@Col_ID;

my @A1_lineNex_S1;
my $S2_SpStart_A1;
my $S2_SpEnd_A1;
my $M0;
my $M1;
my $M2;
my $M3;
my $M7;
my $bsM0;
my @Species;
my @Coordenates;
my %Hash_of_models;
my %positive_site;
my @bsm0A;
my @bsm0h0;
my @bsm0h1A;

while (my $S1_liNex = <$NEX>){#2
    chomp $S1_liNex; 
    push  @A1_lineNex_S1, $S1_liNex; 
}#2 
while (my $bsm0 = <$BSM0>){#2
    chomp $bsm0; 
    push  @bsm0A, $bsm0; 
}#2 
while (my $bsm0h0 = <$BSM0H0>){#2
    chomp $bsm0h0; 
    push  @bsm0h0, $bsm0h0; 
}#2 

while (my $bsm0h1 = <$BSM0H1>){#2
    chomp $bsm0h1; 
    push  @bsm0h1A, $bsm0h1; 
}#2 


#----------------------------------------------------------------print Dumper \@bsm0A;

my $S3_NexTreeNumber_A1;
my $count;
my @A2_TableNumRef_s4; 
for (my $i= 0 ; $i <= $#A1_lineNex_S1 ; $i ++){

	if  ( $A1_lineNex_S1[$i]=~ /^#/){
		my $specie = $A1_lineNex_S1[$i];
		$specie =~ s/(\#)(.*)(\:)\s+(\_)(.*)(\_)(.*)(\_)(.*)(\_)/$5/g;
		$specie =~ s/(.*)(\s+)/$1/g;
		my @Col_Sp = (split /\s+/, $specie);
		#print "$specie \n";
		push  @Species, $Col_Sp[0]; 
	}
	elsif ($A1_lineNex_S1[$i]=~ /^Model 0/){
		#print "$A1_lineNex_S1[$i]\n";
		$M0 = $i;
		push  @Coordenates, $i; 	
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 1/  ){
		#print "$A1_lineNex_S1[$i]\n";
		$M1 = $i;
		push  @Coordenates, $i;		
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 2/  ){
		#print "$A1_lineNex_S1[$i]\n";
		$M2 = $i;
		push  @Coordenates, $i;
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 3/  ){
		#print "$A1_lineNex_S1[$i]\n";
		$M3 = $i;
		push  @Coordenates, $i;
	}elsif ($A1_lineNex_S1[$i]=~ /^Model 7/  ){
		#print "$A1_lineNex_S1[$i]\n";
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
		#print "$Begin and $End\n";
	
	#----------------------------------------------------------------print Dumper \@Col_name;
	 
	for (my $i= $Begin ; $i <= $End ; $i ++){
		my @Col_line = (split /\s+/, $A1_lineNex_S1[$i]);
#----------------------------------------------------------------print Dumper \@Col_line;
		my $sizeLine = @Col_line;
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		#my @Col_sig = (split //, $Col_line[3]);
		#print "$A1_lineNex_S1[$i]\n";
		if  ( $A1_lineNex_S1[$i]=~ /^lnL/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;
			#print "$A1_lineNex_S1[$i]\n";
			my @Col_ln = (split /\s+/, $A1_lineNex_S1[$i]);
#----------------------------------------------------------------print Dumper \@Col_ln;
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		#print "$Col_ln[3]  AND $NP and $Col_ln[4]\n";
		$Hash_of_models{"M$Mod\_lnL"} = "$Col_ln[4]";
		$Hash_of_models{"M$Mod\_np"} = "$NP";
		}elsif ($A1_lineNex_S1[$i]=~ /^p\:/ && $A1_lineNex_S1[$Begin]=~ /^Model 1/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			
			my @Col_P_M1 = (split /\s+/, $A1_lineNex_S1[$i]);
			#----------------------------------------------------------------			print Dumper \@Col_P_M1;
			$Hash_of_models{"M1_p0"} = "$Col_P_M1[1]";
			$Hash_of_models{"M1_p1"} = "$Col_P_M1[2]";	
		}elsif ($A1_lineNex_S1[$i]=~ /^w\:/ && $A1_lineNex_S1[$Begin]=~ /^Model 1/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			
			my @Col_P_M1 = (split /\s+/, $A1_lineNex_S1[$i]);
			#----------------------------------------------------------------			print Dumper \@Col_P_M1;
			$Hash_of_models{"M1_w0"} = "$Col_P_M1[1]";
			$Hash_of_models{"M1_w1"} = "$Col_P_M1[2]";
		}elsif ($A1_lineNex_S1[$i]=~ /^\s+p/ && $A1_lineNex_S1[$Begin]=~ /^Model 7/ ){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];	
			#print "$A1_lineNex_S1[$i] AND $A1_lineNex_S1[$Begin]\n";
			my @Col_P_M7 = (split /\s+/, $A1_lineNex_S1[$i]);
			#----------------------------------------------------------------print Dumper \@Col_P_M7;
			$Hash_of_models{"M7_p"} = "$Col_P_M7[-4]";
			$Hash_of_models{"M7_q"} = "$Col_P_M7[-1]";	
			#print "$A1_lineNex_S1[$i] AND $A1_lineNex_S1[$Begin] AND p7= $Col_P_M7[-4] q7= $Col_P_M7[-1]\n";			
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/ && $Col_sig[-1]=~ /^\*/&& $Col_sig[-2]=~ /^\*/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;	 
		push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]\*\*";
		#$M7 = $i;
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/ && $Col_sig[-1]=~ /^\*/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
    	$Mod =~ s/(.*)(\:)/$1/g;	 
		push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]\*";
		#$M7 = $i;
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&  $A1_lineNex_S1[$Begin]=~ /^Model/){
		my @Col_name = (split /\s+/, $A1_lineNex_S1[$Begin]);
		my $Mod = $Col_name[1];
		$Mod =~ s/(.*)(\:)/$1/g;
    	push @{ $positive_site{"M$Mod\_PSS"}}, "$Col_line[1]$Col_line[2]";
		#$M7 = $i;
		push  @Coordenates, $i;						
		}else{
        	next;
		}
	}
$c = $c +1;	
}

for (my $i= 0 ; $i <= $#bsm0A ; $i ++){
		my @Col_line = (split /\s+/, $bsm0A[$i]);
#----------------------------------------------------------------print Dumper \@Col_line;
		my $sizeLine = @Col_line;
		#print "$A1_lineNex_S1[$i]\n";
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $bsm0A[$i]=~ /^lnL/){

			my @Col_ln = (split /\s+/, $bsm0A[$i]);
#----------------------------------------------------------------print Dumper \@Col_ln;
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		#print "$Col_ln[3]  AND $NP and $Col_ln[4]\n";
		$Hash_of_models{"bsM0\_lnL"} = "$Col_ln[4]";
		$Hash_of_models{"bsM0\_np"} = "$NP";
		}elsif ($bsm0A[$i]=~ /^\s+p0/ ){
			#print "$bsm0A[$i]\n";
			my @Col_P_bsM0 = (split /\s+/, $bsm0A[$i]);
			#----------------------------------------------------------------				print Dumper \@Col_P_bsM0;
			$Hash_of_models{"bsM0_p0"} = "$Col_P_bsM0[-7]";
			$Hash_of_models{"bsM0_p"} = "$Col_P_bsM0[-4]";
			$Hash_of_models{"bsM0_q"} = "$Col_P_bsM0[-1]";	
		#print "p0= $Col_P_bsM0[-7] p= $Col_P_bsM0[-4] q= $Col_P_bsM0[-1]\n";	
		}elsif ($bsm0A[$i]=~ /^\s+\(p1/ ){
			#print "$bsm0A[$i]\n";
			my @Col_P_bsM0 = (split /\s+/, $bsm0A[$i]);
			#----------------------------------------------------------------			print Dumper \@Col_P_bsM0;
			my $bsM0p =  $Col_P_bsM0[-4];
			$bsM0p =~ s/(.*)(\))/$1/g;
			#print "$bsM0p\n";
			#$Hash_of_models{"bsM0_p1"} = $bsM0p;
			#$Hash_of_models{"bsM0_w"} = "$Col_P_bsM0[-1]";
				
		#print "p1= $Col_P_bsM0[-4] w= $Col_P_bsM0[-1]\n";	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ &&   $Col_sig[-1]=~ /^\*/&& $Col_sig[-2]=~ /^\*/){
		push @{ $positive_site{"bsM0_PSS"}}, "$Col_line[1]$Col_line[2]\*\*";
		#$M7 = $i;
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ && $Col_sig[-1]=~ /^\*/){
		push @{ $positive_site{"bsM0_PSS"}}, "$Col_line[1]$Col_line[2]\*";
		#$M7 = $i;
		push  @Coordenates, $i;	
		}elsif ($sizeLine >= 4 && $Col_line[2]=~ /^[[:alpha:]]/  && $Col_line[1]=~ /^\d/ && $Col_line[3]=~ /^\d/ ){
		push @{ $positive_site{"bsM0_PSS"}}, "$Col_line[1]$Col_line[2]";					
		}else{
        	next;
		}
	}

for (my $i= 0 ; $i <= $#bsm0h1A ; $i ++){
		my @Col_line = (split /\s+/, $bsm0h1A[$i]);
#----------------------------------------------------------------print Dumper \@Col_line;
		my $sizeLine = @Col_line;
		#print "$A1_lineNex_S1[$i]\n";
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $bsm0h1A[$i]=~ /^lnL/){

			my @Col_ln = (split /\s+/, $bsm0h1A[$i]);
#----------------------------------------------------------------print Dumper \@Col_ln;
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		#print "$Col_ln[3]  AND $NP and $Col_ln[4]\n";
		$Hash_of_models{"bsM0H1\_lnL"} = "$Col_ln[4]";
		$Hash_of_models{"bsM0H1\_np"} = "$NP";
					
		}else{
        	next;
		}
}

for (my $i= 0 ; $i <= $#bsm0h0 ; $i ++){
		my @Col_line = (split /\s+/, $bsm0h0[$i]);
#----------------------------------------------------------------print Dumper \@Col_line;
		my $sizeLine = @Col_line;
		my $Col_sig = &Split_Phylip($Col_line[3]);
		my @Col_sig = @{ $Col_sig };
		if  ( $bsm0h0[$i]=~ /^lnL/){

			my @Col_ln = (split /\s+/, $bsm0h0[$i]);
#----------------------------------------------------------------print Dumper \@Col_ln;
		my $NP = $Col_ln[3];
		$NP =~ s/(.*)(\))(\:)/$1/g; 
		#print "$Col_ln[3]  AND $NP and $Col_ln[4]\n";
		$Hash_of_models{"bsM0H0\_lnL"} = "$Col_ln[4]";
		$Hash_of_models{"bsM0H0\_np"} = "$NP";
					
		}else{
        	next;
		}
	}

my @Variables = ("ID", "SP", "M0_lnL", "M0_np", "bsM0_lnL", "bsM0_np", "bsM0H0_lnL", "bsM0H0_np", "bsM0H1_lnL", "bsM0H1_np"); 
#----------------------------------------------------------------print Dumper \%positive_site;
#----------------------------------------------------------------print Dumper \@Species;


my @sorted_Species = sort @Species;
my $Species = join(",", @sorted_Species);
foreach my $Key_ps (keys %positive_site) {
	my @Uniq = uniq @{$positive_site{$Key_ps}};
	my $PSS = join(",",@Uniq) ;
	$Hash_of_models{"$Key_ps"} = $PSS;
}

$Hash_of_models{"ID"} = "$GroupNumber";
$Hash_of_models{"SP"} = "$Species";

foreach my $key (@Variables){
	if (exists($Hash_of_models{$key})){
  		next;
		  
	}else{
        $Hash_of_models{$key} = "NA";	
	}
}

#---------------------------------------------------------------print Dumper \%Hash_of_models;
#print "$Col_ID[1]\t$Species\t$Hash_of_models{M0_lnL}\t$Hash_of_models{M0_np}\t$Hash_of_models{M1_lnL}\t$Hash_of_models{M1_np}\t$Hash_of_models{M2_lnL}\t$Hash_of_models{M2_np}\t$Hash_of_models{BSM0H1_lnL}\t$Hash_of_models{BSM0H1_np}\t$Hash_of_models{M7_lnL}\t$Hash_of_models{M7_np}\t$Hash_of_models{bsM0_lnL}\t$Hash_of_models{bsM0_np}\t$Hash_of_models{bsM0_PSS}\n";
print "$Hash_of_models{ID}\t$Hash_of_models{SP}\t$Hash_of_models{M0_lnL}\t$Hash_of_models{M0_np}\t$Hash_of_models{bsM0_lnL}\t$Hash_of_models{bsM0_np}\t$Hash_of_models{bsM0H0_lnL}\t$Hash_of_models{bsM0H0_np}\t$Hash_of_models{bsM0H1_lnL}\t$Hash_of_models{bsM0H1_np}\n";
#print "$Col_ID[1]\t$Species\t$Hash_of_models{M0_lnL}\t$Hash_of_models{M0_np}\t$Hash_of_models{M1_lnL}\t$Hash_of_models{M1_np}\t$Hash_of_models{M2_lnL}\t$Hash_of_models{M2_np}\t$Hash_of_models{BSM0H1_lnL}\t$Hash_of_models{BSM0H1_np}\t$Hash_of_models{M7_lnL}\t$Hash_of_models{M7_np}\t$Hash_of_models{bsM0_lnL}\t$Hash_of_models{bsM0_np}\n";

 #;


sub Split_Phylip{
my $Line = $_[0];
my @Split;
#my @Split = (split //, $Line);
 

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


# for (my $i= $S2_ConversionTableNumber_A1+1 ; $i < $S3_NexTreeNumber_A1-1 ; $i ++){
# 	my $S4_lineTable = $A1_lineNex_S1[$i];
# 	$S4_lineTable =~ s/(.*)(\')(.*)(\')/$1\t$3/g;
# 	my @Col_Table = (split /\s+/, $S4_lineTable);
# 	my @Col_coma = (split /\,/, $Col_Table[2]);
# 	print $TAB "$Col_Table[1]\t$Col_coma[0]\n";
# 	push  @A2_TableNumRef_s4, $Col_Table[1];
# 	$H1_KnumberIntreeVheader_S4{$Col_Table[1]} = $Col_coma[0];
# }
# my @A3_rev_TableNumRef_A2 = reverse @A2_TableNumRef_s4;
# #---------------------------------print Dumper \%H1_KnumberIntreeVheader_S4;
# #---------------------------------print Dumper \@A3_rev_TableNumRef_A2;
# my @Split_nex;
# for (my $i= $S3_NexTreeNumber_A1+1 ; $i < $#A1_lineNex_S1 ; $i ++){
# 	print $NEW_NEX "$A1_lineNex_S1[$i]\n";
# 	my $Tree ="$A1_lineNex_S1[$i]";
# 		foreach my $Num_Table (@A3_rev_TableNumRef_A2){
# 			my $Num = "$Num_Table\:";
# 			my $new = $Tree =~ s/$Num/$H1_KnumberIntreeVheader_S4{$Num_Table}\:/r;
# 			$Tree = $new;
			
# 		}
# 		print $NEW_NEX_H "$Tree\n";
# 		@Split_nex = (split /\(/, $Tree);
		
# }
# ##---------------------------------print Dumper \@Split_nex;
# foreach my $Num_Table (@Split_nex){
# 	my @Split_tab = (split //, $Num_Table);
# 	##---------------------------------print Dumper \@Split_tab;
# 	my $nu = @Split_tab;
# 	if  ($nu == 0){
# 		push  @A4_FinalArrayPhulip_A1, "(";
# 	}else{
# 	push  @A4_FinalArrayPhulip_A1, "(";
#         my $ProtReal = &Split_Phylip("$Num_Table");
# 	}
# }
# shift @A4_FinalArrayPhulip_A1;
# #---------------------------------print Dumper \@A4_FinalArrayPhulip_A1;
# open my $PHY, "> $ARGV[0].cl.head.dnd";
# foreach my $out (@A4_FinalArrayPhulip_A1){
# 	print $PHY "$out\n";
# 	print  "$out\n";
# }

# exit;

# sub Split_Phylip{
# my $Line = $_[0];
# my @Split = (split /\)/, $Line);

# 		#print "Split\n";
# 		my $last_one = pop @Split;
# 				push @Split, "$last_one\#";
# 		#print "linea Split\n";
# 				#---------------------------------print Dumper \@Split;
# 	foreach my $linSplit (@Split){
# 		my @Split_pun = (split /\,/, $linSplit);
		
		

# 		#---------------------------------print Dumper \@Split_pun;
# 		my @Split_space = (split //, $linSplit);
# 		my $Number = @Split_pun;
# 		if  ( $Number == 2 && $Split_space[-1]=~ /\#/){
# 			$linSplit =~ s/(.*)(\#)/$1/g;
# 			push  @A4_FinalArrayPhulip_A1, $linSplit;
# 		}
# 		elsif ($Number >= 2 && $Split_space[-1]!~ /\#/ ){
# 			my @Split_coma = (split /\,/, $linSplit);
# 			push  @A4_FinalArrayPhulip_A1, "$Split_coma[0]\,";
# 			push  @A4_FinalArrayPhulip_A1, "$Split_coma[-1]\)";
# 		}elsif ($Number < 2 && $Split_space[-1]=~ /\#/ ){
# 			$linSplit =~ s/(.*)(\#)/$1/g;
# 			push  @A4_FinalArrayPhulip_A1, $linSplit;				
# 		}else{
# 			my @Split_coma = (split /\,/, $linSplit);
# 			push  @A4_FinalArrayPhulip_A1, "$Split_coma[0]\)";
# 		} 
# 	}
# }
