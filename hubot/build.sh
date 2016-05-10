#!/bin/bash
# Package a customised hubot with mattermost adapter for el7.
cd /vagrant

# Create conf file from example if it doesn't exist
[[ -f ./config.conf ]] || {
  \cp ./config.conf.example ./config.conf
}

# Source config file and set other variables
. ./config.conf
PKG_NAME="hubot-${PKG_NAME_SUFFIX}"
RELEASE="${BOT_RELEASE}.el7"
ARCH='x86_64'
DESCRIPTION="${BOT_DESCRIPTION}"
VENDOR='GitHub'
LICENSE='MIT'
URL='https://hubot.github.com/'
DEPEND1='nodejs > 5'
DEPEND2='redis'

echo Building rpms...

# Clean up before build
rm -f *.rpm
rm -rf "${INSTALL_DIR}/${PKG_NAME}"

# Build systemd unit file
cat << EOF > "/lib/systemd/system/${PKG_NAME}.service"
[Unit]
Description=${PKG_NAME}
After=syslog.target network.target

[Service]
EnvironmentFile=/etc/sysconfig/${PKG_NAME}
Type=simple
WorkingDirectory=${INSTALL_DIR}/${PKG_NAME}
ExecStart=/usr/bin/node ${INSTALL_DIR}/${PKG_NAME}/node_modules/.bin/coffee ${INSTALL_DIR}/${PKG_NAME}/node_modules/.bin/hubot -a ${BOT_ADAPTER} --name "${BOT_NAME}"
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
    useradd -r -g ${PKG_NAME} -d /home/${PKG_NAME} -s /bin/bash \
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

# Create env.conf file from example if it doesn't exist
[[ -f ./env.conf ]] || {
  \cp ./env.conf.example ./env.conf
}

# Create packages.conf file from example if it doesn't exist
[[ -f ./packages.conf ]] || {
  \cp ./packages.conf.example ./packages.conf
}

# Create external-scripts.conf file drom example if it doesn't exist
[[ -f ./external-scripts.conf ]] || {
  \cp ./external-scripts.conf.example ./external-scripts.conf
}

# Copy hubot environment conf file into place ready for packaging 
\cp env.conf "/etc/sysconfig/${PKG_NAME}"

# Create bot's install directory
mkdir "${INSTALL_DIR}/${PKG_NAME}"

# Hack to make bot installation work as root
mkdir -p ~/.config/configstore
chmod g+rwx ~ ~/.config ~/.config/configstore "${INSTALL_DIR}/${PKG_NAME}"

# Create bot
cd "${INSTALL_DIR}/${PKG_NAME}"
yo hubot --no-insight --owner="${BOT_OWNER}" \
                      --name="${BOT_NAME}" \
                      --description="${BOT_DESCRIPTION}" \
                      --adapter="${BOT_ADAPTER}" --defaults

#  Install packages 
while read p; do
  echo "Installing hubot npm package ${p}..."
  npm install $p --save
done < /vagrant/packages.conf

#  Install external scripts
echo -n '[' > ./external-scripts.json
COUNTER=0
while read p; do
  echo "Installing hubot npm external-script package ${p}..."
  npm install $p --save
  if [ "$COUNTER" -gt "0" ]
  then
    echo -n ", " >> ./external-scripts.json
  fi
  echo -en "\n"'  "'"${p}"'"' >> ./external-scripts.json
  let COUNTER=COUNTER+1 
done < /vagrant/external-scripts.conf
echo -e "\n]" >> ./external-scripts.json

cd /vagrant

\cp ./scripts/* "${INSTALL_DIR}/${PKG_NAME}"/scripts

VERSION=`npm ll -pg --depth=0 hubot | grep -o "@.*:" | sed 's/.$//; s/^.//'`

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
