#!/bin/bash



cp defaults.template ../defaults

cp create_image.sh ../ && chmod 755 ../create_image.sh
cp push_image.sh ../ && chmod 755 ../push_image.sh
