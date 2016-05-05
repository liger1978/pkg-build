#!/bin/bash
# Package nodejs-generator-hubot for el7.
cd /vagrant
SRC_PKG_NAME='generator-hubot'
PKG_NAME="nodejs-${SRC_PKG_NAME}"
RELEASE='1.el7'
ARCH='x86_64'
DESCRIPTION='A Yeoman generator for creating your own chatbot using the Hubot framework'
VENDOR='GitHub'
LICENSE='MIT'
URL='https://www.npmjs.com/package/generator-hubot'
PACKAGER='grainger@gmail.com'
DEPEND1='nodejs > 5'
DEPEND2='nodejs-yo >= 1.0.0'

echo Building rpms...
rm -f *.rpm

npm install -g "${SRC_PKG_NAME}"

VERSION=`npm ll -pg --depth=0 $SRC_PKG_NAME | grep -o "@.*:" | sed 's/.$//; s/^.//'`

fpm \
-s dir \
-t rpm \
--name "${PKG_NAME}" \
--version "${VERSION}" \
--iteration "${RELEASE}" \
--architecture "${ARCH}" \
--description "${DESCRIPTION}" \
--vendor "${VENDOR}" \
--license "${LICENSE}" \
--url "${URL}" \
--maintainer "${PACKAGER}" \
--depends "${DEPEND1}" \
--depends "${DEPEND2}" \
/usr/lib/node_modules/"${SRC_PKG_NAME}"
