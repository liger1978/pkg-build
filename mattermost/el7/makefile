# Package Mattermost.
PKG_NAME=mattermost
VERSION=1.3.0
RELEASE=1.el7
ARCH=x86_64
DESCRIPTION=An alternative to proprietary SaaS messaging.
URL=http://www.mattermost.org/
VENDOR=Mattermost
LICENSE=MIT
PACKAGER=grainger@gmail.com

.PHONY: package
package:
	rm -f *.rpm
	fpm \
	-s dir \
	-t rpm \
	-n $(PKG_NAME) \
	-v $(VERSION) \
	-a $(ARCH) \
	-m "$(PACKAGER)" \
	--iteration "$(RELEASE)" \
	--url "$(URL)" \
	--description "$(DESCRIPTION)" \
	--license "$(LICENSE)" \
	/opt/mattermost-$(VERSION) \
	/opt/mattermost \
	/lib/systemd/system/mattermost.service