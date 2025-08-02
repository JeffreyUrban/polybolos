#!/bin/bash

# Note: You'll need to set the path to your LibreChat directory. You may need to customize the path to docker.

# Start LibreChat and wait for the service to become available
cd /path/to/LibreChat || exit 1
/usr/local/bin/docker compose up -d

# Wait until LibreChat service is reachable (change port/path if needed)
/usr/bin/env bash << 'EOF'
max_attempts=30
attempt=1
until curl -sf http://localhost:3080/ > /dev/null; do
  if (( attempt >= max_attempts )); then
    echo "LibreChat did not start in time." >&2
    exit 1
  fi
  ((attempt++))
  sleep 0.2
done
EOF
