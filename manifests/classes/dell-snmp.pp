/*
== Class: dell::snmp

Add a line to snmpd.conf which will publish Dell OMSA's infos through SNMP.

*/
class dell::snmp {

  common::concatfilepart { "dell-omsa":
    file    => "/etc/snmp/snmpd.conf",
    content => "# section managed by puppet

# Allow Systems Management Data Engine SNMP to connect to snmpd using SMUX
smuxpeer .1.3.6.1.4.1.674.10892.1
",
    notify  => [Service["snmpd"], Service["dataeng"]],
  }
}
