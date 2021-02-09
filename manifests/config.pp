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
    if $influxdb::http_https_certificate_content == '' or $influxdb::http_https_private_key_content == '' {
      fail('If you enable https you must provide certificate and key')
    }

    if $facts['os']['family'] == 'Debian' {
      # TODO: convert to ruby
      exec {
        'Add influxdb to ssl-cert group':
          user    => 'root',
          command => 'gpasswd -a influxdb ssl-cert',
          unless  => "id influxdb | grep '(ssl-cert)'",
          path    => ['/bin', '/usr/bin'];
      }
    }

    if $influxdb::manage_ssl_certs {
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
          group     => $influxdb::http_https_private_key_group,
          mode      => '0440',
          content   => $influxdb::http_https_private_key_content,
          show_diff => false,
          notify    => Service['influxdb'];
      }
    }
  }

  influxdb::user {
    'admin':
      password => $influxdb::admin_password,
      is_admin => true;
  }

  if $influxdb::backup_enabled {
    file {
      $influxdb::backup_directory:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0700';
    }

    cron {
      'InfluxDB daily backup':
        ensure  => 'present',
        user    => 'root',
        hour    => $influxdb::daily_backup_hour,
        minute  => $influxdb::daily_backup_minute,
        command => "/usr/bin/influxd backup -portable ${influxdb::backup_directory}";

      'InfluxDB tidy backups':
        ensure  => 'present',
        user    => 'root',
        hour    => $influxdb::daily_tidy_hour,
        minute  => $influxdb::daily_tidy_minute,
        command => "/usr/bin/find ${influxdb::backup_directory} -mtime +${influxdb::backup_keep} -type f -delete";
    }
  } else {
    cron {
      ['InfluxDB daily backup', 'InfluxDB tidy backups']:
        ensure => 'absent',
        user   => 'root';
    }
  }
}
