#!/usr/bin/bash
LC_COLLATE=C

DBname=`pwd`
source validation.sh
source tableFuncs.sh

read -p "Enter Table Name: " tableName

checkName $tableName
result=$?
if [[ $result -eq 1 ]]; then
	if  [[ -e $tableName ]]; then
		echo "$tableName Already Exist"
	else
		createColumns
	fi
fi
exitFunc


