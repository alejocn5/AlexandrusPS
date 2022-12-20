#!/bin/bash


while read SP
do
	cp ./Final_table_positive_selection/List_GUPS.txt ./G$SP/.	
	cd ./G$SP/
	#sh BranchSiteAnalisys.sh
	screen -S G$SP\_BS -d -m  sh BranchSiteAnalisys.sh
	cd ../
	#screen -d -m sh Positive_selection.sh
	sleep 5


done < ./Group.list
