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

yum list installed gcc-c++ &> /dev/null || {
  echo Installing gcc-c++...
  yum -y install gcc-c++ &> /dev/null
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
  echo Installing fpm...
  gem install fpm  --no-ri --no-rdoc &> /dev/null
}

[ -f /etc/yum.repos.d/nodesource.repo ] || {
  echo Installing nodejs yum repo...
  cat << EOF > /etc/yum.repos.d/nodesource.repo
[live-centos-7-x86_64-nodesource_nodejs]
name=live-centos-7-x86_64-nodesource_nodejs
baseurl=https://rpm.nodesource.com/pub_5.x/el/7/x86_64/
enabled=1
gpgcheck=0
EOF
  yum clean expire-cache &> /dev/null
}

yum list installed nodejs &> /dev/null || {
 echo Installing nodejs...
 yum -y install nodejs &> /dev/null
 echo Updating npm...
 npm install npm -g &> /dev/null
 echo Installing yo...
 npm install -g "yo" &> /dev/null
 echo Installing generator-hubot...
 npm install -g "generator-hubot" &> /dev/null
 echo Installing hubot...
 npm install -g "hubot" &> /dev/null
}