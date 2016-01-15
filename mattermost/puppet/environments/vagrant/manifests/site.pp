$fail_message = 'OS not supported'
$version = '1.3.0'
$url = 'http://www.mattermost.org/'
$desc = 'An alternative to proprietary SaaS messaging.'
$vendor = 'Mattermost'
$license = 'MIT'
$arch = 'x86_64'
$packager = 'grainger@gmail.com'
$release_number = '1'
$user = 'mattermost'
$group = 'mattermost'
$pkg_uid = '1500'
$pkg_gid = '1500'
$symlink = '/opt/mattermost'
$dir = "/opt/mattermost-${version}"

case $::operatingsystem {
  'Debian': {
    case $::operatingsystemmajrelease {
      '6': {
        $makepath = '/var/lib/gems/1.8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
        $service_file = '/etc/init.d/mattermost'
        $os_release = 'squeeze'
        $cabin_version = '0.7.2'
      }
      '7': {
        $makepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
        $service_file = '/etc/init.d/mattermost'
        $os_release = 'wheezy'
        $cabin_version = 'latest'
      }
      '8': {
        $makepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
        $service_file = '/lib/systemd/system/mattermost.service'
        $os_release = 'jessie'
        $cabin_version = 'latest'
      }
      default: {
        fail($fail_message)
      }
    }
    $pkg_target = 'deb'
    $bld_dependencies = {
      'rubygems' => {},
      'ruby'     => {},
      'ruby-dev' => {},
      'gcc'      => {},
      'make'     => {},
      'cabin'      => { provider => 'gem',
                        ensure   => $cabin_version,
                        require  => Package['ruby','rubygems','ruby-dev','gcc','make'], },
      'fpm' => {provider => 'gem',
                require  => Package['cabin'], },
    }
  }
  'CentOS': {
    case $::operatingsystemmajrelease {
      '6': {
        $makepath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/puppetlabs/bin:/home/vagrant/bin'
        $service_file = '/etc/init.d/mattermost'
        $os_release = '.el6'
        $cabin_version = '0.7.2'
      }
      '7': {
        $makepath = '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/puppetlabs/bin:/home/vagrant/.local/bin:/home/vagrant/bin'
        $service_file = '/lib/systemd/system/mattermost.service'
        $os_release = '.el7'
        $cabin_version = 'latest'
      }
      default: {
        fail($fail_message)
      }
    }
    $pkg_target = 'rpm'
    $bld_dependencies = {
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
  'Ubuntu': {
    case $::operatingsystemmajrelease {
      '14.04': {
        $makepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
        $service_file = '/etc/init/mattermost.conf'
        $os_release = 'trusty'
      }
      default: {
        fail($fail_message)
      }
    }
    $pkg_target = 'deb'
    $bld_dependencies = {
      'ruby'     => {},
      'ruby-dev' => {},
      'gcc'      => {},
      'make'     => {},
      'fpm' => {provider => 'gem',
                require  => Package['ruby','ruby-dev','gcc','make'], },
    }
  }
  default: {
    fail($fail_message)
  }
}
$bld_release = "${release_number}${os_release}"

create_resources(package,$bld_dependencies)

class{ 'mattermost':
  version        => $version,
  manage_service => false,
  dir            => $dir,
  symlink        => $symlink,
}

file{ '/tmp/post_script.sh':
  content => "getent group ${group} >/dev/null || groupadd -f -g ${pkg_gid} -r ${group}
if ! getent passwd ${user} >/dev/null ; then
    if ! getent passwd ${pkg_uid} >/dev/null ; then
      useradd -r -u ${pkg_uid} -g ${group} -d ${symlink} -s /sbin/nologin -c \"Mattermost system user\" ${user}
    else
      useradd -r -g ${group} -d ${symlink} -s /sbin/nologin -c \"Mattermost system user\" ${user}
    fi
fi
chown -R ${user}:${group} ${dir}
exit 0
",
  mode    => '0755',
}

exec{ 'build':
  cwd      =>  '/vagrant',
  command  =>  "rm -f *${os_release}*.${pkg_target} &&
                fpm \
                -s dir \
                -t ${pkg_target} \
                -n mattermost \
                -v ${version} \
                -a ${arch} \
                -m \"${packager}\" \
                --iteration \"${bld_release}\" \
                --url \"${url}\" \
                --description \"${desc}\" \
                --vendor ${vendor} \
                --license \"${license}\" \
                --after-install /tmp/post_script.sh \
                --config-files ${dir}/config/ \
                /opt/mattermost-${version} \
                /opt/mattermost \
                ${service_file}",
  path     =>  $makepath,
  provider => 'shell',
  require  => [ Package[keys($bld_dependencies)],
                Class['mattermost'],File['/tmp/post_script.sh'] ],
}