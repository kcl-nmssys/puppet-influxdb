# Install class, don't use directly

class influxdb::install {
  if $::influxdb::manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        case $facts['os']['name'] {
          'Amazon': {
            $name_os = 'rhel'
            $maj_rel = '7'
          }
          default: {
            $name_os = 'centos'
            $maj_rel = $facts['operatingsystemmajrelease']
          }
        }
        yumrepo {
          'InfluxDB':
            baseurl  => "${influxdb::repo_url}/${name_os}/${maj_rel}/${facts['architecture']}/stable",
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
}

