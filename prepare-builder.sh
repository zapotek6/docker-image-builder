#!/bin/bash

SRC_DIR=`dirname $0`
DST_DIR=`pwd`

echo "Preparing builder environment"

echo "Source directory ${SRC_DIR}"
echo "Destination directory ${DST_DIR}"

cp "${SRC_DIR}/defaults.template" "${DST_DIR}/defaults"

ln -fs "${SRC_DIR}/create_image.sh" ${DST_DIR}
ln -fs "${SRC_DIR}/push_image.sh" ${DST_DIR}


echo "Remember to update variables in the [defaults] file"
echo "Remember to update variables in the [defaults] file"
echo
echo "Actual content"
cat "${DST_DIR}/defaults"
