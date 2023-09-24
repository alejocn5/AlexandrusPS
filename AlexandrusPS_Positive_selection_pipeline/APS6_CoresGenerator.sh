#!/bin/bash

while read SP
do

	cp -r G0 G$SP


done < ./Group.list
