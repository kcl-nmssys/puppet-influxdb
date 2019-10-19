# Main class for influxdb
#
# @param manage_repo
#   Whether to manage yum/apt repo

class influxdb (
  Boolean $manage_repo,
  String $repo_url,
  String $repo_keyurl,
  String $repo_keyid,
  Enum['stopped', 'running'] $service_ensure,
  Enum['true', 'false'] $reporting_disabled,
  Stdlib::IP::Address::Nosubnet $bind_address,
  Integer $bind_port,
  String $meta_dir,
  Enum['true', 'false'] $meta_retention_autocreate,
  Enum['true', 'false'] $meta_logging_enabled,
  String $data_dir,
  String $data_wal_dir,
  Pattern[/\A[0-9]+(h|m|s|ms)\z/] $data_wal_fsync_delay,
  Enum['inmem', 'tsi1'] $data_index_version,
  Enum['true', 'false'] $data_trace_logging_enabled,
  Enum['true', 'false'] $data_query_log_enabled,
  Enum['true', 'false'] $data_validate_keys,
  Pattern[/\A[0-9]+(h|m|s|ms)\z/] $data_cache_max_memory_size,
  Pattern[/\A[0-9]+(h|m|s|ms)\z/] $data_cache_snapshot_memory_size,
  Pattern[/\A[0-9]+(h|m|s|ms)\z/] $data_cache_snapshot_write_cold_duration,
  Pattern[/\A[0-9]+(h|m|s|ms)\z/] $data_compact_full_write_cold_duration,
  Integer $data_max_concurrent_compactions,
) {

  contain ::influxdb::install
  contain ::influxdb::config

  Class['::influxdb::install']
  -> Class['::influxdb::config']
}
