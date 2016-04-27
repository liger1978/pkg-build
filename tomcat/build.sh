#!/bin/bash
# Package Apache Tomcat for el7.
cd /vagrant
PKG_NAME='tomcat'
VERSION='8.0.33'
MAJ_VERSION=$(echo $VERSION | cut -d '.' -f 1)
DOWNLOAD="http://www-us.apache.org/dist/tomcat/tomcat-${MAJ_VERSION}/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz"
RELEASE='1.el7'
ARCH='x86_64'
DESCRIPTION='Apache Servlet/JSP Engine, RI for Servlet 3.1/JSP 2.3 API
Tomcat is the servlet container that is used in the official Reference
Implementation for the Java Servlet and JavaServer Pages technologies.
The Java Servlet and JavaServer Pages specifications are developed by
Sun under the Java Community Process.

Tomcat is developed in an open and participatory environment and
released under the Apache Software License version 2.0. Tomcat is intended
to be a collaboration of the best-of-breed developers from around the world.'
VENDOR='The Apache Software Foundation'
LICENSE='ASL 2.0'
URL='http://tomcat.apache.org/'
PACKAGER='grainger@gmail.com'
DEPEND1='java >= 1:1.7.0'
DEPEND2='shadow-utils'
PROVIDES1='tomcat'
PROVIDES2='config(tomcat)'
TARGET_DIR='/opt'
BUILD_DIR='/tmp/rpmbuild'
USER='tomcat'
GROUP='tomcat'

echo Building rpms...
rm -f ./*.rpm
rm -rf "${BUILD_DIR}"
rm -rf "${TARGET_DIR}/${PKG_NAME}"
rm -f "/lib/systemd/system/${PKG_NAME}.service"
rm -f "/etc/sysconfig/${PKG_NAME}"
systemctl daemon-reload

mkdir -p "${BUILD_DIR}"

wget --no-verbose -P "${BUILD_DIR}" "${DOWNLOAD}" 
tar xzf "${BUILD_DIR}/apache-tomcat-${VERSION}.tar.gz" -C "${TARGET_DIR}"
mv "${TARGET_DIR}/apache-tomcat-${VERSION}" "${TARGET_DIR}/${PKG_NAME}"

cat << EOF > "/etc/sysconfig/${PKG_NAME}"
JAVA_HOME=/usr/lib/jvm/jre
CATALINA_PID=${TARGET_DIR}/${PKG_NAME}/temp/tomcat.pid
CATALINA_HOME=${TARGET_DIR}/${PKG_NAME}
CATALINA_BASE=${TARGET_DIR}/${PKG_NAME}
CATALINA_OPTS='-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
JAVA_OPTS='-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
EOF

cat << EOF > "/lib/systemd/system/${PKG_NAME}.service"
[Unit]
Description=${PKG_NAME}
After=syslog.target network.target

[Service]
EnvironmentFile=/etc/sysconfig/${PKG_NAME}
Type=forking

ExecStart=${TARGET_DIR}/${PKG_NAME}/bin/startup.sh
ExecStop=${TARGET_DIR}/${PKG_NAME}/bin/shutdown.sh

User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

cat << EOF > "${BUILD_DIR}/pre-script.sh"
getent group ${GROUP} >/dev/null || groupadd -r ${GROUP}
getent passwd ${USER} >/dev/null || \
    useradd -r -g ${GROUP} -d /home/${USER} -s /bin/bash \
    -c "Tomcat system account" ${USER}
exit 0
EOF

cat << EOF > "${BUILD_DIR}/post-script.sh"
chown -R ${USER}:${GROUP} ${TARGET_DIR}/${PKG_NAME}
systemctl daemon-reload
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
--provides "${PROVIDES1}" \
--provides "${PROVIDES2}" \
"${TARGET_DIR}/${PKG_NAME}" \
"/etc/sysconfig/${PKG_NAME}" \
"/lib/systemd/system/${PKG_NAME}.service"
