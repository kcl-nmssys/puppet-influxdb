# Create an InfluxDB database
#
# @param database
#   Name of database to create

define influxdb::database (
  Pattern[/\A[a-zA-Z0-9_]{2,20}z/] $database = $title,
) {

  if $influxdb::http_https_enabled {
    $influx_cmd = 'influx -ssl'
  } else {
    $influx_cmd = 'influx'
  }

  exec {
    "Create InfluxDB database ${database}":
      user        => 'root',
      path        => ['/bin', '/usr/bin'],
      environment => ['INFLUX_USERNAME=admin', "INFLUX_PASSWORD=${influxdb::admin_password}"],
      command     => "${influx_cmd} -execute \"CREATE DATABASE ${database}",
      unless      => "${influx_cmd} -execute 'SHOW DATABASES' -format csv | grep 'databases,${database}\$'";
  }
}
