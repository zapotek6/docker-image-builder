#!/bin/bash

. ./defaults

JOURNAL_FILENAME=${JOURNAL_FILENAME:-journal.log}
HOOKS_DIR="./hooks"
EXECUTE_WITH_SHELL="/bin/bash"

init() {
  [ ! -d "$HOOKS_DIR" ] && mkdir -p $HOOKS_DIR
}

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

execHooks() {
  __RADIX=$1
  __CURR_DIR=`pwd`
  for script in ${HOOKS_DIR}/*
  do
          __RUN="FALSE"
          __SCRIPT_NAME=`basename $script`
          #echo "Parsing scripts $script"

          [[ "$__SCRIPT_NAME" == *"$__RADIX"* ]] && __RUN="TRUE"

          if [ "$__RUN" == "TRUE" ]; then
                  echo "Running script `basename $script`"
                . $script
                  RET=$?
                  [ $RET -ne 0 ] && exit 3
                  cd $__CURR_DIR
          fi
  done
}

##### MAIN #####

export VERSION="${1}"
export REPO
export IMAGE

init

execHooks pre_create

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

if [ -z "${CREATE_LATEST_TAG}" ]; then
  echo "CREATE_LATEST_TAG variable is not set"
  echo "You can add it in the defaults file"
  exit 1
fi


docker build . ${DOCKER_BUILD_PAR_1} ${DOCKER_BUILD_PAR_2} ${DOCKER_BUILD_PAR_3} -t "${REPO}/${IMAGE}:${VERSION}"

RET=$?

if [ "$RET" == "0" ]; then
  echo "Image ${IMAGE}:${VERSION} successfully created"
  echo "`date -R` Image created - [${IMAGE}:${VERSION}]" >> $JOURNAL_FILENAME
else
  exit $RET
fi

if [ "${CREATE_LATEST_TAG}" == "YES" ]; then
    docker tag "${REPO}/${IMAGE}:${VERSION}" "${REPO}/${IMAGE}:latest"
fi


execHooks post_create
