#!/bin/sh
#
# Test app
#

env

OUTPUTDATAFILE=/go/xxx.$JOB_INDEX
#echo $OUTPUTDATAFILE

export BUCKET="jkj-hpc-cos-bucket1"

# Cleanup
# echo "Cleanup..."
rm -f /go/DATAFILE
rm -f /go/xxx.*

# Get datafile from COS
# echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east

# check datafile is OK
# echo "cat datafile..."
cat /go/DATAFILE

exit 0

# Process datafile
# echo "Processing datafile..."
while read -r line
do
	# echo $line
	# sleep 1
	LINE=`echo $line | cut -f1 -d','`
	# echo $LINE
	if [[ $LINE == $JOB_INDEX ]]
	then
		INPUTDATA=`echo $line | cut -f2 -d','`
		# echo $INPUTDATA
                echo $INPUTDATA >> /go/xxx.$JOB_INDEX
	fi
done < /go/DATAFILE

# Show output file
# echo "Show output file..."
# cat /go/xxx.$JOB_INDEX

# Put output datafile to COS
# echo "Put output datafile to COS..."
ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

