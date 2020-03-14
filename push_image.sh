#!/bin/bash

. ./defaults

JOURNAL_FILENAME=${JOURNAL_FILENAME:-journal.log}
HOOKS_DIR="./hooks"
EXECUTE_WITH_SHELL="/bin/bash"

init() {
  [ ! -d "$HOOKS_DIR" ] && mkdir -p $HOOKS_DIR
}

execHooks() {
  __RADIX=$1
  __CURR_DIR=`pwd`
  for script in ${HOOKS_DIR}/*
  do
          __RUN="FALSE"
          __SCRIPT_NAME=`basename $script`
   	  echo "Parsing scripts $script"

	  [[ "$__SCRIPT_NAME" == *"$__RADIX"* ]] && __RUN="TRUE"

          if [ "$__RUN" == "TRUE" ]; then
                  echo "Running per create script `basename $script`"
                $EXECUTE_WITH_SHELL $script
                  RET=$?
                  [ $RET -ne 0 ] && exit 3
                  cd $__CURR_DIR
          fi
  done
}

VERSION="${1}"

init

execHooks pre_push

if [ -z "${VERSION}" ]; then
  echo "Missing ${IMAGE} image version"
  echo
  echo "Usage: ${0} <image version>"
  exit 1
fi

#sudo docker tag "${IMAGE}:${VERSION}" "${REPO}/${IMAGE}:${VERSION}" && \
#sudo docker tag "${IMAGE}:${VERSION}" "${REPO}/${IMAGE}:latest" && \



docker push "${REPO}/${IMAGE}:${VERSION}" && \
docker push "${REPO}/${IMAGE}:latest"

RET=$?

if [ "$RET" == "0" ]; then
  echo "Image ${REPO}/${IMAGE}:${VERSION} successfully pushed"
  echo "`date -R` Image pushed  - [${REPO}/${IMAGE}:${VERSION}]" >> $JOURNAL_FILENAME
else
  exit $RET
fi

execHooks post_push
