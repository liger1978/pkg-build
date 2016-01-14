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

which sqlplus64 >/dev/null 2>&1 || {
  echo Installing Oracle Instant Client...
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
}

cd /vagrant
make