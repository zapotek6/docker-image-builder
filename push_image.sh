#!/bin/bash

. ./defaults

JOURNAL_FILENAME=${JOURNAL_FILENAME:-journal.log}

VERSION="${1}"

if [ -z "${VERSION}" ]; then
  echo "Missing ${IMAGE} image version"
  echo
  echo "Usage: ${0} <image version>"
  exit 1
fi

sudo docker tag "${IMAGE}:${VERSION}" "${REPO}/${IMAGE}:${VERSION}" && \
sudo docker tag "${IMAGE}:${VERSION}" "${REPO}/${IMAGE}:latest" && \
sudo docker push "${REPO}/${IMAGE}:${VERSION}" && \
sudo docker push "${REPO}/${IMAGE}:latest"

RET=$?

if [ "$RET" == "0" ]; then
  echo "Image ${REPO}/${IMAGE}:${VERSION} successfully pushed"
  echo "`date -R` Image pushed  - [${REPO}/${IMAGE}:${VERSION}]" >> $JOURNAL_FILENAME
fi