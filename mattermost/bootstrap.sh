#!/bin/bash
moddir='/tmp/vagrant-puppet/environments/vagrant/modules'
modules=( 'puppetlabs/stdlib'
          'puppetlabs/concat'
          'puppetlabs/firewall'
          'puppetlabs/apt'
          'puppetlabs/postgresql'
          'nanliu/staging'
          'jfryman/nginx'
          'liger1978/mattermost' )
[ -d ${moddir} ] || mkdir ${moddir}
for module in "${modules[@]}"
do
  [ -d ${moddir}/${module##*/} ] ||
    puppet module install $module --force --target-dir ${moddir}/
done
