#
# == Class: dell::snmp
#
# Add a line to snmpd.conf which will publish Dell OMSA's infos through SNMP.
#
class dell::snmp {

  concat::fragment {'dell-omsa':
    target  => '/etc/snmp/snmpd.conf',
    content => "# section managed by puppet

# Allow Systems Management Data Engine SNMP to connect to snmpd using SMUX
smuxpeer .1.3.6.1.4.1.674.10892.1
",
    notify  => Service['dataeng'],
  }

  case $::operatingsystem {
    'Debian' : {
      augeas {'snmpd enable smux':
        context => '/files/etc/default/snmpd/',
        changes => "set SNMPDOPTS '\"-Lsd -u snmp -I smux -p /var/run/snmpd.pid -Lf /dev/null 127.0.0.1\"'",
        notify  => Service['snmpd'],
      }

      exec {'activate omsa snmp':
        command => '/etc/init.d/dataeng enablesnmp',
        unless  => '/etc/init.d/dataeng getsnmpstatus | grep -qi enabled',
        notify  => Service['dataeng'],
      }
    }
    default: {}
  }
}
