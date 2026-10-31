
#!/usr/bin/env bash
set -Eeuo pipefail

# AWS configuration
AWS_REGION="ap-northeast-1"
AWS_ACCOUNT_ID="113460354909"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Deployment configuration
APP_DIR="/opt/todo-app"
BACKEND_REPO="ankit-todo-backend"
FRONTEND_REPO="ankit-todo-frontend"

# The commit SHA is supplied by GitHub Actions.
IMAGE_TAG="${1:?Usage: deploy.sh <image-tag>}"

BACKEND_IMAGE="${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}"
FRONTEND_IMAGE="${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG}"

echo "Starting deployment for image tag: ${IMAGE_TAG}"

cd "${APP_DIR}"

# Authenticate Docker with Amazon ECR.
aws ecr get-login-password --region "${AWS_REGION}" \
  | sudo docker login \
      --username AWS \
      --password-stdin "${ECR_REGISTRY}"

# Use the EC2 root Docker credentials while running Compose with the
# existing production environment file.
sudo env \
  BACKEND_IMAGE="${BACKEND_IMAGE}" \
  FRONTEND_IMAGE="${FRONTEND_IMAGE}" \
  docker compose \
    --env-file "${APP_DIR}/.env" \
    -f "${APP_DIR}/docker-compose.prod.yml" \
    pull backend frontend

# Recreate only the application containers.
# The database container and its persistent volume are left untouched.
sudo env \
  BACKEND_IMAGE="${BACKEND_IMAGE}" \
  FRONTEND_IMAGE="${FRONTEND_IMAGE}" \
  docker compose \
    --env-file "${APP_DIR}/.env" \
    -f "${APP_DIR}/docker-compose.prod.yml" \
    up -d --no-deps backend frontend

echo "Waiting for backend health check..."

for attempt in $(seq 1 30); do
  STATUS=$(sudo docker inspect \
    --format='{{.State.Health.Status}}' todo-backend 2>/dev/null || true)

  if [[ "${STATUS}" == "healthy" ]]; then
    echo "Backend is healthy."
    break
  fi

  if [[ "${STATUS}" == "unhealthy" ]]; then
    echo "Backend health check failed."
    sudo docker logs --tail 100 todo-backend
    exit 1
  fi

  if [[ "${attempt}" -eq 30 ]]; then
    echo "Timed out waiting for backend health check."
    sudo docker logs --tail 100 todo-backend
    exit 1
  fi

  sleep 5
done

echo "Deployment completed successfully: ${IMAGE_TAG}"
sudo docker ps --filter "name=todo-"
