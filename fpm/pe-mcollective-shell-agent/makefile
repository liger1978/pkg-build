# Package mcollective-shell-agent for Puppet Enterprise.
SRC_NAME=mcollective-shell-agent
PKG_NAME=pe-mcollective-shell-agent
VERSION=0.0.2
ARCH=noarch
DESCRIPTION=Shell agent for Puppet Enterprise mcollective.
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
	-C $(SRC_NAME)-$(VERSION)/lib/mcollective \
	-m "$(PACKAGER)" \
	--url "$(URL)" \
	--description "$(DESCRIPTION)" \
	--prefix $(PE_ROOT)/libexec/mcollective/mcollective \
	--depends 'ruby > 1.9' \
	agent \
	application
	rm -f $(VERSION).tar.gz
	rm -rf $(SRC_NAME)-$(VERSION)
	