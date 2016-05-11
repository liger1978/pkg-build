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

yum list installed git &> /dev/null || {
  echo Installing git... 
  yum -y install git &> /dev/null
}

which fpm &> /dev/null || {
  echo installing specific_install...
  gem install specific_install --no-ri --no-rdoc &> /dev/null
  echo Installing fpm...
  gem specific_install -l https://github.com/liger1978/fpm &> /dev/null
}

yum list installed epel-release &> /dev/null || {
  echo Installing epel-release... 
  yum -y install epel-release &> /dev/null
}

yum list installed python-pip &> /dev/null || {
  echo Installing python-pip... 
  yum -y install python-pip &> /dev/null
  echo Updating python-pip...
  pip install pip --upgrade &> /dev/null
}

yum list installed pytest &> /dev/null || {
  echo Installing pytest... 
  yum -y install pytest &> /dev/null
}

echo Building RPMs...
cd /vagrant
make > /dev/null