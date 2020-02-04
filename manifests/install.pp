# Install class, don't use directly

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
              'id'     => $influxdb::repo_keyid,
              'source' => $influxdb::repo_keyurl,
            },
            before   => Package['influxdb'];
        }
      }

      default: {
        fail('Unsupported operating system.')
      }
    }
  }

  ensure_packages(['influxdb'])

  if ($facts['os']['family'] == 'Debian') {
    ensure_packages(['influxdb-client'], {
      before => Package['influxdb']
    })
  }
}
