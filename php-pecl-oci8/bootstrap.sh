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

which sqlplus64 >/dev/null 2>&1 || {
  echo Installing Oracle Instant Client...
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm -nv > /dev/null 2>&1
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm -nv > /dev/null 2>&1
  wget http://mir-cern.ihep.ac.cn/cern/centos/7/cernonly/x86_64/Packages/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm -nv > /dev/null 2>&1
  yum -y localinstall ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm > /dev/null
  yum -y localinstall ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm > /dev/null
  yum -y localinstall ./oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm > /dev/null
}

which phpize >/dev/null 2>&1 || {
  echo Installing PHP development packages...
  yum -y install php > /dev/null
  yum -y install php-devel > /dev/null
  yum -y install php-cli > /dev/null
}

which pecl >/dev/null 2>&1 || {
  echo Installing PEAR...
  yum -y install php-pear > /dev/null
}

[ -e /usr/lib64/php/modules/oci8.so ] || {
  echo Downloading oci8 PHP module...
  pecl download oci8-2.0.10 > /dev/null
  echo Unzipping oci8 PHP module...
  tar xfz oci8-2.0.10.tgz > /dev/null
  mkdir -p /var/lib/pear/pkgxml/ > /dev/null
  cp package.xml /var/lib/pear/pkgxml/php-pecl-oci8.xml
  cd oci8-2.0.10 > /dev/null
  echo Building oci8 PHP module...
  phpize > /dev/null
  ./configure --with-oci8=shared,instantclient,/usr/lib/oracle/11.2/client64/lib/ > /dev/null
  make > /dev/null
  make install > /dev/null
  cat >/etc/php.d/oci8.ini <<EOL
[OCI8]
extension=oci8.so
EOL

}

echo Building RPMs...
cd /vagrant
make > /dev/null