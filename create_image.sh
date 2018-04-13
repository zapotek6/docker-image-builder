#!/bin/bash

. ./defaults

JOURNAL_FILENAME=${JOURNAL_FILENAME:-journal.log}

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


if [ ! "${DOCKER_BUILD_ARGS_1}" == "" ]; then
  echo "Using docker build args: ${DOCKER_BUILD_ARGS_1}"
  DOCKER_BUILD_PAR_1="--build-arg ${DOCKER_BUILD_ARGS_1}"
else
  unset DOCKER_BUILD_PAR_1
fi

if [ ! "${DOCKER_BUILD_ARGS_2}" == "" ]; then
  echo "Using docker build args: ${DOCKER_BUILD_ARGS_2}"
  DOCKER_BUILD_PAR_2="--build-arg ${DOCKER_BUILD_ARGS_2}"
else
  unset DOCKER_BUILD_PAR_2
fi

if [ ! "${DOCKER_BUILD_ARGS_3}" == "" ]; then
  echo "Using docker build args: ${DOCKER_BUILD_ARGS_3}"
  DOCKER_BUILD_PAR_3="--build-arg ${DOCKER_BUILD_ARGS_3}"
else
  unset DOCKER_BUILD_PAR_3
fi

sudo docker build . ${DOCKER_BUILD_PAR_1} ${DOCKER_BUILD_PAR_2} ${DOCKER_BUILD_PAR_3} -t "${IMAGE}:${VERSION}"

RET=$?

if [ "$RET" == "0" ]; then
  echo "Image ${IMAGE}:${VERSION} successfully created"
  echo "`date -R` Image created - [${IMAGE}:${VERSION}]" >> $JOURNAL_FILENAME
fi