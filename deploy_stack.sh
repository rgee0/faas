#!/bin/sh

if ! [ -x "$(command -v docker)" ]; then
  echo 'Unable to find docker command, please install Docker (https://www.docker.com/) and retry' >&2
  exit 1
fi

export yamlfile="docker-compose.yml"
export arch=$(uname -m)

if [ "$arch" = "armv7l" || "$arch" = "armv6l"] ; then
   yamlfile="docker-compose.armhf.yml"
fi

echo "Deploying stack"
docker stack deploy func --compose-file $yamlfile

