#!/bin/bash
script_dir='/vagrant/scripts'
tmp_dir='/vagrant/tmp'
pe_url='https://s3.amazonaws.com/pe-builds/released'
pe_ver='3.8.3'
os_fam='el'
os_ver='7'
os_arch='x86_64'
filename="puppet-enterprise-${pe_ver}-${os_fam}-${os_ver}-${os_arch}"

mkdir -p "${tmp_dir}"

[ -e "${tmp_dir}/${filename}.tar.gz" ] ||
{
  echo Downloading "${pe_url}/${pe_ver}/${filename}.tar.gz..."
  wget -q -P "${tmp_dir}/" "${pe_url}/${pe_ver}/${filename}.tar.gz"
}

[ -d "${tmp_dir}/${filename}" ] ||
{
  echo Extracting "${filename}.tar.gz..."
  tar -C "${tmp_dir}" -xzf "${tmp_dir}/${filename}.tar.gz"
}

[ -d "/opt/puppet" ] ||
{
  echo Installing Puppet Enterprise...
  "${tmp_dir}/${filename}/puppet-enterprise-installer" -a \
  "${script_dir}/centos7pe_answers.txt"
}

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

