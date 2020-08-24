# Create an InfluxDB database
#
# @param database
#   Name of database to create

define influxdb::database (
  Pattern[/\A[a-zA-Z0-9_]{2,20}\z/] $database = $title,
) {

  # TODO: convert to ruby
  exec {
    "Create InfluxDB database ${database}":
      user        => 'root',
      path        => ['/bin', '/usr/bin'],
      environment => ['INFLUX_USERNAME=admin', "INFLUX_PASSWORD=${influxdb::admin_password}"],
      command     => "${influxdb::influx_cmd} -execute 'CREATE DATABASE ${database}'",
      unless      => "${influxdb::influx_cmd} -execute 'SHOW DATABASES' -format csv | grep 'databases,${database}\$'",
      require     => [Package['influxdb'], Service['influxdb']];
  }
}
