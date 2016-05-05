#!/bin/bash
# Package nodejs-yo for el7.
cd /vagrant
SRC_PKG_NAME='yo'
PKG_NAME="nodejs-${SRC_PKG_NAME}"
RELEASE='2.el7'
ARCH='x86_64'
DESCRIPTION='CLI tool for running Yeoman generators'
VENDOR='Google'
LICENSE='BSD-2-Clause'
URL='https://www.npmjs.com/package/yo'
PACKAGER='grainger@gmail.com'
DEPEND1='nodejs > 5'

echo Building rpms...
rm -f *.rpm

npm install -g "${SRC_PKG_NAME}"

echo -e "/usr/lib/node_modules/yo/node_modules/yeoman-doctor/lib/cli.js\n" > /tmp/post-script.sh

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
--after-install /tmp/post-script.sh \
--depends "${DEPEND1}" \
/usr/lib/node_modules/"${SRC_PKG_NAME}" \
/usr/bin/"${SRC_PKG_NAME}" \
