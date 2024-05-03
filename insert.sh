#! /usr/bin/bash

DBname=`pwd`
source validation.sh

checkTable $DBname
if [[ $? -eq 1 ]]; then
	declare -a arrOfDT=($(awk -F: 'NR==1 {gsub(":", " "); print $0}' $DBname/$tableName))
	PK=$(sed -n '3p' $DBname/$tableName)
	declare -a arrOfData
	declare -i d=1

	clear
	echo "Insert In Table $tableName: "
	echo

	for colName in ${arrOfDT[@]}
	do
		while true;
		do
			read -p "Enter Value Of $colName: " value
			if [[ -z $value ]]; then
				echo "Error: Value Can't Be Empty"
				continue
			fi

			validDT $value $d
			if [[ $? -eq 0 ]]; then
				continue
			fi

			if [[ $d -eq $PK ]]; then
				validPK $value $PK
				if [[ $? -eq 0 ]]; then
			    		continue
				fi
			fi
			break
		done
		arrOfData+=($value)
		d=$d+1
	done

	if [[ ${#arrOfData[@]} -ne 0 && ${#arrOfData[@]} -eq ${#arrOfDT[@]} ]]; then
		d=1
		for data in ${arrOfData[@]}
		do
			if [[ $d == ${#arrOfData[@]} ]]; then
				echo  $data >> $DBname/$tableName
			else
				echo -e "$data:\c" >> $DBname/$tableName
			fi
			d=$d+1
		done
		echo "Data Inserted Successfully"
	else
		echo "* Error, All Data Must Be Valid"
	fi
fi

exitFunc

