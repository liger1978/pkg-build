#!/bin/bash
# Package BMC Remedy ARS Mid-Tier for Apache Tomcat on el7.
cd /vagrant
PKG_NAME="tomcat-remedy-ars-mid-tier"
SRC_WAR="midtier_linux"
TGT_WAR="arsys"
VERSION=$(find ./src -name 'midtier*.tar.gz' | cut -d "x" -f 2 | cut -d "." -f 1,2,3)
RELEASE='3.el7'
ARCH='x86_64'
DESCRIPTION='BMC Remedy Mid-Tier is a server component in the Action Request System architecture produced by BMC Software.
It is designed to serve ARS applications and related items across the Internet
and make them accessible for web based clients.'
VENDOR='BMC'
LICENSE='Proprietary'
URL='http://www.bmc.com/'
PACKAGER='grainger@gmail.com'
DEPEND1='java >= 1:1.8.0'
DEPEND2='tomcat >= 8'
DEPEND3='shadow-utils'
TARGET_DIR='/opt/tomcat/webapps'
BUILD_DIR='/tmp/rpmbuild'
USER='tomcat'
GROUP='tomcat'

echo Building rpms...
rm -f ./*.rpm
rm -rf "${BUILD_DIR}"
rm -rf "${TARGET_DIR}"

mkdir -p "${BUILD_DIR}"
mkdir -p "${TARGET_DIR}"

\cp ./src/midtier*.tar.gz "${BUILD_DIR}"
for i in "${BUILD_DIR}/*.tar.gz"; do tar -xvf $i -C "${TARGET_DIR}"; done
mv "${TARGET_DIR}/${SRC_WAR}.war" "${TARGET_DIR}/${TGT_WAR}.war"

#cat << EOF > "/etc/ld.so.conf.d/${PKG_NAME}.conf"
#${TARGET_DIR}/${TGT_WAR}/WEB-INF/lib
#EOF

cat << EOF > "${BUILD_DIR}/pre-script.sh"
getent group ${GROUP} >/dev/null || groupadd -r ${GROUP}
getent passwd ${USER} >/dev/null || \
    useradd -r -g ${GROUP} -d /home/${USER} -s /bin/bash \
    -c "Tomcat system account" ${USER}
exit 0
EOF

cat << EOF > "${BUILD_DIR}/post-script.sh"
chown -R ${USER}:${GROUP} ${TARGET_DIR}
EOF

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
--before-install "${BUILD_DIR}/pre-script.sh" \
--after-install "${BUILD_DIR}/post-script.sh" \
--depends "${DEPEND1}" \
--depends "${DEPEND2}" \
--depends "${DEPEND3}" \
"${TARGET_DIR}"
#"/etc/ld.so.conf.d/${PKG_NAME}.conf"
