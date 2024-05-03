#! /usr/bin/bash

DBname=`pwd`
source validation.sh
checkTable $DBname
if [[ $? -eq 1 ]]; then
	# Variables
	declare -a updateData
	declare -a records
	declare -a arrOfDT
	declare -i numOfRow
	declare -i numOfCol
	declare -i i=0

	PK=$(sed -n '3p' $DBname/$tableName)
	valueToUpdate=($(awk -F: -v pk="$PK" 'NR == 1 {print $pk}' $DBname/$tableName))
	records=($(awk -F: -v pk="$PK" 'NR > 3 {print $pk}' $DBname/$tableName))
	arrOfDT=($(awk -F: 'NR==1 {gsub(":", " "); print $0}' $DBname/$tableName))
	
	if [[ ${#records[@]} == 0 ]];then
		echo "Table $tableName Is Empty, No Data To Update"
		exitFunc
	fi

	clear
	echo "Update In Table $tableName: "
	echo

	read -p "Enter Value Of $valueToUpdate To Update Its Data: " search
	for data in ${records[@]};
	do
		if [[ $data == $search ]]; then
			numOfRow=$i+4
			updateData=($(awk -F: -v idx="$numOfRow" 'NR==idx {gsub(":", " "); print $0}' $DBname/$tableName))
			flag=1
			break
		fi
		i=$i+1
	done
	if [[ $flag -eq 1 ]];then
		echo ${arrOfDT[@]}	
		echo ${updateData[@]}
		
		echo "Which Data You Want To Update: "
		select choice in "${arrOfDT[@]}"
		do
			case $REPLY in
			0|*[!0-9]*)
		                echo "Invalid Option"
				break
		        ;;
			*)
				if [[ $REPLY -le ${#arrOfDT[@]} ]]; then
					while true;
					do
						read -p "Enter New Value: " newValue
						if [[ -z $newValue ]]; then
							echo "Error: Value Can't Be Empty"
							continue
						fi

						validDT $newValue $REPLY
						result=$?
						if [[ $result -ne 1 ]]; then
							continue
						fi

						if [[ $REPLY -eq $PK ]]; then
							validPK $newValue $PK
							result=$?			
							if [[ $result -ne 1 ]]; then
						    		continue
							fi
						fi
						numOfCol=$REPLY
						break
					done
					awk -F: -v row="$numOfRow" -v col="$numOfCol" -v newValue="$newValue" 'BEGIN{OFS=":"} NR==row {$col=newValue} {print}' $DBname/$tableName > tempTable.txt && mv tempTable.txt $DBname/$tableName
					flag=1
					echo "Data Updated Successfully"
				else
					echo "Option Out Of Range"
				fi
				break
			;;
			esac
		done
	else
		echo "Data Not Found"
	fi
fi
exitFunc

