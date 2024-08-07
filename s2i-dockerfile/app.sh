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
CID="crn:v1:bluemix:public:cloud-object-storage:global:a/b5e2b6b228eb4f2499d46b73cb1c5db9:f420cab2-83e9-4d93-b37a-41eb5c64dced::"
# Set the COS config to use this instance
ibmcloud cos config crn --crn $CID --force
ibmcloud cos config auth --method IAM

# Cleanup
#echo "Cleanup..."
# rm -f /go/DATAFILE
rm -f $OUTPUTDATAFILE

# Get datafile from COS
# echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

exit 0

# check datafile is OK
# echo "cat datafile..."
# cat /go/DATAFILE

# Process datafile
touch /$OUTPUTDATAFILE

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
done < /go/DATAFILE

# Show output file
#cat $OUTPUTDATAFILE 

# Put output datafile to COS
# echo "Put output datafile to COS..."
#ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

