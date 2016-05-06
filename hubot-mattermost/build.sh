#!/bin/bash
# Package a customised hubot with mattermost adapter for el7.
cd /vagrant
. ./config.conf
PKG_NAME="${PKG_NAME_PREFIX}-hubot-mattermost"
RELEASE="${BOT_RELEASE}.el7"
ARCH='x86_64'
DESCRIPTION="${BOT_DESCRIPTION}"
VENDOR='Renan Vicente'
LICENSE='MIT'
URL='https://www.npmjs.com/package/hubot-mattermost'
PACKAGER='grainger@gmail.com'
DEPEND1='nodejs > 5'
DEPEND2='redis'

echo Building rpms...
rm -f *.rpm
rm -rf "${INSTALL_DIR}/${PKG_NAME}"

cat << EOF > "/lib/systemd/system/${PKG_NAME}.service"
[Unit]
Description=${PKG_NAME}
After=syslog.target network.target

[Service]
EnvironmentFile=/etc/sysconfig/${PKG_NAME}
Type=simple
WorkingDirectory=${INSTALL_DIR}/${PKG_NAME}
ExecStart=/usr/bin/node ${INSTALL_DIR}/${PKG_NAME}/node_modules/.bin/coffee ${INSTALL_DIR}/${PKG_NAME}/node_modules/.bin/hubot -a mattermost --name "${BOT_NAME}"
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

cat << EOF > "/etc/sysconfig/${PKG_NAME}"
PATH=node_modules/.bin:node_modules/hubot/node_modules/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
EXPRESS_PORT=${BOT_PORT}
MATTERMOST_ENDPOINT='${MATTERMOST_ENDPOINT}'
MATTERMOST_CHANNEL='${MATTERMOST_CHANNEL}'
MATTERMOST_INCOME_URL='${MATTERMOST_INCOME_URL}'
MATTERMOST_TOKEN='${MATTERMOST_TOKEN}'
MATTERMOST_ICON_URL='${MATTERMOST_ICON_URL}'
MATTERMOST_HUBOT_USERNAME='${MATTERMOST_HUBOT_USERNAME}'
MATTERMOST_SELFSIGNED_CERT='${MATTERMOST_SELFSIGNED_CERT}'
EOF

cat << EOF > "/tmp/pre-script.sh"
getent group ${PKG_NAME} >/dev/null || groupadd -r ${PKG_NAME}
getent passwd ${PKG_NAME} >/dev/null || \
    useradd -r -g ${PKG_NAME} -d /home/${PKG_NAME} -s /bin/bash \
    -c "${DESCRIPTION}" ${PKG_NAME}
exit 0
EOF

cat << EOF > "/tmp/post-script.sh"
chown -R ${PKG_NAME}:${PKG_NAME} "${INSTALL_DIR}/${PKG_NAME}"
/bin/systemctl daemon-reload
EOF

echo -e "/bin/systemctl daemon-reload\n" > /tmp/remove-script.sh

mkdir "${INSTALL_DIR}/${PKG_NAME}"
mkdir -p ~/.config/configstore
chmod g+rwx ~ ~/.config ~/.config/configstore "${INSTALL_DIR}/${PKG_NAME}"
cd "${INSTALL_DIR}/${PKG_NAME}"
yo hubot --no-insight --owner="${BOT_OWNER}" \
                      --name="${BOT_NAME}" \
                      --description="${BOT_DESCRIPTION}" \
                      --adapter=mattermost --defaults
cd /vagrant

VERSION=`npm ll -pg --depth=0 hubot-mattermost | grep -o "@.*:" | sed 's/.$//; s/^.//'`

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
--config-files "/etc/sysconfig/${PKG_NAME}" \
--config-files "${INSTALL_DIR}/${PKG_NAME}/scripts" \
--config-files "${INSTALL_DIR}/${PKG_NAME}/external-scripts.json" \
--config-files "${INSTALL_DIR}/${PKG_NAME}/hubot-scripts.json" \
"${INSTALL_DIR}/${PKG_NAME}" \
"/lib/systemd/system/${PKG_NAME}".service \
"/etc/sysconfig/${PKG_NAME}"
