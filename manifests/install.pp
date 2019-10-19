class influxdb::install {
  if $::influxdb::manage_repo {
    case $facts['os']['family'] {
      'RedHat': {
        yumrepo {
          'InfluxDB':
            baseurl  => "https://repos.influxdata.com/centos/${facts['operatingsystemmajrelease']}/${facts['architecture']}/stable",
            gpgcheck => true,
            gpgkey   => 'https://repos.influxdata.com/influxdb.key',
            before   => Package['influxdb'];
        }
      }

      'Debian': {
        $distro = downcase($facts['os']['distro']['id'])
        apt::source {
          'InfluxDB':
            location => "https://repos.influxdata.com/${distro}",
            release  => $facts['os']['distro']['codename'],
            repos    => 'stable',
            key      => {
              'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
              'server' => 'pgp.mit.edu',
            },
            before   => Package['influxdb'];
        }
      }
    }

    package {
      'influxdb':
        ensure => 'present';
    }
  }
}
