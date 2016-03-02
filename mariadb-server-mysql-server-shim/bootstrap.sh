#!/bin/bash
which gem >/dev/null 2>&1 || {
  echo Installing rubygems...
  yum -y install rubygems > /dev/null 2>&1
}

which fpm >/dev/null 2>&1 || {
  echo Installing dev tools...
  yum -y install ruby-devel gcc > /dev/null
  echo Installing fpm...
  gem install fpm > /dev/null
}

which rpmbuild >/dev/null 2>&1 || {
  echo Installing rpm-build... 
  yum -y install rpm-build > /dev/null
}

echo Building RPMs...
cd /vagrant
make > /dev/null