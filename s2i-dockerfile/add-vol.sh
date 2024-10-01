#!/usr/bin/env bash
# Script to set up the volume mount

set -euo pipefail

# Obtain the input parameters
CE_JOB_NAME=jkj-hpc-cosfs1
MOUNT_NAME=jkj-hpc-cos-bucket1
MOUNT_PATH=/mnt

echo ""
echo "CE_JOB_NAME: '$CE_JOB_NAME'"
echo "CE_MOUNT_NAME: '$MOUNT_NAME'"
echo "CE_MOUNT_PATH: '$MOUNT_PATH'"
echo ""

VOLUME_NAME=$CE_JOB_NAME-$MOUNT_NAME

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
