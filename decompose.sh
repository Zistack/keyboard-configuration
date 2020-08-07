#!/bin/bash

OUTFILE=/dev/null

IFS=""

while read line
do
    
    if grep -q 'xkb_keycodes' <<< "$line"
    then
	
	OUTFILE=xkb/keycodes/current
	echo "$line" > $OUTFILE
	
    elif grep -q 'xkb_types' <<< "$line"
    then
	
	OUTFILE=xkb/types/current
	echo "$line" > $OUTFILE
	
    elif grep -q 'xkb_compat' <<< "$line"
    then
	
	OUTFILE=xkb/compat/current
	echo "$line" > $OUTFILE
	
    elif grep -q 'xkb_symbols' <<< "$line"
    then
	
	OUTFILE=xkb/symbols/current
	echo "$line" > $OUTFILE

    elif grep -q 'xkb_geometry' <<< "$line"
    then
	
	OUTFILE=xkb/geometry/current
	echo "$line" > $OUTFILE
	
    elif grep -q '^};' <<< "$line"
    then
	
	echo "$line" >> $OUTFILE
	OUTFILE=/dev/null
	
    else
	
	echo "$line" >> $OUTFILE
	
    fi
    
done < current.xkb
