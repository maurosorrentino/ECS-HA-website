#!/usr/bin/env bash
set -euo pipefail # makes pipeline fail on any error

# Arguments
APP_VERSION="$1"
ECR_REPO="$2"
REGISTRY="$3"
APP_PATH="$4"
IMAGE_URI="$5" # used in terraform for building tasks

echo "Using tag: $APP_VERSION"
echo "Backend repo: $ECR_REPO"
echo "Registry: $REGISTRY"

# Check if image exists
if aws ecr describe-images --repository-name "$ECR_REPO" --image-ids imageTag="$APP_VERSION"; then
  echo "Image already exists. Skipping build and push."
else
  echo "Building image..."
  docker build -t "$ECR_REPO:$APP_VERSION" "$APP_PATH"
  docker tag "$ECR_REPO:$APP_VERSION" "$REGISTRY/$ECR_REPO:$APP_VERSION"
  echo "Pushing image to ECR..."
  docker push "$REGISTRY/$ECR_REPO:$APP_VERSION"
fi

# Export the image URI for GitHub Actions
echo "$IMAGE_URI=$REGISTRY/$ECR_REPO:$APP_VERSION" >> "$GITHUB_ENV"
