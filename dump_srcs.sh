#!/bin/bash

#sudo apt install enscript ghostscript
files=`find $1 | grep -E '\.c$|\.h$|\.S$'`

outname=`basename $1 2>/dev/null`
[ -z $1 ] && outname=$(basename `pwd`)

echo -n > ${outname}.txt
for f in $files
do
	echo "[$f] ++++++++++++++++++++++++++++++"
	cat $f
done >> ${outname}.txt

enscript -B -Ec --color -p ${outname}.ps ${outname}.txt && ps2pdf ${outname}.ps ${outname}.pdf
