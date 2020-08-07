#!/bin/bash

Sbit=1
Cbit=4
Abit=8
Mbit=16

while read line
do
	
	if grep -q 'keycode' <<< "$line"
	then
		
		n=$(sed -e 's~keycode \([0-9]*\) = .*~\1~' <<< "$line")
		
		B=$(sed -e 's~.*:b[ac]* \([^ ]*\).*~\1~' <<< "$line")
		
		if grep -q ':ba' <<< "$line"
		then
			
			BA=$Abit
			
		else
			
			BA=0
			
		fi
		
		if grep -q ':bac' <<< "$line"
		then
			
			BC=$Cbit
			
		else
			
			BC=0
			
		fi
		
		S=$(sed -ne 's~.*:s[ac]* \([^ ]*\).*~\1~p' <<< "$line")
		
		if grep -q ':sa' <<< "$line"
		then
			
			SA=$Abit
			
		else
			
			SA=0
			
		fi
		
		if grep -q ':sac' <<< "$line"
		then
			
			SC=$Cbit
			
		else
			
			SC=0
			
		fi
		
		M=$(sed -ne 's~.*:m \([^ ]*\).*~\1~p' <<< "$line")
		
		echo -n 'keycode '"$n"' ='
		
		for i in {0..255}
		do
			
			if [ $[ $Mbit & $i ] -ne 0 ] && [ "$M" != "" ]
			then
				
				echo -n ' '"$M"
				
			elif [ $[ $Sbit & $i ] -ne 0 ] && [ "$S" != "" ]
			then
				
				if [ $[ $SA & $SC & $i ] -ne 0 ]
				then
					
					echo -n ' Meta_Control_'"$S"
					
				elif [ $[ $SA & $i ] -ne 0 ]
				then
					
					echo -n ' Meta_'"$S"
					
				elif [ $[ $SC & $i ] -ne 0 ]
				then
					
					echo -n ' Control_'"$S"
					
				else
					
					echo -n ' '"$S"
					
				fi
				
			else
				
				if [ $[ $BA & $BC & $i ] -ne 0 ]
				then
					
					echo -n ' Meta_Control_'"$B"
					
				elif [ $[ $BA & $i ] -ne 0 ]
				then
					
					echo -n ' Meta_'"$B"
					
				elif [ $[ $BC & $i ] -ne 0 ]
				then
					
					echo -n ' Control_'"$B"
					
				else
					
					echo -n ' '"$B"
					
				fi
				
			fi
			
		done
		
		echo
		
	else
		
		echo $line
		
	fi
	
done < $1
