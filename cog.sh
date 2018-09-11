#!/bin/bash

counter=0

function terminate {


	kill -SIGTERM $PROC2 2>/dev/null
	kill -SIGTERM $PROC2 2>/dev/null

	kill -SIGTERM $PROC1 2>/dev/null
	kill -SIGINT $PROC1 2>/dev/null


	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "        OMX TERMINATED.      "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGTERM
	trap SIGINT
	kill -SIGTERM $$ 2>/dev/null
	}

trap terminate SIGINT
# trap 'echo int; kill -SIGINT $PROC1' SIGINT
trap terminate SIGTERM


function looping {
	while true; do
	  echo -e "\e[34m"
	  echo "-----------------------------"
	  echo "        Starting omx.        "
	  echo "-----------------------------"
	  echo ""
	  echo ""
	  ./omx.sh &
		PROC2=$!
		trap 'kill -SIGTERM $PROC2 2>/dev/null; trap SIGTERM; break' SIGTERM
		trap 'kill -SIGTERM $PROC2 2>/dev/null; trap SIGINT; break' SIGINT
		wait
		echo ""
	  counter=$(expr $counter + 1)
	  echo "Error. Retrying. Rerun #$counter."
	  echo  ""
	  sleep 5
	done
}

looping &
PROC1=$!
wait
