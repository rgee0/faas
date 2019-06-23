#!/bin/sh
set -e

REGISTRY="$1"

if [ "$REGISTRY" = "quay.io" ] ; then
  USERNAME=$QUAY_USERNAME
  PASSWORD=$QUAY_PASSWORD
elif [ "$REGISTRY" = "docker.io" ] ; then
  USERNAME=$DOCKER_USERNAME
  PASSWORD=$DOCKER_PASSWORD 
fi

echo $PASSWORD | docker login -u=$USERNAME --password-stdin $REGISTRY;
