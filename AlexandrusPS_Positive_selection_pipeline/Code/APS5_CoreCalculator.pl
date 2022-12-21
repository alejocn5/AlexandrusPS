#!/usr/bin/perl


use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Array::Utils qw(:all);
use String::ShellQuote qw(shell_quote); # cpan String::ShellQuote
use List::Util;
use POSIX;





open my $Core, "< $ARGV[0]";
open my $U, "< $ARGV[1]";
open my $NEWCore, "> $ARGV[0].calculated";
open my $Group, ">> Group.list";

my $Cores;
my $Usage;

	while (my $Core = <$Core>){#2
        chomp $Core; 
        $Cores = $Core - 2;
	}#2 
	while (my $us = <$U>){#2
        chomp $us; 
        $Usage = $us;
	}#2 



my $Number_final_core = ($Cores*$Usage)/100;
my $Final_core_number = floor($Number_final_core);


if  ($Final_core_number == 0  ){
	$Final_core_number = 1;
	}else{
        $Final_core_number = $Final_core_number;
	}

print $NEWCore "$Final_core_number\n";


my $count = 1;
		for (my $i= 1 ; $i <= $Final_core_number  ; $i ++){
		print $Group "$i\n"; 
}
exit;
