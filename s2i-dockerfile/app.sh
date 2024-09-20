#!/bin/sh
#
# Test app
#

# env
#JOB_INDEX=5
echo "JOB_INDEX= "$JOB_INDEX
OUTPUTDATAFILE=/go/xxx.$JOB_INDEX
#OUTPUTDATAFILE=./xxx.$JOB_INDEX
INPUTDATAFILE=/go/DATAFILE
#INPUTDATAFILE=./DATAFILE
#echo "Input will be in: "$INPUTDATAFILE
#echo "Output will be in: "$OUTPUTDATAFILE

# Cleanup
#echo "Cleanup..."
# rm -f /go/DATAFILE
rm -f $OUTPUTDATAFILE

# Setup COS volume mount
# Usage: add-volume-mount-to-job.sh CE_JOB_NAME MOUNT_NAME MOUNT_PATH
CE_JOB_NAME=jkj-hpc-cosfs1
MOUNT_NAME=jkj-hpc-cos-bucket1
MOUNT_PATH=/mnt

set -euo pipefail

echo ""
echo "CE_JOB_NAME: '$CE_JOB_NAME'"
echo "CE_MOUNT_NAME: '$MOUNT_NAME'"
echo "CE_MOUNT_PATH: '$MOUNT_PATH'"
echo ""

VOLUME_NAME=$1-$2

# Create the JSON patch

PATCH='[
  {
    "op": "add",
    "path": "/spec/template/volumes",
    "value": [{
      "name": "'$VOLUME_NAME'",
      "persistentVolumeClaim": {
        "claimName": "'$MOUNT_NAME'"
      }
    }]
  },
  {
    "op": "add",
    "path": "/spec/template/containers/0/volumeMounts",
    "value": [{
      "name": "'$VOLUME_NAME'",
      "mountPath": "'$MOUNT_PATH'"
    }]
  }
]'

# Apply the patch
kubectl patch jobdefinition  $CE_JOB_NAME --type='json' --patch "$PATCH"

echo "Patched job '$CE_JOB_NAME' with volume '$VOLUME_NAME' mounted at '$MOUNT_PATH'."
echo "Patched job '$CE_JOB_NAME' with volume '$VOLUME_NAME' mounted at '$MOUNT_PATH'." > $MOUNT_PATH/output_test

# Get datafile from COS
# echo "Get datafile from COS bucket"
# ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east /go/DATAFILE

# check datafile is OK
#echo "cat datafile..."
#cat $INPUTDATAFILE

# Process datafile
#echo "outputfile is "
#echo $OUTPUTDATAFILE
touch $OUTPUTDATAFILE

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
#cat $OUTPUTDATAFILE 

# Put output datafile to COS
# echo "Put output datafile to COS..."
# ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

