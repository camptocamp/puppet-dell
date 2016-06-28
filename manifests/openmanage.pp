#
# == Class: dell::openmanage
#
# Install openmanage tools
#
class dell::openmanage {

  include ::dell::hwtools

  service { 'dataeng':
    ensure    => running,
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

      # disable loading psrvil library to avoid crash of dataeng/dsm_sa_datamgrd
      # on OM 8.3, for details see
      # https://www.mail-archive.com/search?l=linux-poweredge@dell.com&q=subject:%22\[Linux\-PowerEdge\]+srvadmin+8.3.0+problems+with+dsm_sa_datamgrd%22&o=newest&f=1
      file_line{"comment-vil7":
        path    => '/opt/dell/srvadmin/etc/srvadmin-storage/stsvc.ini',
        line    => "; vil7=dsm_sm_psrvil",
        match   => "vil7=dsm_sm_psrvil",
        before  => Service["dataeng"],
        notify  => Service["dataeng"],
        require => Package["srvadmin-storageservices"],
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
