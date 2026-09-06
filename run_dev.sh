#!/bin/bash
set -e

# Grant Docker access to the host's X server for display output (rviz, rqt, opencv gui)
xhost +local:docker > /dev/null 2>&1

# Export host user IDs so docker-compose picks them up
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
export USER=${USER:-devuser}

COMPOSE_FILE="docker/docker-compose.yaml"

# Parse optional arguments
if [ "$1" == "--build" ]; then
    echo "Building ROS 2 Humble container image..."
    docker-compose -f "$COMPOSE_FILE" build
    shift
fi

echo "Starting ROS 2 Humble dev environment for user: $USER ($HOST_UID:$HOST_GID)..."

# Run interactive container and clean up container instance on exit (--rm)
docker-compose -f "$COMPOSE_FILE" run --rm obstacle_detection_dev
