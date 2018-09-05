#!/bin/bash
CURDIR=$(dirname $0)
cd "$CURDIR"
# set here the path to the directory containing your videos
VideoLocation="./assets"

if [ -d /media/pi/*/rpi_player ]
then
  VideoLocation=/media/pi/*/rpi_player/assets
  echo $VideoLocation
fi
# you can probably leave this alone
Process="omxplayer"
# our loop
#xset dpms force off
while true; do
        if ps ax | grep -v grep | grep $Process > /dev/null
        then
        sleep 1;
else
        for entry in $VideoLocation/*
        do
		    #xset dpms force off
                # -r for stretched over the entire location
		    echo "$entry"
        omxplayer -b -o both "$entry" > /dev/null
		    #xset dpms force off
        done
fi
done
