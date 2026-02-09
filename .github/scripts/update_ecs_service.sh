#!/bin/bash
set -euo pipefail

SERVICE_NAME=$1
CLUSTER_NAME=$2
IMAGE_URI=$3

echo "Updating service: $SERVICE_NAME in Cluster: $CLUSTER_NAME"

# get current task definition
aws ecs describe-task-definition \
    --task-definition "$SERVICE_NAME" \
    --query taskDefinition > task-def.json

# update image and clean up JSON
jq --arg IMAGE "$IMAGE_URI" '
    .containerDefinitions[0].image = $IMAGE | 
    del(.taskDefinitionArn, .revision, .status, .requiresAttributes, .compatibilities, .registeredAt, .registeredBy)
' task-def.json > new-task-def.json

# register new revision
NEW_REVISION_ARN=$(aws ecs register-task-definition \
    --cli-input-json file://new-task-def.json \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)

echo "Registered revision: $NEW_REVISION_ARN"

# update the service
aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --task-definition "$NEW_REVISION_ARN"

echo "Waiting for service to reach a steady state..."

# poll every 15 seconds. if it doesn't stabilize it exits with error
if ! aws ecs wait services-stable --cluster "$CLUSTER_NAME" --services "$SERVICE_NAME"; then
    echo "Error: Service failed to stabilize. Deployment failed."
    exit 1
fi

echo "service $SERVICE_NAME update initiated successfully."
