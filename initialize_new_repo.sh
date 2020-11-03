#!/bin/bash

git init && \
mkdir files && \
git submodule add https://bitbucket.org/zapotek6/image-builder.git && \
pushd image-builder && \
git checkout v2 && \
popd && \
./image-builder/prepare-builder.sh
