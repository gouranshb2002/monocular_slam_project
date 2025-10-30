#!/bin/bash
# This is a script to easily run our SLAM project container

echo "-----------------------------------------------------"
echo "Welcome to the ORB-SLAM3 Project!"
echo "1. Enabling GUI forwarding (xhost +)..."
echo "-----------------------------------------------------"

# Allow Docker to open windows on your screen
xhost +

echo "-----------------------------------------------------"
echo "2. Starting the Docker container..."
echo "You will be placed inside the container's terminal."
echo "To exit, just type 'exit'."
echo "-----------------------------------------------------"

# Run the pre-compiled Docker container
docker run -it --rm \
    --name="slam_run" \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$HOME/Datasets:/root/Datasets" \
    --volume="$(pwd):/root/monocular-slam-project" \
    my_orb_slam_project /bin/bash

echo "-----------------------------------------------------"
echo "Docker container has been stopped and removed."
echo "Goodbye!"
echo "-----------------------------------------------------"
