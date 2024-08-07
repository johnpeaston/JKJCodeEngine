#!/bin/sh
#
# Test app
#

env

OUTPUTDATAFILE=/go/xxx.$JOB_INDEX
echo $OUTPUTDATAFILE

export BUCKET="jkj-hpc-cos-bucket1"

# Login stuff
ibmcloud login --apikey YmpM7TndxtTn2loiobNwOQhF8S9bZSgGrH95zlZX55OR
ibmcloud target -g Default

# Cleanup
# echo "Cleanup..."
rm -f /go/DATAFILE
rm -f /go/xxx.*

# Get datafile from COS
# echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

# check datafile is OK
# echo "cat datafile..."
# cat /go/DATAFILE

# Process datafile
touch /go/xxx.$JOB_INDEX

# echo "Processing datafile..."
# while read -r line
# do
	# echo $line
	# sleep 1
# 	LINE=`echo $line | cut -f1 -d','`
	# echo $LINE
# 	if [ $LINE = $JOB_INDEX ]
# 	then
# 		INPUTDATA=`echo $line | cut -f2 -d','`
		# echo $INPUTDATA
# 		echo "INPUTDATA is "$INPUTDATA
 #                echo $INPUTDATA > /go/xxx.$JOB_INDEX
# 	fi
# done < /go/DATAFILE
while IFS= read -r line
do
    echo "Text read from file: $line"
done </go/DATAFILE

# Show output file
echo "Show output file..."
cat /go/xxx.$JOB_INDEX

# Put output datafile to COS
# echo "Put output datafile to COS..."
ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

