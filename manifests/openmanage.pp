#
# == Class: dell::openmanage
#
# Install openmanage tools
#
class dell::openmanage (
  $service_ensure = 'running',
) {

  include ::dell::hwtools

  service { 'dataeng':
    ensure    => $service_ensure,
    hasstatus => true,
  }

  file {'/etc/logrotate.d/openmanage':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "# file managed by puppet
/var/log/TTY_*.log {
  missingok
  weekly
  notifempty
  compress
}
",
  }

  file {'/etc/logrotate.d/perc5logs':
    ensure  => absent,
  }

  tidy {'/var/log':
    matches => 'TTY_*.log.*',
    age     => '60d',
    backup  => false,
    recurse => true,
  }

  case $::osfamily {
    'RedHat': {

      # openmanage is a mess to install on redhat, and recent versions
      # don't support older hardware. So puppet will install it if absent,
      # or else leave it unmanaged.
      include ::dell::openmanage::redhat

      augeas { 'disable dell yum plugin once OM is installed':
        changes => [
          'set /files/etc/yum/pluginconf.d/dellsysidplugin.conf/main/enabled 0',
          'set /files/etc/yum/pluginconf.d/dellsysid.conf/main/enabled 0',
        ],
        require => Service['dataeng'],
      }

    }

    'Debian': {
      include ::dell::openmanage::debian
    }

    default: {
      err("Unsupported operatingsystem: ${::osfamily}.")
    }

  }

}
