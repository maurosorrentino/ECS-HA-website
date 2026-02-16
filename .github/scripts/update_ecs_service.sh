#!/bin/bash
set -euo pipefail

SERVICE_NAME=$1
CLUSTER_NAME=$2
IMAGE_URI=$3

echo "Checking cluster capacity..."

INSTANCES=$(aws ecs describe-clusters \
    --clusters "$CLUSTER_NAME" \
    --query 'clusters[0].registeredContainerInstancesCount' \
    --output text)

if [ "$INSTANCES" -eq 0 ]; then
    echo "ERROR: No Container Instances found in cluster '$CLUSTER_NAME'."
    echo "The deployment will fail, so we are stopping now."
    exit 1
fi

echo "Updating service: $SERVICE_NAME"

aws ecs describe-task-definition \
    --task-definition "$SERVICE_NAME" \
    --query taskDefinition > task-def.json

# update the image in the task definition and remove fields that are not needed for registration
# to avoid errors when registering the new task definition
jq --arg IMAGE "$IMAGE_URI" '
    .containerDefinitions[0].image = $IMAGE | 
    del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .compatibilities, .registeredAt, .registeredBy)
' task-def.json > new-task-def.json

NEW_REVISION_ARN=$(aws ecs register-task-definition \
    --cli-input-json file://new-task-def.json \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)

aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --task-definition "$NEW_REVISION_ARN"

echo "service $SERVICE_NAME update initiated successfully."
