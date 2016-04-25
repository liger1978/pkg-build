#!/bin/bash
# Package Oracle REST Data Services (ORDS) for Apache Tomcat on el7.
cd /vagrant
PKG_NAME="tomcat-ords"
VERSION=$(find ./ -name 'ords*.zip' | cut -d "." -f 3,4,5)
RELEASE='2.el7'
ARCH='x86_64'
DESCRIPTION='Oracle REST Data Services for Apache Tomcat'
VENDOR='Oracle'
LICENSE='Proprietary'
URL='http://www.oracle.com/technetwork/developer-tools/rest-data-services/overview/index.html'
PACKAGER='grainger@gmail.com'
DEPEND1='java >= 1:1.7.0'
DEPEND2='shadow-utils'
TARGET_DIR='/opt/tomcat/webapps'
CONF_DIR='/etc/ords'
BUILD_DIR='/tmp/rpmbuild'
USER='tomcat'
GROUP='tomcat'

echo Building rpms...
rm -f ./*.rpm
rm -rf "${BUILD_DIR}"
rm -rf "${TARGET_DIR}"
rm -rf "${CONF_DIR}"

mkdir -p "${BUILD_DIR}"
mkdir -p "${TARGET_DIR}/params"
mkdir -p "${TARGET_DIR}/i"
mkdir -p "${CONF_DIR}"

\cp ./src/images.tar.gz "${BUILD_DIR}"
\cp ./src/ords*.zip "${BUILD_DIR}"
unzip "${BUILD_DIR}/ords*.zip" -d "${BUILD_DIR}"
\cp "${BUILD_DIR}/ords.war" "${TARGET_DIR}"
tar xzf "${BUILD_DIR}/images.tar.gz" -C "${TARGET_DIR}/i"

cat << EOF > "${TARGET_DIR}/params/ords_params.properties"
db.hostname=localhost
db.password=password
db.port=1521
db.sid=xe
db.username=APEX_PUBLIC_USER
plsql.gateway.add=true
rest.services.apex.add=false
rest.services.ords.add=false
standalone.mode=false
EOF

cat << EOF > "${BUILD_DIR}/pre-script.sh"
getent group ${GROUP} >/dev/null || groupadd -r ${GROUP}
getent passwd ${USER} >/dev/null || \
    useradd -r -g ${GROUP} -d /home/${USER} -s /bin/bash \
    -c "Tomcat system account" ${USER}
exit 0
EOF

cat << EOF > "${BUILD_DIR}/post-script.sh"
chown ${USER}:${GROUP} ${TARGET_DIR}
chown -R ${USER}:${GROUP} ${TARGET_DIR}/i
java -jar ${TARGET_DIR}/ords.war configdir ${CONF_DIR}
java -jar ${TARGET_DIR}/ords.war setup --silent --preserveParamFile
chown -R ${USER}:${GROUP} ${CONF_DIR}
EOF

cat << EOF > "${CONF_DIR}/README"
This directory holds settings for Oracle REST Data Services (ORDS).  To update,
edit "${TARGET_DIR}/params/ords_params.properties" and then run:
java -jar ${TARGET_DIR}/ords.war setup --silent --preserveParamFile
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
"${TARGET_DIR}" \
"${CONF_DIR}"
