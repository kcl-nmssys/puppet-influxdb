class influxdb::config (

) {

  service {
    'influxdb':
      ensure => $influxdb::service_ensure;
  }

  if $influxdb::service_ensure == 'running' {
    Service['influxdb'] {
      enable => true
    }
  } else {
    Service['influxdb'] {
      enable => false
    }
  }

  file {
    '/etc/influxdb/influxdb.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'influxdb',
      mode    => '0640',
      content => template('influxdb/influxdb.conf.erb'),
      notify  => Service['influxdb'];
  }
}
