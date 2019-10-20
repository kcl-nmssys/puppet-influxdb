# Config class, don't use directly

class influxdb::config {

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
      mode    => '0440',
      content => template('influxdb/influxdb.conf.erb'),
      notify  => Service['influxdb'];
  }

  if $influxdb::http_https_enabled {
    file {
      $influxdb::http_https_certificate_path:
        ensure  => 'present',
        owner   => 'root',
        group   => 'influxdb',
        mode    => '0444',
        content => $influxdb::http_https_certificate_content,
        notify  => Service['influxdb'];

      $influxdb::http_https_private_key_path:
        ensure    => 'present',
        owner     => 'root',
        group     => 'influxdb',
        mode      => '0440',
        content   => $influxdb::http_https_private_key_content,
        show_diff => false,
        notify    => Service['influxdb'];
    }
  }
}
