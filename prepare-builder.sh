#!/bin/bash

SRC_DIR=`dirname $0`
DST_DIR=`pwd`

echo "Preparing builder environment"

echo "Source directory ${SRC_DIR}"
echo "Destination directory ${DST_DIR}"

#ln -fs "${SRC_DIR}/create_image.sh" ${DST_DIR}
#ln -fs "${SRC_DIR}/push_image.sh" ${DST_DIR}

ln -fs "${SRC_DIR}/build" ${DST_DIR}

if [ ! -d ${DST_DIR}/hooks ]; then
    cp -r "${SRC_DIR}/hooks_example" "${DST_DIR}/hooks"
fi 

if [ ! -f ${DST_DIR}/defaults ]; then
    cp "${SRC_DIR}/defaults.template" "${DST_DIR}/defaults"

    echo "Remember to update variables in the [defaults] file"
    echo
    echo "Actual content"
    cat "${DST_DIR}/defaults"
fi 
