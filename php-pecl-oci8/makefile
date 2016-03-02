# Package php-pecl-oci8
PKG_NAME1=php-pecl-oci8
DESCRIPTION1=Use the OCI8 extension to access Oracle Database
VERSION=2.0.10
RELEASE1=3.el7
ARCH=x86_64
LICENSE=PHP
PACKAGER=grainger@gmail.com
DEPEND1=oracle-instantclient11.2-basic
DEPEND2=oracle-instantclient11.2-sqlplus
DEPEND3=oracle-instantclient11.2-devel
DEPEND4=oracle-ldconfig-shim
DEPEND5=/usr/bin/pecl
PROVIDES=php-pecl(oci8)
LIB=/usr/lib64/php/modules/oci8.so
CONF=/etc/php.d/oci8.ini
DOC=/usr/share/doc/pecl/oci8
META=/var/lib/pear/pkgxml/php-pecl-oci8.xml
URL=https://pecl.php.net/package/oci8

.PHONY: package
package: 
	rm -f *.rpm
	fpm -s dir -t rpm \
	-n $(PKG_NAME1) \
	-v $(VERSION) \
	-a $(ARCH) \
	--description "$(DESCRIPTION1)" \
	--license "$(LICENSE)" \
	-m "$(PACKAGER)" \
	--url "$(URL)" \
	-d $(DEPEND1) \
	-d $(DEPEND2) \
	-d $(DEPEND3) \
	-d $(DEPEND4) \
	-d $(DEPEND5) \
	--provides "$(PROVIDES)" \
	--iteration $(RELEASE1) \
	--config-files $(CONF) \
	$(LIB) $(CONF) $(DOC) $(META)
