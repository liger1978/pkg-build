# Package mariadb-server-mysql-server-shim for el7.
PKG_NAME=mariadb-server-mysql-server-shim
VERSION=1.0
RELEASE=1.el7
ARCH=x86_64
DESCRIPTION=Shim for packages that require mysql-server.  Installs mariadb-server instead.
LICENSE=GPL
URL=https://github.com/liger1978/pkg-build
PACKAGER=grainger@gmail.com
PROVIDES=mysql-server
DEPENDS=mariadb-server

.PHONY: package
package:
	rm -f *.rpm
	fpm \
	-s empty \
	-t rpm \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--iteration $(RELEASE) \
	--architecture $(ARCH) \
	--description "$(DESCRIPTION)" \
	--license "$(LICENSE)" \
	--url "$(URL)" \
	--maintainer "$(PACKAGER)" \
	--provides "$(PROVIDES)" \
	--depends "$(DEPENDS)" 
