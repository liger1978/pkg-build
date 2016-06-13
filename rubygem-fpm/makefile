PKG_NAME=fpm
GEM_DIR=/usr/local/share/gems
.PHONY: package
package:
	rm -f *.rpm
	rm -rf /tmp/build
	mkdir -p /tmp/build
	gem install --no-ri --no-rdoc --install-dir /tmp/build $(PKG_NAME)
	find /tmp/build/cache -name '*.gem' | xargs -rn1 fpm -d ruby -d rubygems \
	--prefix $(GEM_DIR) -s gem -t rpm
