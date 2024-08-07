#!/bin/sh
#
# Test app
#

env

echo "JOB_INDEX= "$JOB_INDEX
OUTPUTDATAFILE=/go/xxx.$JOB_INDEX
# echo "Output will be in: "$OUTPUTDATAFILE

export BUCKET="jkj-hpc-cos-bucket1"

# Login stuff

# Cleanup
#echo "Cleanup..."
# rm -f /go/DATAFILE
rm -f $OUTPUTDATAFILE

# Get datafile from COS
# echo "Get datafile from COS bucket"
# ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

# check datafile is OK
# echo "cat datafile..."
# cat /go/DATAFILE

# TEST
# echo "TEST"
# if [ $JOB_INDEX = "0" ]
# then
# 	echo "JOBINDEX=0"
# fi

# Process datafile
touch /$OUTPUTDATAFILE

echo "Processing datafile..."
while IFS=  read -r line
do
	# echo $line
	# sleep 1
 	LINE=`echo $line | cut -f1 -d','`
	# echo $LINE
	# echo $JOB_INDEX
 	# INPUTDATA=`echo $line | cut -f2 -d','`
	# echo $INPUTDATA
 	if [ $LINE = $JOB_INDEX ]
 	then
		echo "in if test"
 		INPUTDATA=`echo $line | cut -f2 -d','`
		echo $INPUTDATA
                echo $INPUTDATA > $OUTPUTDATAFILE
 	fi
done < /go/DATAFILE

# Show output file
echo "Show output file..."
cat $OUTPUTDATAFILE 

# Put output datafile to COS
# echo "Put output datafile to COS..."
#ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

