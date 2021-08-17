 #!/bin/bash
#ssh
CURDIR=$(dirname $0)
cd "$CURDIR"
# set here the path to the directory containing your videos
VideoLocation="./assets"
TimetableLocation="/boot/timetable.json"


function terminate {

  kill -SIGTRAP $PROC1 2>/dev/null

  kill -SIGTERM $PROC1 2>/dev/null
  kill -SIGTERM $PROC2 2>/dev/null
  kill -SIGTERM $PROC3 2>/dev/null


  kill -SIGINT $PROC1 2>/dev/null
  kill -SIGINT $PROC2 2>/dev/null
	kill -SIGINT $PROC3 2>/dev/null

  echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "      LOOPING TERMINATED.    "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGTERM
	trap SIGINT

  #xset dpms force on

  kill -SIGTERM $$ 2>/dev/null
	}

trap terminate SIGINT
# trap 'echo int; kill -SIGINT $PROC1' SIGINT
trap terminate SIGTERM


for i in /media/*/*/rpi_player
do
  if [ -d "$i" ]
  then
    for y in "$i/assets/"*
    do
      if [ -e "$y" ]
      then
        VideoLocation=/media/*/*/rpi_player/assets
      fi
    done
  fi
done
echo "Video source: "$VideoLocation

# you can probably leave this alone
Process="omxplayer"
# our loop
function looping {
  while true;
  do
      SetSubfolder=""

			SetFolder=$(./tinker.sh "$TimetableLocation")
			if [[ "$?" == 0 ]]; then


				echo "TIMETABLE RUN."
				SetSubfolder="$SetFolder"
				VideoLocation="$VideoLocation/$SetSubfolder"

			fi


          if ps ax | grep -v grep | grep $Process > /dev/null
          then
                  #echo "omx is running. Sleeping."
                  sleep 1;
          else
                  for entry in $VideoLocation/*
                  do
            		    #et dpms force off
                            # -r for stretched over the entire location
            		    echo "$entry"
                    omxplayer.bin -b -o local "$entry" > /dev/null &
                    PROC1=$!
                    trap 'echo while1; kill -SIGTRAP $PROC1 2>/dev/null; trap SIGTERM; break; terminate' SIGTERM
                    trap 'echo while1; kill -SIGTERM $PROC1 2>/dev/null; trap SIGTERM; break; terminate' SIGTERM
                    trap 'echo while1; kill -SIGINT $PROC1 2>/dev/null; trap SIGINT; break; terminate' SIGINT
                    wait
            		    #xset dpms force off
                  done &
                  PROC2=$!
                  trap 'echo while2; kill -SIGTERM $PROC2 2>/dev/null; trap SIGINT; break; terminate' SIGTERM
                  trap 'echo while2; kill -SIGINT $PROC2 2>/dev/null; trap SIGINT; break; terminate' SIGINT
                  wait


          fi
  done
}
looping &
PROC3=$!
trap 'echo waitomx; kill -SIGTERM $PROC3 2>/dev/null; trap SIGINT; terminate' SIGTERM
trap 'echo waitomx; kill -SIGINT $PROC3 2>/dev/null; trap SIGINT; terminate' SIGINT
wait
