#!/bin/bash

file=""
if [[ -f $1 ]]; then
	file="$1"
else
	exit 1
fi

date="$(date +%d%m)"

output=$( cat "$file" 2>/dev/null | jq -r '.["days"]["'$date'"]' 2>/dev/null )

ec=$?

if [[ "$ec" == 0 ]] && [[ "$output" != "null" ]]; then

	echo "$output"
	exit 0

else

	exit 1

fi
