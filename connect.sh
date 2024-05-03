#!/usr/bin/bash
LC_COLLATE=C
source validation.sh
dataBases=~/Project/DataBases/

checkDB
if [[ $? -eq 0 ]]; then
	exitFunc
else

	clear
	cd $dataBases/$DBname
	echo "Conected successfully To $DBname "
	sleep 2
	clear

declare -a queries=("Creat Table" "List" "Drop" "Insert" "Select" "Update" "Delete" "Exit")

while true;
do
echo "You Are Using DataBase $DBname"
echo "Select a Query: " 
select query in "${queries[@]}"
do
case $query in
	"Creat Table" )
		clear
		~/Project/createTable.sh
		break
	;;
	"List" )
		clear
		numOfTables=`find -type f | wc -l`
		if [[ $numOfTables == 0 ]];then
			echo "* No Tables In $DBname"
			sleep 3
			clear
		else
			echo "Available Tables: "
			ls -p | grep -v "/"
			echo
			read -p "Enter Any Key To Get Back To Menu"
			clear
		fi
		break
	;;
	"Drop" )
		clear
		checkTable $dataBases/$DBname
		if [[ $? -eq 1 ]]; then
			read -p "=> Confirnm Dropping Table $tableName y/n: "
			case $REPLY in
			[Yy]* )
				rm $tableName
		 		echo " Table $tableName Was Dropped"	
			;;
			[Nn]* )
				echo "* Dropped was Canceled"
			;;
			* )
				echo "Invalid Option!"
			;;
			esac
		fi
		sleep 3
		clear
		break
	;;
	"Insert" )
		clear
		cd $dataBases/$DBname
		~/Project/insert.sh
		break
	;;
	"Select" )
		clear
		cd $dataBases/$DBname
		~/Project/select.sh
		break
	;;
	"Update" )
		clear
		cd $dataBases/$DBname
		~/Project/update.sh
		break
	;;
	"Delete" )
		clear
		cd $dataBases/$DBname
		~/Project/delete.sh
		break
	;;
	"Exit" )	
		cd ~/Project
		echo
		echo "Back To Main Menu" 
		exitFunc
	;;
	* )
		echo "Invalid Option"
		sleep 3
		clear
		break
	;;

esac
break
done
done
fi

