#!/bin/bash
yum list installed rubygems &> /dev/null || {
  echo Installing rubygems...
  yum -y install rubygems &> /dev/null
}

yum list installed ruby-devel &> /dev/null || {
  echo Installing ruby-devel...
  yum -y install ruby-devel &> /dev/null
}

yum list installed gcc &> /dev/null || {
  echo Installing gcc...
  yum -y install gcc &> /dev/null
}

yum list installed rpm-build &> /dev/null || {
  echo Installing rpm-build... 
  yum -y install rpm-build &> /dev/null
}

gem list fpm -i &> /dev/null || {
  echo Installing fpm...
  gem install fpm  --no-ri --no-rdoc &> /dev/null
}

echo Building RPMs...
cd /vagrant
make > /dev/null