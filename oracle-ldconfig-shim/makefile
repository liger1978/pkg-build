# Package oracle-ldconfig-shim
PKG_NAME=oracle-ldconfig-shim
VERSION=1.0
RELEASE=3.el7
ARCH=x86_64
DESCRIPTION=Shim to provide oracle-instantclient packages and amend LD_LIBRARY_PATH to include Oracle instant client libraries
VENDOR=grainger@gmail.com
PACKAGER=grainger@gmail.com
LICENSE=GPL
URL=https://github.com/liger1978/pkg-build
DEPEND1=oracle-instantclient11.2-basic
DEPEND2=oracle-instantclient11.2-sqlplus
DEPEND3=oracle-instantclient11.2-devel
PROVIDES1=oracle-instantclient-basic
PROVIDES2=oracle-instantclient-sqlplus
PROVIDES3=oracle-instantclient-devel

.PHONY: package
package: 
	rm -f *.rpm
	rm -rf /tmp/fpm/
	mkdir -p /tmp/fpm/etc/ld.so.conf.d/
	echo -e "/usr/lib/oracle/11.2/client64/lib\n" > /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	echo -e "ldconfig\n" > /tmp/fpm/post-script.sh
	chown root:root /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	chmod 0644 /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	fpm -s dir -t rpm \
	-C /tmp/fpm/ \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--iteration $(RELEASE) \
	--architecture $(ARCH) \
	--description "$(DESCRIPTION)" \
	--vendor "$(VENDOR)" \
	--maintainer "$(PACKAGER)" \
	--license "$(LICENSE)" \
	--url "$(URL)" \
	--depends $(DEPEND1) \
	--depends $(DEPEND2) \
	--depends $(DEPEND3) \
	--provides "$(PROVIDES1)" \
	--provides "$(PROVIDES2)" \
	--provides "$(PROVIDES3)" \
	--after-install /tmp/fpm/post-script.sh \
	--rpm-use-file-permissions \
	etc/
