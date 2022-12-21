#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;




open my $GENTREE, "< $ARGV[0]";

my @A1_GenTree;
my @A2_ColLineGT_S1;
my %H3_final;

#Read file and trasnfer to an Array
while (my $GenTree = <$GENTREE>){#2
    chomp $GenTree;
    ##(_cbriggsae_31_4_#2,((_cbrenneri_31_2_#3,_cremanei_31_3_#3)#3,_celegans_31_1_#3)); 
    push @A1_GenTree, $GenTree; 
}#2 
#---------------------------------------------------------------------------print Dumper \@A1_GenTree; 

foreach my $S1_LineGT_A1 (@A1_GenTree){
	if ($S1_LineGT_A1 =~ /^\(/){
            @A2_ColLineGT_S1 = (split /\#/, $S1_LineGT_A1);
            my $ProtReal = &SpeciesList(\@A2_ColLineGT_S1);
       	}else{
            next;
	}
}


#--------------------------------------------------------------------------------------print Dumper \%H3_final;

foreach my $S5_KeyName_h3 (keys %H3_final) {
 open my $T, ">> TreeList.txt";
  open my $F, ">> FileList.txt";
 print $T "$S5_KeyName_h3\_.BranchAnalyTree\n";
 print $F "$S5_KeyName_h3\n";
 open my $OUT, "> $S5_KeyName_h3\_.BranchAnalyTree";
 
 print $OUT "$H3_final{$S5_KeyName_h3}";
 
} 



sub SpeciesList{
    my $A2  = shift;
    my @A2 = @$A2;
    my %H1_name;
    my %H2_hash;
    my @A4_cleanded;
    my %Ha1_Trees_H2H1;
    #my %H3_final;
    
#--------------------------------------------------------------------------------------print Dumper \@A2;
        foreach my $S1_LineGT_A1 (@A2){
        my @A3_S1 = (split /\_/, $S1_LineGT_A1);
        my $NumberElementsA3 = @A3_S1; 
#--------------------------------------------------------------------------------------print Dumper \@A3_S1;

        my $first = shift @A3_S1;
        my $NewFirst = &RemoveNummer($first);
        unshift @A3_S1, "$NewFirst";
        #push @A3_S1, "\_";
#--------------------------------------------------------------------------------------print Dumper \@A3_S1;
        my $CleanLine;
            if  ($NumberElementsA3 > 1){
                #push @A3_S1, "\_";
                $CleanLine = join("\_", @A3_S1);
                    $H2_hash{"$CleanLine\_"} = "$CleanLine\_\#1";
                    $H1_name{"$CleanLine\_"} = "$A3_S1[1]\_$A3_S1[2]";
                    push @A4_cleanded, "$CleanLine\_"; 
	            }else{
                    push @A4_cleanded, "$A3_S1[0]"; 
	        }
           
        }
        #--------------------------------------------------------------------------------------        print Dumper \@A4_cleanded;
#--------------------------------------------------------------------------------------print Dumper \%H1_name;
#--------------------------------------------------------------------------------------print Dumper \%H2_hash;  
        foreach my $S2_Name_H2 (keys %H2_hash) {
            foreach my $S3_Names_A2 (@A4_cleanded){
                if($S2_Name_H2 eq $S3_Names_A2) {
                   
                    push @{ $Ha1_Trees_H2H1{$H1_name{$S2_Name_H2}}}, $H2_hash{$S2_Name_H2};
                }else{
                push @{ $Ha1_Trees_H2H1{$H1_name{$S2_Name_H2}}}, $S3_Names_A2;
	            }
            }    
	    }
       	foreach my $S4_KeyName_ha1 (keys %Ha1_Trees_H2H1) {
               my $Tree = join("", @{$Ha1_Trees_H2H1{$S4_KeyName_ha1}});
               $Tree =~ s/(.*)(\;)(\_)/$1$2/g;
               #print "$Tree\n";
               $H3_final{$S4_KeyName_ha1} = $Tree;
	    } 
            
#--------------------------------------------------------------------------------------print Dumper \%H3_final;     

}



sub RemoveNummer{
    my $line = $_[0];
    my @A4 = (split //, $line);
    my @New;
        foreach my $S2_A4 (@A4){
	        if ($S2_A4 =~ /\d/){
                    print "";
	    	    }else{
                    push @New, $S2_A4;
	       }
        }
    my $new = join("", @New);
    return $new;    
}