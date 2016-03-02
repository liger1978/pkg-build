#!/bin/bash
which gem >/dev/null 2>&1 || {
  echo Installing rubygems...
  yum -y install rubygems
}

which fpm >/dev/null 2>&1 || {
  echo Installing dev tools...
  yum -y install ruby-devel gcc
  echo Installing fpm...
  gem install fpm
}

which rpmbuild >/dev/null 2>&1 || {
  echo Installing rpm-build... 
  yum -y install rpm-build
}

which cpanm >/dev/null 2>&1 || {
  echo Installing perl-App-cpanminus...
  yum -y install perl-App-cpanminus
}

[ -e /usr/share/perl5/vendor_perl/local/lib.pm ] || {
  echo Installing perl-local-lib...
  yum -y install perl-local-lib
}

cd /vagrant
make