#!/bin/bash

set -e

Usage () {
    echo "Usage: docker-nvidia-run.sh "
    echo "       -n | --name container name"
    echo "       -i | --image image url or id"
    echo "       -p | --persist run without --rm"
}


date_str=$(date +"%Y%m%d_%H%M%S")
CONTAINER_NAME="${USER}-${date_str}"
DOCKER_IMAGE=""
PERSIST_FLAG="--rm"

extra_args=""
while [[ $# -gt 0 ]]; do
  key="$1"

  case ${key} in
    -n|--name)
      CONTAINER_NAME="$2"
      shift
      shift
      ;;
    -i|--image)
      DOCKER_IMAGE="$2"
      shift
      shift
      ;;
    -p|--PERSIST)
      PERSIST_FLAG=""
      shift
      ;;
    *)
      extra_args+=" "
      extra_args+=${key}
      shift
      ;;
  esac
done

if [ -z "${DOCKER_IMAGE}" ]; then
    echo "please provide the image url"
    Usage
    exit 1
fi

echo "CONTAINER_NAME : ${CONTAINER_NAME}"
echo "DOCKER_IMAGE : ${DOCKER_IMAGE}"
echo "PERSIST_FLAG : ${PERSIST_FLAG}"

echo "${extra_args}"

COMMAND="docker run --uts=host -e CONTAINER=${CONTAINER_NAME} --runtime=nvidia --name ${CONTAINER_NAME} -it ${PERSIST_FLAG} --privileged --gpus=all,\"capabilities=compute,utility,graphics,display\" -v ${HOME}:${HOME} ${extra_args} ${DOCKER_IMAGE} bash"
# COMMAND="docker run --uts=host -e CONTAINER=${CONTAINER_NAME} --runtime=nvidia --name ${CONTAINER_NAME} -it ${PERSIST_FLAG} --privileged --gpus=all,\"capabilities=compute,utility,graphics,display\" -v ${HOME}:${HOME} ${extra_args} ${DOCKER_IMAGE} bash"

echo "COMMAND : ${COMMAND}"
${COMMAND}


