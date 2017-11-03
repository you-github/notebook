# @Author: ybq-2
# @Date:   2017-11-02 03:50:29
# @Last Modified by:   ybq-2
# @Last Modified time: 2017-11-02 23:08:17
#!/bin/bash

grep "input" a.md | awk -F '|' '{print $4}' > a.txt
grep "output" a.md | awk -F '|' '{print $4}' > b.txt

for i in $(cat a.txt)
do
  j=`grep -w "$i" b.txt`
  if [ "$j" = "" ]
  then
  	echo "---------------Mismatched interface $i-----------------"
  	echo `grep -w $i a.md` 
  	echo `grep -w $i a.md` >> mismatch.md
  	echo "-------------------------------------------------------"
  else
  	grep "$i" a.md | awk -F '|' '{print $3}' > tmp
  	line1=`sed -n '1p' tmp`
   	line2=`sed -n '2p' tmp`

	begin_line1=`echo $line1 | awk -F ':' '{print $1}' | awk -F '[' '{print $2}'`
	end_line1=`echo $line1 | awk -F ':' '{print $2}' | awk -F ']' '{print $1}'`
	new_line1="[""$begin_line1":"$end_line1""]"

	begin_line2=`echo $line2 | awk -F ':' '{print $1}' | awk -F '[' '{print $2}'`
	end_line2=`echo $line2 | awk -F ':' '{print $2}' | awk -F ']' '{print $1}'`
	new_line2="[""$begin_line2":"$end_line2""]"

		if [ "$new_line1" = "$new_line2" ]
		then
			echo "pass"
		else
			if [ "$new_line1" = "[:]" -a "$new_line2" = "[0:0]" ] || [ "$new_line1" = "[0:0]" -a "$new_line2" = "[:]" ]
			then
				echo pass
			else
				echo "---------------Mismatched interface $i-----------------"
  				echo `grep -w $i a.md` 
  				echo `grep -w $i a.md` >> mismatch.md
  				echo "-------------------------------------------------------"
			fi
		fi
  fi

done


touch tmp && rm tmp
touch a.txt && rm a.txt
touch b.txt && rm b.txt