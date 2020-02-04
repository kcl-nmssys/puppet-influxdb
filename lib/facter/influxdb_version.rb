# Fact: influxdb_version
#
# Purpose: Retrieve influxdb version if installed
#
Facter.add(:influxdb_version) do
  setcode do
    if Facter::Util::Resolution.which('influx')
      influxdb_vers = Facter::Util::Resolution.exec('influx --version')
      %r{^InfluxDB shell version: ([[0-9]\.]+)}.match(influxdb_vers)[1]
    end
  end
end
