#!/usr/bin/bash

declare -a colNames
declare -a colDataTypes

function setDataType() {
	declare -i count=0
	declare -a dataTypes=("Integer" "Varchar" "String")

	for (( i = 1; i <= $1; i++ )); do
		while true; do
		echo "Enter Data Type for Column $i: "
		select choice in "${dataTypes[@]}"; do
			case $REPLY in
		 	0|*[!0-9]*)
				echo "Only Numbers are Valid"
			;;
		 	*)
			if [[ $REPLY -le ${#dataTypes[@]} ]]; then
				colDataTypes+=(${dataTypes[$REPLY-1]})
				count=$count+1
				break 2
			else
			echo "Enter a Number Between 1 And ${#dataTypes[@]}."
			fi
			;;
			esac
		done
		done
	done
	return $count
}

function setPrimKey() {
	while true;
	do
		echo "Which Column To Set As PK?"
		select choice in "${colNames[@]}"
		do
			case $REPLY in
			0|*[!0-9]*)
                        	echo "Only Numbers are Valid"
                        ;;
			*)
				if [[ $REPLY -le ${#colNames[@]} ]]; 					then		
					return $REPLY
				else
					echo "Enter a Number Between 1 And ${#arrOfRec[@]}."
				fi
				break
			;;
			esac
		done
	done
}

function createColumns() {
	while true;
	do
		read -p "Enter number of Columns: " numOfColumns
		if [[ $numOfColumns =~ ^[1-9]+$ ]]; then
			break
		else
			echo " Invalid input! Enter Numbers ONLY "
		fi
	done

	for (( i = 1 ; i <= $numOfColumns ; i++ )); do
	    while true; do
		read -p "Enter column $i name: " columnName
		if [[ " ${colNames[@]} " =~ " $columnName " ]]; then
		    echo "Column $columnName Already Exists"
		else
		    checkName $columnName
		    if [[ $? -eq 0 ]]; then
			continue
		    else
			colNames+=($columnName)
			break
		    fi
		fi
	    done
	done

	setDataType $numOfColumns
	setPrimKey $numOfColumns
	result=$?

	if [[ ${#colNames[@]} -eq ${#colDataTypes[@]} && $result -le ${#colNames[@]} ]]; then
	touch $DBname/$tableName
	for ((i = 0; i < ${#colNames[@]}; i++)); do
		if [[ $i+1 -eq ${#colNames[@]} ]]; then
			echo ${colNames[$i]} >> $DBname/$tableName
		else
			echo -e "${colNames[$i]}:\c" >> $DBname/$tableName
		fi
	done
	for ((i = 0; i < ${#colDataTypes[@]}; i++)); do
		if [[ $i+1 -eq ${#colDataTypes[@]} ]]; then
			echo ${colDataTypes[$i]} >> $DBname/$tableName
		else
			echo -e "${colDataTypes[$i]}:\c" >> $DBname/$tableName
		fi
	done

	echo $result >> $DBname/$tableName
	echo "${colNames[$result-1]} Was Set As PK To Table $tableName"
	echo "Table $tableName Was Created Successfully"
fi 
}

