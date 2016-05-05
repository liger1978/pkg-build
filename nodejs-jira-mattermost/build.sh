#!/bin/bash
# Package nodejs-jira-mattermost for el7.
cd /vagrant
SRC_PKG_NAME='jira-mattermost'
PKG_NAME="nodejs-${SRC_PKG_NAME}"
RELEASE='3.el7'
ARCH='x86_64'
DESCRIPTION='A webhook translator for JIRA to Mattermost'
VENDOR='vrenjith'
LICENSE='Unknown'
URL='https://github.com/liger78/jira-matter-bridge'
DOWNLOAD='vrenjith/jira-matter-bridge'
PACKAGER='grainger@gmail.com'
DEPEND1='nodejs > 5'

echo Building rpms...
rm -f *.rpm

cat << EOF > "/lib/systemd/system/${PKG_NAME}.service"
[Unit]
Description=${PKG_NAME}
After=syslog.target network.target

[Service]
EnvironmentFile=/etc/sysconfig/${PKG_NAME}
Type=simple
WorkingDirectory=/usr/lib/node_modules/${SRC_PKG_NAME}
ExecStart=/bin/npm start
PIDFile=/var/spool/${PKG_NAME}/pid/master.pid
User=nobody
Group=nobody

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > "/etc/sysconfig/${PKG_NAME}"
PORT=3000
MATTERMOST_SERVER_PORT=80
MATTERMOST_SERVER_PATH=/hooks/
MATTERMOST_SERVER_PROTO=http
MATTERMOST_SERVER=localhost
EOF

echo -e "/bin/systemctl daemon-reload\n" > /tmp/post-script.sh
npm install -g "${DOWNLOAD}"

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
--after-remove /tmp/post-script.sh \
--depends "${DEPEND1}" \
/usr/lib/node_modules/"${SRC_PKG_NAME}" \
/lib/systemd/system/"${PKG_NAME}".service \
/etc/sysconfig/"${PKG_NAME}"
