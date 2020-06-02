#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME=robond
DOCKER_IMAGE=sunside/ros-gazebo-gpu:udacity-robond
WORKSPACE=$(pwd)

# Which GPUs to use; see https://github.com/NVIDIA/nvidia-docker
GPUS="all"

XSOCK=/tmp/.X11-unix

XAUTH=`pwd`/.tmp/docker.xauth
XAUTH_DOCKER=/tmp/.docker.xauth

if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        mkdir -p $(dirname "$XAUTH") > /dev/null
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# We add SSH port forwarding, as well as sys_ptrace capability
# to allow for debugging.

docker run --rm -it \
    --name "$CONTAINER_NAME" \
    --gpus "$GPUS" \
    --publish 127.0.0.1:2222:22 \
    --publish 127.0.0.1:11311:11311 \
    --cap-add sys_ptrace \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH_DOCKER" \
    --volume="$XSOCK:$XSOCK:rw" \
    --volume="$XAUTH:$XAUTH_DOCKER:rw" \
    --volume="$WORKSPACE:/workspace:rw" \
    $DOCKER_IMAGE \
    bash
