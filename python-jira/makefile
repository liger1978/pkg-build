PKG_NAME=jira

.PHONY: package
package:
	rm -f *.rpm
	fpm \
	-s python \
	-t rpm \
	--python-pip=/usr/bin/pip \
	$(PKG_NAME)
	rm -f *.tar.gz
