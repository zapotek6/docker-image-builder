#!/bin/bash

. ./defaults

VERSION="${1}"

if [ -z "${VERSION}" ]; then
  echo "Missing ${IMAGE} image version"
  echo
  echo "Usage: ${0} <image version>"
  exit 1
fi

if [ ! -f "./Dockerfile" ]; then
  echo "ERROR Dockerfile is missing! Fatal error"
  exit 2
fi

sudo docker build . -t "${IMAGE}:${VERSION}"
