#!/bin/bash

#a=$(md5sum -b assets/output.mkv); b=$(md5sum -b /media/pi/flora/rpi_update/assets/output.mkv); a=${a% *}; b=${b% *}; echo $a $b



CURDIR=$(dirname $0)
cd "$CURDIR"

echo -ne "\e[35m"
echo -e "-----------------------------"
echo -e "          BOOTSTRAP.         "
echo -e "-----------------------------"

chmod 0777 -R *

import_folder="rpi_update"

### DECLARATION PART

function list_through_files {

	folder="$1"

	for a in "$folder/"* ; do

		if [ -d "$a" ] ; then
			if [ "$a" == "$folder/assets" ] ; then
				update_assets "$a"
			else
				echo "COPING $a"
				rsync --info=progress2 -r "$a" "./"
			fi
		else
			echo "COPING $a"
			rsync --info=progress2 -r "$a" "./"
		fi
	done


}

##updates assets in up-to-date fashion
function update_assets {

	folder="$1"

	for v in "$folder/"* ; do

		if [ ! -d "$v" ] ; then
			if [ ! -f "./assets/$(basename "$v")" ] ; then
				echo -e "COPING $v"
				rsync --info=progress2 "$v" "./assets/$(basename "$v")"

			fi
		else
			echo "COPING $v"
			rsync --info=progress2 "$v" "./assets/$(basename "$v")"
		fi

	done

	for w in "./assets/"* ; do
		if [ ! -d "$w" ]; then
			if [ ! -f "$folder/$(basename "$w")" ] ; then
				echo -e "REMOVING $w"
				rm  "$w"
			fi
		fi
	done

}

### LOGIC PART


if [ ! -d assets ]
then
	echo -e "CREATING ASSETS DIRECTORY."
	mkdir assets
	chmod 0777 assets
fi


function terminate {

	kill -SIGTERM $PROC1 2>/dev/null
	kill -SIGINT $PROC1 2>/dev/null

	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "    BOOTSTRAP TERMINATED.    "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGINT
	trap SIGTERM
	kill $$ 2>/dev/null
	}

trap terminate SIGINT
trap terminate SIGTERM


echo -e "CHECKING FOR FILES TO UPDATE."
sleep 5

for i in /media/* ; do

  if [ -d "$i/$import_folder/" ]; then
	echo "LISTING"
	echo "$i/$import_folder"

	list_through_files "$i/$import_folder"


  fi


  for j in "$i/"* ; do

     if [ -d "$j/$import_folder/" ]; then
			 echo "LISTING"

        echo "$j/$import_folder"

	list_through_files "$j/$import_folder"


    fi

  done


done

chmod 0777 -R ./*

echo -e "PAUSING."
echo -e "5"
sleep 1
echo -e "4"
sleep 1
echo -e "3"
sleep 1
echo -e "2"
sleep 1
echo -e "\e[91m1"
sleep 1
echo -e "\e[31mLIFT OFF."
echo -e "\e[39m"


./cog.sh & PROC1=$!
trap 'echo waitboot; kill -SIGTERM $PROC1 2>/dev/null; trap SIGINT; terminate' SIGTERM
trap 'echo waitboot; kill -SIGINT $PROC1 2>/dev/null; trap SIGINT; terminate' SIGINT
wait
