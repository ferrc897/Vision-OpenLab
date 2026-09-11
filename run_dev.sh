#!/bin/bash
set -e

# Grant Docker access to the host's X server for display output (rviz, rqt, opencv gui)
xhost +local:root > /dev/null 2>&1 || true
xhost +local:docker > /dev/null 2>&1 true

# Export host user IDs so docker-compose picks them up
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
export USER=${USER:-devuser}

if [ -c /dev/video0 ]; then 
    export VIDEO_GID=$(stat -c '%g' /dev/video0)
else
    export VIDEO_GID=44
fi

COMPOSE_FILE="docker/docker-compose.yaml"

# Parse optional arguments
if [ "$1" == "--build" ]; then
    echo "Building ROS 2 Humble container image..."
    docker-compose -f "$COMPOSE_FILE" build --build-arg USER_ID=$HOST_UID --build-arg USER_GID=$HOST_GID
    shift
fi

echo "Starting ROS 2 Humble dev environment for user: $USER ($HOST_UID:$HOST_GID)..."

# Run interactive container and clean up container instance on exit (--rm)
docker-compose -f "$COMPOSE_FILE" run --rm obstacle_detection_dev
