class influxdb::install (
  String $repo_url,
  String $repo_keyurl,
) {
  if $::influxdb::manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        yumrepo {
          'InfluxDB':
            baseurl  => "${repo_url}/centos/${facts['operatingsystemmajrelease']}/${facts['architecture']}/stable",
            gpgcheck => true,
            gpgkey   => $repo_keyurl,
            before   => Package['influxdb'];
        }
      }

      'Debian': {
        $distro = downcase($facts['os']['distro']['id'])
        apt::source {
          'InfluxDB':
            location => "${repo_url}/${distro}",
            release  => $facts['os']['distro']['codename'],
            repos    => 'stable',
            key      => {
              'source' => $repo_keyurl,
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
