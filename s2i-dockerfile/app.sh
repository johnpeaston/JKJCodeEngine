#!/bin/sh
#
# Test app
#

# env
#JOB_INDEX=5
echo "JOB_INDEX= "$JOB_INDEX >>/mnt/OUT
OUTPUTDATAFILE=/mnt/xxx.$JOB_INDEX
#OUTPUTDATAFILE=./xxx.$JOB_INDEX
INPUTDATAFILE=/mnt/DATAFILE
#INPUTDATAFILE=./DATAFILE
echo "Input will be in: "$INPUTDATAFILE >>/mnt/OUT
echo "Output will be in: "$OUTPUTDATAFILE >>/mnt/OUT

# Cleanup
echo "Cleanup..."
# rm -f /go/DATAFILE
rm -f $OUTPUTDATAFILE

# Get datafile from COS
# echo "Get datafile from COS bucket"
# ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

# check datafile is OK
echo "cat datafile..." >>/mnt/OUT
cat $INPUTDATAFILE >>/mnt/OUT

# Process datafile
echo "outputfile is " >>/mnt/OUT
echo $OUTPUTDATAFILE >>/mnt/OUT

exit 0

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

# Show output file
cat $OUTPUTDATAFILE  >>/mnt/OUT

# Put output datafile to COS
# echo "Put output datafile to COS..."
# ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

