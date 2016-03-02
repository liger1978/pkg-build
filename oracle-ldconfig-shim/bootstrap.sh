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

cd /vagrant
make