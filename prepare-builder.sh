#!/bin/bash

SRC_DIR=`dirname $0`
DST_DIR=`pwd`

echo "Source directory ${SRC_DIR}"
echo "Source directory ${DST_DIR}"

cp "${SRC_DIR}/defaults.template" "${DST_DIR}/defaults"

ln -fs "${SRC_DIR}/create_image.sh" ${DST_DIR}
ln -fs "${SRC_DIR}/push_image.sh" ${DST_DIR}
