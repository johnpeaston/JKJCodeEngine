#!/bin/sh
#
# Test app
#

env

OUTPUTDATAFILE=/go/xxx.$JOB_INDEX
echo $OUTPUTDATAFILE

export BUCKET="jkj-hpc-cos-bucket1"
CID="crn:v1:bluemix:public:cloud-object-storage:global:a/b5e2b6b228eb4f2499d46b73cb1c5db9:f420cab2-83e9-4d93-b37a-41eb5c64dced::"

# Create a COS instance unless one has been specified for use
# if [[ $CID == "" ]]; then
#   ibmcloud resource service-instance-create ce-cos-event \
#     cloud-object-storage lite global
#   CID=$(ibmcloud resource service-instance ce-cos-event | \
#     awk '/^ID/{ print $2 }')
# fi

# Set the COS config to use this instance
# ibmcloud cos config crn --crn $CID --force
ibmcloud cos config auth --method IAM

# Cleanup
# echo "Cleanup..."
rm -f /go/DATAFILE
rm -f /go/xxx.*

# Get datafile from COS
# echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

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

