#!/bin/bash

# Positions within repos and imagenames are important
# Associative arrays (-A) would be better but support varies

declare -a repos=(
    "openfaas-incubator/openfaas-operator"
    "openfaas-incubator/faas-idler" 
    "openfaas/faas" 
    "openfaas/faas"
    "openfaas/faas-swarm" 
    "openfaas/nats-queue-worker" 
    "openfaas/faas-netes" 
    "openfaas/faas-cli"
    )

declare -a imagenames=(
    "openfaas/faas-operator" 
    "openfaas/faas-idler" 
    "openfaas/gateway"
    "openfaas/basic-auth-plugin"
    "openfaas/faas-swarm" 
    "openfaas/queue-worker" 
    "openfaas/faas-netes" 
    "openfaas/faas-cli"
    )

HERE=`pwd`
ARCH=$(uname -m)

#if [ ! -z "$CACHED" ]; then
    rm -rf staging || :
    mkdir -p staging/openfaas
    mkdir -p staging/openfaas-incubator

#fi

if [ "$ARCH" = "armv7l" ] ; then
   ARM_VERSION="armhf"
elif [ "$ARCH" = "aarch64" ] ; then
   ARM_VERSION="arm64"
fi

echo "Target architecture: ${ARM_VERSION}"

for i in "${!repos[@]}"
do
   cd $HERE

   echo -e "\nBuilding: ${imagenames[$i]}\n"
   git clone https://github.com/${repos[$i]} ./staging/${repos[$i]}
   cd ./staging/${repos[$i]}
   pwd
   export TAG=$(git describe --abbrev=0 --tags)
   echo "Latest release: $TAG"

   REPOSITORY=${imagenames[$i]}
   TAG_PRESENT=$(curl -s "https://hub.docker.com/v2/repositories/${REPOSITORY}/tags/${TAG}-${ARM_VERSION}/" | grep -Po '"detail": *"[^"]*"' | grep -o 'Not found')

   if [ "$TAG_PRESENT" = "Not found" ]; then
       make ci-${ARM_VERSION}-build ci-${ARM_VERSION}-push
   else
       echo "Image is already present: ${REPOSITORY}:${TAG}-${ARM_VERSION}"
   fi
done

echo "Docker images"

for i in "${!repos[@]}"
do
   cd $HERE
   cd ./staging/${repos[$i]}
   export TAG=$(git describe --abbrev=0 --tags)
   echo "${repos[$i]}"
   REPOSITORY=${imagenames[$i]}
   echo " ${REPOSITORY}:${TAG}-${ARM_VERSION}"
done
