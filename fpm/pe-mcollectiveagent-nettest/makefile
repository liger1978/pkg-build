# Package mcollective-nettest-agent for Puppet Enterprise.
SRC_NAME=mcollective-nettest-agent
PKG_NAME=pe-mcollective-nettest-agent
VERSION=3.0.4
ARCH=noarch
DESCRIPTION=Nettest agent for Puppet Enterprise mcollective.
URL=https://github.com/puppetlabs/$(SRC_NAME)
PACKAGER=grainger@gmail.com
PE_ROOT=/opt/puppet

.PHONY: package
package:
	rm -f $(VERSION).tar.gz
	rm -rf $(SRC_NAME)-$(VERSION)
	rm -f *.rpm
	wget $(URL)/archive/$(VERSION).tar.gz
	tar xzf $(VERSION).tar.gz
	fpm \
	-s dir \
	-t rpm \
	-n $(PKG_NAME) \
	-v $(VERSION) \
	-a $(ARCH) \
	-C $(SRC_NAME)-$(VERSION) \
	-m "$(PACKAGER)" \
	--url "$(URL)" \
	--description "$(DESCRIPTION)" \
	--prefix $(PE_ROOT)/libexec/mcollective/mcollective \
	--depends pe-rubygem-net-ping \
	agent \
	aggregate \
	application \
	data \
	util \
	validator
	rm -f $(VERSION).tar.gz
	rm -rf $(SRC_NAME)-$(VERSION)
	