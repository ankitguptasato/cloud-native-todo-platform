sudo tee /opt/todo-app/deploy.sh > /dev/null <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail

AWS_REGION="ap-northeast-1"
AWS_ACCOUNT_ID="113460354909"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
APP_DIR="/opt/todo-app"

BACKEND_REPO="ankit-todo-backend"
FRONTEND_REPO="ankit-todo-frontend"

IMAGE_TAG="${1:?Usage: deploy.sh <image-tag>}"

BACKEND_IMAGE="${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}"
FRONTEND_IMAGE="${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG}"

cd "${APP_DIR}"

PREVIOUS_BACKEND=$(sudo docker inspect todo-backend --format '{{.Config.Image}}' 2>/dev/null || true)
PREVIOUS_FRONTEND=$(sudo docker inspect todo-frontend --format '{{.Config.Image}}' 2>/dev/null || true)

echo "Previous backend: ${PREVIOUS_BACKEND}"
echo "Previous frontend: ${PREVIOUS_FRONTEND}"
echo "New deployment version: ${IMAGE_TAG}"

rollback() {
  echo "Deployment failed. Starting rollback..."

  if [[ -n "${PREVIOUS_BACKEND}" && -n "${PREVIOUS_FRONTEND}" ]]; then
    sudo env BACKEND_IMAGE="${PREVIOUS_BACKEND}" \
      FRONTEND_IMAGE="${PREVIOUS_FRONTEND}" \
      docker compose --env-file "${APP_DIR}/.env" \
      up -d --no-deps backend frontend

    echo "Rollback command completed."
  else
    echo "No previous deployment found. Rollback is not available."
  fi

  sudo docker ps --filter "name=todo-"
}

handle_failure() {
  EXIT_CODE=$?
  trap - ERR
  echo "Deployment command failed with exit code ${EXIT_CODE}."
  rollback || echo "WARNING: Rollback command also failed."
  exit "${EXIT_CODE}"
}

trap handle_failure ERR

aws ecr get-login-password --region "${AWS_REGION}" \
  | sudo docker login --username AWS --password-stdin "${ECR_REGISTRY}"




# Start PostgreSQL first
sudo docker compose --env-file "${APP_DIR}/.env" up -d db

# Wait for PostgreSQL to become healthy
for attempt in $(seq 1 30); do
  DB_STATUS=$(sudo docker inspect --format='{{.State.Health.Status}}' reactapp-db 2>/dev/null || true)

  if [[ "${DB_STATUS}" == "healthy" ]]; then
    echo "PostgreSQL is healthy."
    break
  fi

  if [[ "${attempt}" -eq 30 ]]; then
    echo "PostgreSQL failed to become healthy."
    exit 1
  fi

  sleep 5
done

# Deploy backend and frontend
sudo env BACKEND_IMAGE="${BACKEND_IMAGE}" FRONTEND_IMAGE="${FRONTEND_IMAGE}" \
  docker compose --env-file "${APP_DIR}/.env" up -d --no-deps backend frontend

sudo env BACKEND_IMAGE="${BACKEND_IMAGE}" FRONTEND_IMAGE="${FRONTEND_IMAGE}" \
  docker compose --env-file "${APP_DIR}/.env" up -d --no-deps backend frontend

DEPLOYMENT_SUCCESS=false

for attempt in $(seq 1 30); do
  STATUS=$(sudo docker inspect --format='{{.State.Health.Status}}' todo-backend 2>/dev/null || true)

  if [[ "${STATUS}" == "healthy" ]]; then
    DEPLOYMENT_SUCCESS=true
    break
  fi

  if [[ "${STATUS}" == "unhealthy" ]]; then
    echo "Backend health check failed."
    break
  fi

  sleep 5
done

if [[ "${DEPLOYMENT_SUCCESS}" != "true" ]]; then
  echo "Deployment health check failed."
  sudo docker logs --tail 100 todo-backend || true
  rollback || echo "WARNING: Rollback command also failed."
  trap - ERR
  exit 1
fi

trap - ERR

echo "Deployment completed successfully: ${IMAGE_TAG}"
sudo docker ps --filter "name=todo-"
EOF