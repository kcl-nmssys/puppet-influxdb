# Create an InfluxDB user
#
# @param user
#   Name of user to create
# @param password
#   Password of user
# @param is_admin
#   Whether user is an admin

define influxdb::user (
  Pattern[/\A[a-zA-Z0-9_]{2,20}\z/] $username = $title,
  String $password,
  Boolean $is_admin = false,
) {

  if $influxdb::http_https_enabled {
    $influx_cmd = 'influx -ssl'
  } else {
    $influx_cmd = 'influx'
  }

  if $is_admin {
    $admin_str = 'true'
    $admin_privs = ' WITH ALL PRIVILEGES'
  } else {
    $admin_str = 'false'
    $admin_privs = ''
  }

  # TODO: convert to ruby
  exec {
    "Create InfluxDB user ${username}":
      user        => 'root',
      path        => ['/bin', '/usr/bin'],
      environment => ['INFLUX_USERNAME=admin', "INFLUX_PASSWORD=${influxdb::admin_password}"],
      command     => "${influx_cmd} -execute \"CREATE USER ${username} WITH PASSWORD '${password}'${admin_privs}\"",
      unless      => "${influx_cmd} -execute 'SHOW USERS' -format csv | grep '^${username},${admin_str}'";
  }
}
