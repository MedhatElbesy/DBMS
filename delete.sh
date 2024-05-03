#! /usr/bin/bash

DBname=`pwd`
source validation.sh
checkTable `pwd`
if [[ $? -eq 1 ]]; then
	# Variables
	declare -i i=0
	PK=$(sed -n '3p' $DBname/$tableName)
	valueToDelete=($(awk -F: -v pk="$PK" 'NR == 1 {print $pk}' $DBname/$tableName))
	declare -a records=($(awk -F: -v pk="$PK" 'NR > 3 {print $pk}' $DBname/$tableName))

	if [[ ${#records[@]} == 0 ]];then
		echo "Table $tableName Is Empty, No Data To Delete"
		exitFunc
	fi

	clear
	echo "Delete From Table $tableName"
	echo

	read -p "Enter Value Of $valueToDelete Delete Its Data: " search

	for index in ${records[@]};
	do
		if [[ $index == $search ]]; then
			sed -i "$((i + 4))d" $DBname/$tableName
			echo "Data Deleted Successfully"
			exitFunc	
		fi
		i=$i+1
	done

	echo "* Data Not Found"
fi
exitFunc
