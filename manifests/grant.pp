# Grant an InfluxDB user access to a database
#
# @param username
#   Which user to grant access for
# @param database
#   Which database to grant access to
# @param access
#   What level of access to grant
# @param ensure
#   Whether to grant or revoke access

define influxdb::grant (
  Pattern[/\A[a-zA-Z0-9_]{2,20}\z/] $username,
  Pattern[/\A[a-zA-Z0-9_]{2,20}\z/] $database,
  Enum['READ', 'WRITE', 'ALL'] $access,
  Enum['present', 'absent'] $ensure = 'present',
) {

  if $influxdb::http_https_enabled {
    $influx_cmd = 'influx -ssl'
  } else {
    $influx_cmd = 'influx'
  }

  # TODO: convert to ruby
  if $ensure == 'present' {
    exec {
      "Grant InfluxDB user ${username} access to ${database}":
        user        => 'root',
        path        => ['/bin', '/usr/bin'],
        environment => ['INFLUX_USERNAME=admin', "INFLUX_PASSWORD=${influxdb::admin_password}"],
        command     => "${influx_cmd} -execute 'GRANT ${access} ON ${database} TO ${username}'",
        unless      => "${influx_cmd} -execute 'SHOW GRANTS FOR ${username}' -format csv | grep '^${database},${access}'",
        require     => [Package['influxdb'], Service['influxdb']];
    }
  } else {
    exec {
      "Revoke InfluxDB user ${username} access from ${database}":
        user        => 'root',
        path        => ['/bin', '/usr/bin'],
        environment => ['INFLUX_USERNAME=admin', "INFLUX_PASSWORD=${influxdb::admin_password}"],
        command     => "${influx_cmd} -execute 'REVOKE ${access} ON ${database} FROM ${username}'",
        onlyif      => "${influx_cmd} -execute 'SHOW GRANTS FOR ${username}' -format csv | grep '^${database},${access}'",
        require     => [Package['influxdb'], Service['influxdb']];
    }
  }
}
