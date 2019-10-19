# Main class for influxdb
#
# @param manage_repo
#   Whether to manage yum/apt repo

class influxdb (
  Boolean $manage_repo,
) {

  contain ::influxdb::install
  contain ::influxdb::config

  Class['::influxdb::install']
  -> Class['::influxdb::config']
}
