#! /usr/bin/bash

DBname=`pwd`
source validation.sh

checkTable $DBname
if [[ $? -eq 1 ]]; then
	# Variables
	declare -a dispalyData
	declare -a records
	declare -a arrOfTypes
	declare -i i=0

	PK=$(sed -n '3p' $DBname/$tableName)
	valueToSelect=($(awk -F: -v pk="$PK" 'NR == 1 {print $pk}' $DBname/$tableName))
	records=($(awk -F: -v pk="$PK" 'NR > 3 {print $pk}' $DBname/$tableName))
	arrOfTypes=($(awk -F: 'NR==1 {gsub(":", " "); print $0}' $DBname/$tableName))

	if [[ ${#records[@]} == 0 ]];then
		echo "Table $tableName Is Empty, No Data To Select"
		exitFunc
	fi

	clear
	echo "Select From Table $tableName"
	echo

	read -p "Enter Value Of $valueToSelect To Display Its Data: " search

	for record in ${records[@]}; do
		if [[ $record == $search ]]; then
			dispalyData=($(awk -F: -v idx="$i" 'NR==((idx+4)) {gsub(":", " "); print $0}' $DBname/$tableName))
			echo ${arrOfTypes[@]}	
			echo ${dispalyData[@]}
			echo
			read -p "Enter Any Key To Get Back To Menu"
			exitFunc
		fi
		i=$i+1
	done

	echo "Data Not Found"
fi
exitFunc
