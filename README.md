# influxdb

[![Puppet Forge](http://img.shields.io/puppetforge/v/kclnmssys/influxdb.svg)](https://forge.puppetlabs.com/kclnmssys/influxdb)
[![Build Status](https://travis-ci.org/kcl-nmssys/puppet-influxdb.svg?branch=master)](https://travis-ci.org/kcl-nmssys/puppet-influxdb)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with influxdb](#setup)
    * [What influxdb affects](#what-influxdb-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with influxdb](#beginning-with-influxdb)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module manages InfluxDB.

## Usage

Install InfluxDB and enable its service using the default options:

```
include influxdb
```

## Reference

Most parameters for `influxdb` come from the config file, e.g. `meta_retention_autocreate` relates to the `retention-autocreate` setting in the `[meta]` section of the config file. Refer to `templates/influxdb.conf.erb` for a description of each. Generally, the default settings have been copied from the original file and are stored in hiera.

There are some exceptions:

 * `manage_repo` - whether to manage the yum/apt repository
 * `manage_ssl_certs` - whether to manage the SSL certs
 * `repo_url` - base of repository URL
 * `repo_keyurl` - URL of repository GPG key
 * `repo_keyid` - fingerprint of repository GPG key
 * `service_ensure` - whether service should be running or stopped
 * `http_https_certificate_path` - path to store https certificate
 * `http_https_certificate_content` - content of https certificate
 * `http_https_private_key_path` - path to store https private key
 * `http_https_private_key_content` - content of https private key

## Limitations

This has been tested using InfluxDB 1.78 which was current as of October 2019. Not all configuration options have been templated.

## Development

Pull requests are accepted on [GitHub](https://github.com/kcl-nmssys/puppet-influxdb).
