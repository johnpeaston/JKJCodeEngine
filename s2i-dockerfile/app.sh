#!/bin/sh
#
# Test app
#
echo "This is my test app"
echo "This is my test app"
echo "This is my test app"
echo "This is my test app"
echo "This is my test app"

env

OUTPUTDATAFILE=$HOME/Downloads/xxx.$INDEX
#echo $OUTPUTDATAFILE

export BUCKET="jkj-hpc-cos-bucket1"

# Cleanup
# echo "Cleanup..."
rm -f $HOME/Downloads/DATAFILE
rm -f $HOME/Downloads/xxx.*

# Get datafile from COS
# echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket ${BUCKET} --key DATAFILE  --region us-east

# check datafile is OK
# echo "cat datafile..."
# cat $HOME/Downloads/DATAFILE

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
                echo $INPUTDATA >> $HOME/Downloads/xxx.$JOB_INDEX
	fi
done < $HOME/Downloads/DATAFILE

# Show output file
# echo "Show output file..."
# cat $HOME/Downloads/xxx.$JOB_INDEX

# Put output datafile to COS
# echo "Put output datafile to COS..."
ibmcloud cos object-put --bucket ${BUCKET} --key Output.$JOB_INDEX --body ${OUTPUTDATAFILE}  --region us-east

exit 0

