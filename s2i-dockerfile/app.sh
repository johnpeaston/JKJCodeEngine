#!/bin/sh

#JOB_INDEX=5
# echo "JOB_INDEX= "$JOB_INDEX >>/mnt/OUT

OUTPUTDATAFILE=/mnt/xxx.$JOB_INDEX
INPUTDATAFILE=/mnt/DATAFILE

# Cleanup
echo "Cleanup..."
rm -f $OUTPUTDATAFILE

# check input and output are OK
# cat $INPUTDATAFILE >>/mnt/OUT
# echo "outputfile is " >>/mnt/OUT
# echo $OUTPUTDATAFILE >>/mnt/OUT

sleep 10

# Processing datafile...
while IFS=  read -r line
do
 	LINE=`echo $line | cut -f1 -d','`
 	if [ $LINE = $JOB_INDEX ]
 	then
 		INPUTDATA=`echo $line | cut -f2 -d','`
		# echo $INPUTDATA
                echo $INPUTDATA > $OUTPUTDATAFILE
 	fi
done < $INPUTDATAFILE

exit 0

