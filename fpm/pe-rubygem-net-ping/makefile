# Package net-ping Ruby gem for Puppet Enterprise.
# Requires Puppet Enterprise to be installed before running "make".
NAME=pe-rubygem-net-ping
DESCRIPTION=The net-ping Ruby library for Puppet Enterprise
PACKAGER=grainger@gmail.com
PE_ROOT=opt/puppet
PE_GEM_VERSION=1.9.1

.PHONY: package
package:
	rm -rf *.rpm
	fpm \
	--verbose \
	-s gem \
	-t rpm \
	-n $(NAME) \
	-m "$(PACKAGER)" \
	--description "$(DESCRIPTION)" \
	--gem-gem /$(PE_ROOT)/bin/gem \
	--exclude $(PE_ROOT)/lib/ruby/gems/$(PE_GEM_VERSION)/doc \
	net-ping