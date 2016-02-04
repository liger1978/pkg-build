ARCH=x86_64

# Package php-pecl-oci8
PKG_NAME1=php-pecl-oci8
DESCRIPTION1=Use the OCI8 extension to access Oracle Database
VERSION=2.0.10
RELEASE1=1.el7
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
META=/var/lib/pear/pkgxml/php-pecl-oci8.xml

# Package oracle-ldconfig-shim
RELEASE2=1.el7
PKG_NAME2=oracle-ldconfig-shim
DESCRIPTION2=Shim to system LD_LIBRARY_PATH for Oracle instant client

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
	-d $(DEPEND1) \
	-d $(DEPEND2) \
	-d $(DEPEND3) \
	-d $(DEPEND4) \
	-d $(DEPEND5) \
	--provides "$(PROVIDES)" \
	--iteration $(RELEASE1) \
	--config-files $(CONF) \
	$(LIB) $(CONF) $(META)

	rm -rf /tmp/fpm/
	mkdir -p /tmp/fpm/etc/ld.so.conf.d/
	echo -e "/usr/lib/oracle/11.2/client64/lib\n" > /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	echo -e "ldconfig\n" > /tmp/fpm/post-script.sh
	chmod 0644 /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	fpm -s dir -t rpm \
	-n $(PKG_NAME2) \
	--description "$(DESCRIPTION2)" \
	-a $(ARCH) \
	-m "$(PACKAGER)" \
	-d $(DEPEND1) \
	-d $(DEPEND2) \
	-d $(DEPEND3) \
	--after-install /tmp/fpm/post-script.sh \
	-C /tmp/fpm/ \
	--rpm-use-file-permissions \
	--iteration $(RELEASE2) \
	etc/
