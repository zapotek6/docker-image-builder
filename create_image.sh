#!/bin/bash

. ./defaults

copyDirectories() {
  _SRC=${1}
  _DST=${2}
  cp -r ${1} ${2}
}

copyFiles() {
  _SRC=${1}
  _DST=${2}
  cp  ${1} ${2}
}

##### MAIN #####

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
  echo "Copying directories: ${DIRS_TO_COPY}"
  for srcDir in ${DIRS_TO_COPY}
  do
    copyDirectories ${srcDir} .
  done
fi

if [ ! -z "${FILES_TO_COPY}" ]; then
  echo "Copying files: ${FILES_TO_COPY}"
  for srcFile in ${FILES_TO_COPY}
  do
    copyFiles ${srcFile} .
  done
fi

sudo docker build . -t "${IMAGE}:${VERSION}"
