#! /usr/bin/bash

# Validatin Functions

function checkTable() {
	available=`find -type f | wc -l`
	if [[ $available == 0 ]];then
		echo "* No Tables in `basename $1`"
		return 0
	else
		echo -e " Available Tables: \c"
		echo $available
		ls -p | grep -v "/"
		read -p "Enter Table Name: "
		if [[ -z $REPLY ]]; then
			echo "* No Table Entered, Back To Menu"
			return 0
		elif [ -f $REPLY ]; then
			tableName=$REPLY
			return 1
		else
			echo "Table Not Exist!"
			return 0
		fi
	fi
}

function checkDB() {
	available=`ls -F $dataBases | grep "/" | grep "_DB" | wc -l`
	if [[ $available == 0 ]];then
		echo "No Available Data Bases!"
		return 0
	else
		echo -e "Available DataBases: \c"
		echo $available
		ls -F $dataBases | grep "/" | grep "_DB"| sed 's/\/$//'

		read -p "Enter Data Base Name: "
		if [[ -z $REPLY ]]; then
			echo "* No Data Base Entered, Back To Menu"
		elif [[ -d $dataBases/$REPLY ]]; then
			checkName $REPLY
			if [[ $? == 0 ]]; then
				return 0
			else
				DBname=$REPLY
				return 1
			fi
		else
			echo "Data Base Not Exist!"
			return 0
		fi
	fi
}


function checkName() {
	if [[ $1 == [0-9]* ]]; 
	then
		echo " Invalid Name, can't Start With Number "
		return 0
	elif [[ $1 == _* && $1 != _ ]];
	then
		echo " Invalid Name, _ Must Followed By Char"
		return 0
	elif [[ $1 =~ ^_+$ ]];  
	then
		echo " Invalid Name, can't Start With _ Only"
		return 0
	elif [[ $1 == *[!a-zA-Z0-9_]* ]];  
	then
		echo " Invalid Name, can't Contain Special Chars"
		return 0
	elif [[ -z $1 ]];  
	then
		echo " Invalid Name, can't be empty "
		return 0
	elif [[ $1 == *" "* || -n $2 ]];
	then
		echo " Invalid Name, can't contain spaces "
		return 0
	fi
	return 1
}

function validDT() {
declare -a arrOfDT=($(awk -F: 'NR==2 {gsub(":", " "); print $0}' $dataBases/$DBname/$tableName))
    declare -i i=$2-1
	
    if [[ ${arrOfDT[$i]} == "Integer" ]]; then
        if [[ $1 =~ ^[0-9]+$ ]]; then
            return 1
        else
            echo "Only Int Values Allowed"
            return 0
        fi
    elif [[ ${arrOfDT[$i]} == "Varchar" ]]; then
        if [[ $1 =~ ^[a-zA-Z0-9_]+$ ]]; then
            return 1
        else 
            echo "No Special Chars Allowed"
            return 0
        fi
    elif [[ ${arrOfDT[$i]} == "String" ]]; then
        if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
            return 1
	else
            echo "Only String Chars Allowed"
            return 0
        fi
    fi
}

function validPK() {
	declare -a uniqeRecords=($(awk -F: -v pk="$2" 'NR > 3 {print $pk}' $dataBases/$DBname/$tableName))
	for data in ${uniqeRecords[@]}; do
		if [[ $data == $1 ]]; then
			echo "* Value Of $1 Can't Be Repeated"
			return 0
		fi
	done
	return 1
}

function exitFunc() {
	sleep 3
	clear
	exit
}

