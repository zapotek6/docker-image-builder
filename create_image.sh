#!/bin/bash

. ./defaults

copyDirectories() {
  _SRC=${1}
  _DST=${2}
  cp -r ${1} ${2}
}






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

if [ ! -z "${DIRS_TO_COPY}" ]; then
  for srcDir in ${DIRS_TO_COPY}
  do
    copyDirectories ${srcDir} .
  done
fi


sudo docker build . -t "${IMAGE}:${VERSION}"
