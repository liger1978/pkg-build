# Package packer for el7.
PKG_NAME=packer
VERSION=0.10.0
RELEASE=1.el7
ARCH=x86_64
DESCRIPTION=Packer automates the creation of any type of machine image
VENDOR=HashiCorp
LICENSE=MPL2
URL=https://www.packer.io/
DOWNLOAD=https://releases.hashicorp.com/$(PKG_NAME)/$(VERSION)/$(PKG_NAME)_$(VERSION)_linux_amd64.zip
PACKAGER=grainger@gmail.com
BUILD_DIR=/tmp/build

.PHONY: package
package:
	rm -f *.rpm
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/opt/packer
	mkdir -p $(BUILD_DIR)/etc/profile.d/
	cp src/packer.sh $(BUILD_DIR)/etc/profile.d/
	wget --no-verbose -P $(BUILD_DIR) $(DOWNLOAD)
	unzip -d $(BUILD_DIR)/opt/packer $(BUILD_DIR)/$(PKG_NAME)_$(VERSION)_linux_amd64.zip
	fpm \
	-s dir \
	-t rpm \
	-C $(BUILD_DIR) \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--iteration $(RELEASE) \
	--architecture $(ARCH) \
	--description "$(DESCRIPTION)" \
	--vendor "$(VENDOR)" \
	--license "$(LICENSE)" \
	--url "$(URL)" \
	--maintainer "$(PACKAGER)" \
	opt/packer \
	etc/profile.d/packer.sh
	rm -rf $(BUILD_DIR)
