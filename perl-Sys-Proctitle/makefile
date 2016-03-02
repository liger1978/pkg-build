# Package perl-Sys-Proctitle
SRC_NAME=Sys::Proctitle
PROVIDES=perl(Sys::Proctitle)
RELEASE=1
PACKAGER=grainger@gmail.com

.PHONY: package
package: 
	rm -f *.rpm
	fpm --verbose -s cpan -t rpm \
	--maintainer "$(PACKAGER)" \
	--provides "$(PROVIDES)" \
	--iteration $(RELEASE) \
	--no-cpan-sandbox-non-core \
	--no-cpan-test \
	$(SRC_NAME)



