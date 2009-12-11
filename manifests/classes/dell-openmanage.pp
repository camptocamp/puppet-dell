class dell::openmanage {

  include dell::hwtools

  # IMPORTANT: il faut tenir à jour la liste des systèmes supportés dans
  # plugins/facter/isopenmanagesupported.rb
  #
  # Voir http://linux.dell.com/repo/hardware/latest
  case $isopenmanagesupported {
    yes: {

      case $operatingsystem {
        RedHat: {

          # openmanage is a mess to install on redhat, and recent versions
          # don't support older hardware. So puppet will install it if absent,
          # or else leave it unmanaged.
          if $srvadminpkgcount < 10 {
            include dell::openmanage::redhat
          }

          augeas { "disable dell yum plugin once OM is installed":
            changes => "set /files/etc/yum/pluginconf.d/dellsysidplugin.conf/main/enabled 0",
            require => Service["dataeng"],
            notify  => Exec["update yum cache"],
          }

          service { "dataeng":
            ensure => running,
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

  # le plugin yum qui nous trouve le bon build d'openmanage pour notre
  # système.
  package{"firmware-addon-dell":
    ensure => latest,
  }

  # workaround broken yum repository
  $url = "http://linux.dell.com/repo/hardware/latest/pe2970/rh${lsbmajdistrelease}0/srvadmin"
  $ver = "6.1.0-648"

  package { "srvadmin-omilcore":
    ensure => present,
    provider => "rpm",
    source => "${url}/srvadmin-omilcore-${ver}.i386.rpm",
    require => [Yumrepo["dell-omsa-specific"], Package["firmware-addon-dell"]],
  }

  package { "srvadmin-deng":
    ensure => present,
    provider => "rpm",
    source => "${url}/srvadmin-deng-${ver}.i386.rpm",
    require => [Package["srvadmin-omilcore"], Package["srvadmin-syscheck"]],
    before  => Service["dataeng"],
  }

  package { "srvadmin-omcommon":
    ensure => present,
    provider => "rpm",
    source => "${url}/srvadmin-omcommon-${ver}.i386.rpm",
    require => [Package["srvadmin-omilcore"], Package["srvadmin-syscheck"]],
  }

  package { ["srvadmin-hapi", "srvadmin-syscheck", "srvadmin-omauth"]:
    ensure => present,
    require => Package["srvadmin-omilcore"],
    before  => Service["dataeng"],
  }

  package { ["srvadmin-storage", "srvadmin-omhip"]:
    ensure => present,
    require => Package["srvadmin-omacore"],
    before  => Service["dataeng"],
  }

  package { "srvadmin-cm":
    ensure => present,
    require => [Package["srvadmin-omacore"], Package["srvadmin-syscheck"]],
  }

  package { "srvadmin-isvc":
    ensure => present,
    require => [Package["srvadmin-hapi"], Package["srvadmin-deng"], Package["srvadmin-syscheck"], Package["srvadmin-omacore"]],
  }

  package { "srvadmin-omacore":
    ensure => present,
    require => [Package["srvadmin-deng"], Package["srvadmin-omilcore"], Package["srvadmin-omcommon"]],
  }

  # Ce repo héberge openmanage, mais dépendent d'un plugin yum qui
  # va analyser le hardware et échoue si le système n'est pas supporté.
  #
  # http://linux.dell.com/repo/hardware/latest
  yumrepo {"dell-omsa-specific":
    descr => "Dell OMSA repository - Hardware specific",
    mirrorlist => "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&dellsysidpluginver=\$dellsysidpluginver",
    enabled => 1,
    gpgcheck => 1,
    gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
    includepkgs => "srvadmin-omilcore, srvadmin-deng, srvadmin-omauth, instsvc-drivers, srvadmin-omacore, srvadmin-odf, srvadmin-storage, srvadmin-ipmi, srvadmin-cm, srvadmin-hapi, srvadmin-isvc, srvadmin-omhip, srvadmin-syscheck",
    require => [Package["firmware-addon-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]],
  }

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
    ensure => present,
    require => [Apt::Key["22D16719"],Exec["apt-get_update"]]
  }
}
