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
