PKG_NAME=pam-shim
VERSION=1.0
RELEASE=3.el
ARCH=noarch
DESCRIPTION=Shim to provide pam(x86-32)
VENDOR=grainger@gmail.com
PACKAGER=grainger@gmail.com
LICENSE=GPL
URL=https://github.com/liger1978/pkg-build
DEPEND=pam
PROVIDES=pam(x86-32)

.PHONY: package
package:
	rm -f *.rpm
	rm -f /etc/pam-shim
	echo -e "This is a dummy file\n" > /etc/pam-shim
	fpm -s dir -t rpm \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--iteration $(RELEASE) \
	--architecture $(ARCH) \
	--description "$(DESCRIPTION)" \
	--vendor "$(VENDOR)" \
	--maintainer "$(PACKAGER)" \
	--license "$(LICENSE)" \
	--url "$(URL)" \
	--depends $(DEPEND) \
	--provides "$(PROVIDES)" \
	/etc/pam-shim
