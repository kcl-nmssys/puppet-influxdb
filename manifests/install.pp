class influxdb::install {
  if $::influxdb::manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        yumrepo {
          'InfluxDB':
            baseurl  => "${influxdb::repo_url}/centos/${facts['operatingsystemmajrelease']}/${facts['architecture']}/stable",
            gpgcheck => true,
            gpgkey   => $influxdb::repo_keyurl,
            before   => Package['influxdb'];
        }
      }

      'Debian': {
        $distro = downcase($facts['os']['distro']['id'])
        apt::source {
          'InfluxDB':
            location => "${influxdb::repo_url}/${distro}",
            release  => $facts['os']['distro']['codename'],
            repos    => 'stable',
            key      => {
              'source' => $influxdb::repo_keyurl,
            },
            before   => Package['influxdb'];
        }
      }
    }
  }

  package {
    'influxdb':
      ensure => 'present';
  }
}
