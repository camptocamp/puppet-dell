/*
== Class: dell::collectd

Configures collectd's SNMP plugin for gathering OMSA's data. Actually
temperature sensors and power usage are collected, if the system supports it.

You will need collectd up and running, which can be done using the
puppet-collectd module.

Note: some power values actually represent current (Ampers) but are displayed
as Watts.

Requires:
- Class['collectd']

Usage:
  include collectd
  include dell::openmanage
  include dell::snmp
  include dell::collectd

*/
class dell::collectd {

  if $::operatingsystem =~ /RedHat|CentOS/ and $::lsbmajdistrelease > '4' {

    if !defined(Package['collectd-snmp']) {
      package { 'collectd-snmp':
        ensure => present,
        before => File['/var/lib/puppet/modules/collectd/plugins/dell.conf'],
      }
    }
  }

  file { '/var/lib/puppet/modules/collectd/plugins/dell.conf':
    content => template('dell/collectd.conf'),
    mode    => '0644',
    owner   => root,
    group   => 0,
    notify  => Service['collectd'],
    require => Class['dell::snmp'],
  }

}
