#
# == Class: dell::collectd
#
# Configures collectd's SNMP plugin for gathering OMSA's data. Actually
# temperature sensors and power usage are collected, if the system supports it.
#
# You will need collectd up and running, which can be done using the
# puppet-collectd module.
#
# Note: some power values actually represent current (Ampers) but are displayed
# as Watts.
#
# Requires:
# - Class['collectd']
#
# Usage:
#   include collectd
#   include dell::openmanage
#   include dell::snmp
#   include dell::collectd
#
class dell::collectd {

  if $::collectd_version { # trick to check which collectd module we are using
    collectd::config::plugin { 'monitor dell snmp':
      plugin   => 'snmp',
      settings => template('dell/collectd.conf'),
      require  => Class['dell::snmp'],
    }
  } else {
    file { '/var/lib/puppet/modules/collectd/plugins/dell.conf':
      content => template(
        'dell/collectd-header.conf',
        'dell/collectd.conf',
        'dell/collectd-footer.conf'
      ),
      mode    => '0644',
      owner   => root,
      group   => 0,
      notify  => Service['collectd'],
      require => Class['dell::snmp'],
    }
  }
}
