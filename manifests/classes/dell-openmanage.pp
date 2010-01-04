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

class dell::openmanage::redhat {

  $ver = "6.1"

  # this package contains the yum plugin which find the best yum repository
  # depending on the hardware.
  package{"firmware-addon-dell":
    ensure => latest,
  }

  package { ["srvadmin-base", "srvadmin-storageservices"]:
    ensure  => present,
    require => Yumrepo["dell-omsa-specific"],
    before  => Service["dataeng"],
  }

  # Ce repo héberge openmanage, mais dépendent d'un plugin yum qui
  # va analyser le hardware et échoue si le système n'est pas supporté.
  #
  # http://linux.dell.com/repo/hardware/latest
  yumrepo {"dell-omsa-specific":
    descr => "Dell OMSA repository - Hardware specific",
    mirrorlist => "http://linux.dell.com/repo/hardware/OMSA_${ver}/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&dellsysidpluginver=\$dellsysidpluginver",
    enabled => 1,
    gpgcheck => 1,
    gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
    require => [Package["firmware-addon-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]],
  }

  # clean up legacy repo files.
  file { ["/etc/yum.repos.d/dell-hardware-auto.repo", "/etc/yum.repos.d/dell-hardware-main.repo"]:
    ensure => absent,
  }

}

class dell::openmanage::debian {
  apt::key {"22D16719":
    ensure => present,
    source => "ftp://ftp.sara.nl/debian_sara.asc",
  }

  apt::sources_list {"dell":
    content => $lsbdistcodename ? {
      lenny   => "deb ftp://ftp.sara.nl/pub/sara-omsa dell6 sara\n",
      default =>"deb ftp://ftp.sara.nl/pub/sara-omsa dell sara\n"
    },
  }

  package {"dellomsa":
    ensure  => present,
    require => [Apt::Key["22D16719"],Exec["apt-get_update"]],
    before  => Service["dataeng"],
  }
}
