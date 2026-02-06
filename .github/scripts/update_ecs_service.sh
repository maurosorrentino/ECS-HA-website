#!/bin/bash
set -euo pipefail

SERVICE_NAME=$1
CLUSTER_NAME=$2
IMAGE_URI=$3

echo "updating service: $SERVICE_NAME in Cluster: $CLUSTER_NAME"
echo "new Image: $IMAGE_URI"

# get the current task definition
aws ecs describe-task-definition \
    --task-definition "$SERVICE_NAME" \
    --query taskDefinition > task-def.json

# use jq to update the image in the containerDefinitions and remove fields that AWS prevents you from sending 
# back in a 'register' call
jq --arg IMAGE "$IMAGE_URI" '
    .containerDefinitions[0].image = $IMAGE | 
    del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .compatibilities, .registeredAt, .registeredBy)
' task-def.json > new-task-def.json

# register the new task definition revision
NEW_REVISION_ARN=$(aws ecs register-task-definition \
    --cli-input-json file://new-task-def.json \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)

echo "registered new revision: $NEW_REVISION_ARN"

# update the service to use the new revision
aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --task-definition "$NEW_REVISION_ARN" \
    --force-new-deployment

echo "service $SERVICE_NAME update initiated successfully."
