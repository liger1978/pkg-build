$fail_message = 'OS not supported'
case $::operatingsystem {
  'Debian': {
    case $::operatingsystemmajrelease {
      '8': {
        $makepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
        $build_dir = 'debian8'
      }
      default: {
        fail($fail_message)
      }
    }
    $packages = {
      'ruby-dev' => {},
      'gcc'      => {},
      'make'     => {},
      'fpm' => { provider => 'gem',
                 require  => Package['ruby-dev','gcc','make'], },
    }
  }
  'CentOS': {
    case $::operatingsystemmajrelease {
      '6': {
        $makepath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/puppetlabs/bin:/home/vagrant/bin'
        $build_dir = 'el6'
        $cabin_version = '0.7.2'
      }
      '7': {
        $makepath = '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/puppetlabs/bin:/home/vagrant/.local/bin:/home/vagrant/bin'
        $build_dir = 'el7'
        $cabin_version = 'latest'
      }
      default: {
        fail($fail_message)
      }
    }
    $packages = {
      'rubygems'   => {},
      'ruby-devel' => {},
      'gcc'        => {},
      'rpm-build'  => {},
      'cabin'      => { provider => 'gem',
                        ensure   => $cabin_version,
                        require  => Package['rubygems','ruby-devel','gcc'], },
      'fpm'        => { provider => 'gem',
                        require  => Package['cabin'], },
    }
  }
  default: {
    fail($fail_message)
  }
}

create_resources(package,$packages)

class{ 'mattermost':
  version        => '1.3.0',
  manage_service => false,
}

exec{ 'make':
  cwd      =>  "/vagrant/${build_dir}",
  command  =>  'make',
  path     =>  $makepath,
  provider => 'shell',
  require  => [Package[keys($packages)],Class['mattermost']],
}