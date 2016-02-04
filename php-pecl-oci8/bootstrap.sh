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

#which cpanm >/dev/null 2>&1 || {
#  echo Installing perl-App-cpanminus...
#  yum -y install perl-App-cpanminus
#}

#[ -e /usr/share/perl5/vendor_perl/local/lib.pm ] || {
#  echo Installing perl-local-lib...
#  yum -y install perl-local-lib
#}

which sqlplus64 >/dev/null 2>&1 || {
  echo Installing Oracle Instant Client...
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
  yum -y localinstall ./oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm
}

which phpize >/dev/null 2>&1 || {
  echo Installing PHP development packages...
  yum -y install php
  yum -y install php-devel
  yum -y install php-cli
}

which pecl >/dev/null 2>&1 || {
  echo Installing PEAR...
  yum -y install php-pear
}

[ -e /usr/lib64/php/modules/oci8.so ] || {
  echo Building oci8 PHP module...
  pecl download oci8-2.0.10
  tar xfz oci8-2.0.10.tgz
  mkdir -p /var/lib/pear/pkgxml/
  cp package.xml /var/lib/pear/pkgxml/php-pecl-oci8.xml
  cd oci8-2.0.10
  phpize
  ./configure --with-oci8=shared,instantclient,/usr/lib/oracle/11.2/client64/lib/
  make
  make install
  echo
  cat >/etc/php.d/oci8.ini <<EOL
[OCI8]
extension=oci8.so
EOL

#cd /vagrant
#make