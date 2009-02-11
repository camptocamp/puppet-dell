class dell::openmanage inherits dell::hwtools {

  # le plugin yum qui nous trouve le bon build d'openmanage pour notre
  # système.
  package{"firmware-addon-dell":
    ensure => present,
    require => Yumrepo["dell-omsa-indep"],
  }

  # Ces 2 repos hébergent openmanage, mais dépendent d'un plugin yum qui
  # va le analyser hardware et échoue si le système n'est pas supporté.
  #
  # IMPORTANT: il faut tenir à jour la liste des systèmes supportés dans
  # plugins/facter/isopenmanagesupported.rb
  #
  case $isopenmanagesupported {
    yes: {
      package{["srvadmin-omilcore", "srvadmin-deng", "srvadmin-omauth", "srvadmin-omacore", "srvadmin-odf", "srvadmin-storage", "srvadmin-ipmi", "srvadmin-cm", "srvadmin-hapi", "srvadmin-isvc", "srvadmin-omhip"]:
        ensure => present,
        require => Yumrepo["dell-omsa-specific"],
      }

      service{"dataeng":
        ensure => running,
        require => [Package["srvadmin-deng"], Package["srvadmin-storage"]],
      }
    }

    no: {
      exec{"unsupported openmanage warning":
        command => "echo 'Either you have included included this class on an unsupported machine (you shouldn\'t) or you haven\'t updated the list of supported systems in \$isopenmanagesupported.' && exit 1",
      }
    }
  }

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

