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

INDEX=13

# Cleanup
echo "Cleanup..."
rm -f $HOME/Downloads/DATAFILE
rm -f $HOME/Downloads/xxx

# Get datafile from COS
echo "Get datafile from COS bucket"
ibmcloud cos object-get --bucket jkj-hpc-cos-bucket1 --key DATAFILE  --region us-east

# check datafile is OK
# echo "cat datafile..."
# cat $HOME/Downloads/DATAFILE

# Process datafile
echo "Processing datafile..."
while read -r line
do
        # echo $line
        # sleep 1
        LINE=`echo $line | cut -f1 -d','`
        # echo $LINE
        if [[ $LINE == $INDEX ]]
        then
                INPUTDATA=`echo $line | cut -f2 -d','`
                echo $INPUTDATA >> $HOME/Downloads/xxx.$INDEX
        fi
done < $HOME/Downloads/DATAFILE

# Put output datafile to COS
echo "Put output datafile to COS..."
ibmcloud cos object-put --bucket jkj-hpc-cos-bucket1 --key DATAFILE --body $HOME/Downloads/xxx.$INDEX  --region us-east

exit 0
