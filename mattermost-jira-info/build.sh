#!/bin/bash
# Package mattermost-jira-info for el7.
cd /vagrant
PKG_NAME='mattermost-jira-info'
MAJ_VERSION='1'
RELEASE='1.el7'
ARCH='noarch'
DESCRIPTION='View JIRA ticket info in Mattermost'
VENDOR='Wouter van Bommel'
LICENSE='GPL2'
URL='https://github.com/woutervb/mattermost-jira-info'
DOWNLOAD="${URL}.git"
PACKAGER='grainger@gmail.com'
DEPEND1='python'
DEPEND2='python-flask'
DEPEND3='python-jira'
DEPEND4='python-tornado'
INSTALL_DIR='/opt'

echo Building rpms...
rm -f *.rpm
rm -rf "${INSTALL_DIR}/${PKG_NAME}"

git clone "${DOWNLOAD}" "${INSTALL_DIR}/${PKG_NAME}"
VERSION="${MAJ_VERSION}".`git --git-dir "${INSTALL_DIR}/${PKG_NAME}/.git" log -1 --format="%cd" --date="short" | tr -d '-'`

rm -rf "${INSTALL_DIR}/${PKG_NAME}/.git"
\cp "${INSTALL_DIR}/${PKG_NAME}/settings.py.example" \
    "${INSTALL_DIR}/${PKG_NAME}/settings.py"

cat << EOF > "/lib/systemd/system/${PKG_NAME}.service"
[Unit]
Description=${PKG_NAME}
After=syslog.target network.target

[Service]
Type=simple
WorkingDirectory=${INSTALL_DIR}/${PKG_NAME}
ExecStart=${INSTALL_DIR}/${PKG_NAME}/runme.py
PIDFile=/var/spool/${PKG_NAME}/pid/master.pid
User=${PKG_NAME}
Group=${PKG_NAME}
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=${PKG_NAME}

[Install]
WantedBy=multi-user.target
EOF

# Build RPM pre-installation script
cat << EOF > "/tmp/pre-script.sh"
getent group ${PKG_NAME} >/dev/null || groupadd -r ${PKG_NAME}
getent passwd ${PKG_NAME} >/dev/null || \
    useradd -r -g ${PKG_NAME} -d ${INSTALL_DIR}/${PKG_NAME} -s /bin/bash \
    -c "${DESCRIPTION}" ${PKG_NAME}
exit 0
EOF

# Build RPM post-installtion script
cat << EOF > "/tmp/post-script.sh"
chown -R ${PKG_NAME}:${PKG_NAME} "${INSTALL_DIR}/${PKG_NAME}"
/bin/systemctl daemon-reload
EOF

# Build RPM post-removal script 
echo -e "/bin/systemctl daemon-reload\n" > /tmp/remove-script.sh

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
--before-install /tmp/pre-script.sh \
--after-install /tmp/post-script.sh \
--after-remove /tmp/remove-script.sh \
--depends "${DEPEND1}" \
--depends "${DEPEND2}" \
--depends "${DEPEND3}" \
--depends "${DEPEND4}" \
--config-files "${INSTALL_DIR}/${PKG_NAME}/settings.py" \
"${INSTALL_DIR}/${PKG_NAME}" \
"/lib/systemd/system/${PKG_NAME}".service
