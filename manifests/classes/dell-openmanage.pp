class dell::openmanage {

  include dell::hwtools

  service { "dataeng": }

  # IMPORTANT: il faut tenir à jour la liste des systèmes supportés dans
  # plugins/facter/isopenmanagesupported.rb
  #
  # Voir http://linux.dell.com/repo/hardware/latest
  case $isopenmanagesupported {
    yes: {

      Service["dataeng"] {
        ensure => running,
      }

      file {"/etc/logrotate.d/openmanage":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => "# file managed by puppet
/var/log/TTY_*.log {
  missingok
  weekly
  notifempty
  compress
}
",
      }

      file {"/etc/logrotate.d/perc5logs":
        ensure  => absent,
      }

      tidy {"/var/log":
        matches => "TTY_*.log.*",
        age     => "60d",
        backup  => false,
        recurse => true,
      }

      case $operatingsystem {
        RedHat: {

          # openmanage is a mess to install on redhat, and recent versions
          # don't support older hardware. So puppet will install it if absent,
          # or else leave it unmanaged.
          if $srvadminpkgcount < 10 {
            include dell::openmanage::redhat
          }

          augeas { "disable dell yum plugin once OM is installed":
            changes => [
              "set /files/etc/yum/pluginconf.d/dellsysidplugin.conf/main/enabled 0",
              "set /files/etc/yum/pluginconf.d/dellsysid.conf/main/enabled 0"],
            require => Service["dataeng"],
            notify  => Exec["update yum cache"],
          }

        }

        Debian: {
          include dell::openmanage::debian
        }

        default: {
          err("Unsupported operatingsystem: $operatingsystem.")
        }

      }
    }

    no: {
      exec{"unsupported openmanage warning":
        command => "echo 'Either you have included this class on an unsupported machine (you shouldn\'t) or you haven\'t updated the list of supported systems in \$isopenmanagesupported.' && exit 1",
      }
    }
  }
}

