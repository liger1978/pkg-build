# Package perl-DBD-Oracle
SRC_NAME=DBD::Oracle
RELEASE=3
PACKAGER=grainger@gmail.com
LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib/
ORACLE_HOME=/usr/lib/oracle/11.2/client64/
DEPEND1=oracle-instantclient11.2-basic
DEPEND2=oracle-instantclient11.2-sqlplus
DEPEND3=oracle-instantclient11.2-devel
DEPEND4=oracle-ldconfig-shim
PROVIDES=perl(DBD::Oracle)

# Package oracle-ldconfig-shim
SHIM_RELEASE=1.el7
PKG_NAME=oracle-ldconfig-shim
ARCH=x86_64
DESCRIPTION=Shim to system LD_LIBRARY_PATH for Oracle instant client

.PHONY: package
package: 
	rm -f *.rpm
	export ORACLE_HOME=$(ORACLE_HOME); \
	export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH); \
	fpm -s cpan -t rpm \
	-m "$(PACKAGER)" \
	-d $(DEPEND1) \
	-d $(DEPEND2) \
	-d $(DEPEND3) \
	-d $(DEPEND4) \
	--provides "$(PROVIDES)" \
	--iteration $(RELEASE) \
	--no-cpan-sandbox-non-core \
	$(SRC_NAME)
	rm -rf /tmp/fpm/
	mkdir -p /tmp/fpm/etc/ld.so.conf.d/
	echo -e "/usr/lib/oracle/11.2/client64/lib\n" > /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	echo -e "ldconfig\n" > /tmp/fpm/post-script.sh
	chmod 0644 /tmp/fpm/etc/ld.so.conf.d/oracle.conf
	fpm -s dir -t rpm \
	-n $(PKG_NAME) \
	--description "$(DESCRIPTION)" \
	-a $(ARCH) \
	-m "$(PACKAGER)" \
	-d $(DEPEND1) \
	-d $(DEPEND2) \
	-d $(DEPEND3) \
	--after-install /tmp/fpm/post-script.sh \
	-C /tmp/fpm/ \
	--rpm-use-file-permissions \
	--iteration $(SHIM_RELEASE) \
	etc/
