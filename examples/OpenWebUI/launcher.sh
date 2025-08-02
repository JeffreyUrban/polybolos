#!/bin/bash
CONTAINER_NAME="open-webui"

# Note: You may need to customize the path to docker.

# Check if the container already exists (running or stopped)
existing_container=$(/usr/local/bin/docker ps -a --filter "name=^/${CONTAINER_NAME}$" --format "{{.ID}}")

if [ -n "$existing_container" ]; then
    # Check if the container is running
    running_container=$(/usr/local/bin/docker ps --filter "name=^/${CONTAINER_NAME}$" --format "{{.ID}}")

    if [ -n "$running_container" ]; then
        echo "$CONTAINER_NAME container is already running."
    else
        echo "$CONTAINER_NAME container exists but is not running. Starting container..."
        /usr/local/bin/docker start "$CONTAINER_NAME"
    fi
else
    echo "Starting new $CONTAINER_NAME container..."
    /usr/local/bin/docker run -d -p 3000:8080 -e WEBUI_AUTH=False -v open-webui:/app/backend/data --name $CONTAINER_NAME ghcr.io/open-webui/open-webui:main
fi

# Wait until Open WebUI service is reachable
max_attempts=30
attempt=1
until curl -sf http://localhost:3000/ > /dev/null; do
  if (( attempt >= max_attempts )); then
    echo "Open WebUI did not start in time." >&2
    exit 1
  fi
  ((attempt++))
  sleep 0.2
done
