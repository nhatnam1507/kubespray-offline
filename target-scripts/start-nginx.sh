#!/bin/bash

source ./config.sh

BASEDIR="."
if [ ! -d images ] && [ -d ../outputs ]; then
    BASEDIR="../outputs"  # for tests
fi
BASEDIR=$(cd $BASEDIR; pwd)

NGINX_IMAGE=nginx:1.25.2

echo "===> Start repository server"
sudo /usr/local/bin/nerdctl run -d \
    --network host \
    --restart always \
    --name nginx-repos \
    -v ${BASEDIR}/repos:/usr/share/nginx/html \
    ${NGINX_IMAGE} || exit 1

echo "===> Start static files server"
sudo /usr/local/bin/nerdctl run -d \
    -p 8080:80 \
    --restart always \
    --name nginx-files \
    -v ${BASEDIR}/files:/usr/share/nginx/html/download \
    -v ${BASEDIR}/nginx.conf:/etc/nginx/nginx.conf \
    ${NGINX_IMAGE} || exit 1
