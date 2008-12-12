class dell::openmanage inherits dell::hwtools {

    # le plugin yum qui nous trouve le bon build d'openmanage pour notre
    # système.
    package{"firmware-addon-dell":
        ensure => present,
        require => Yumrepo["dell-software-repo"],
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
                require => [Yumrepo["dell-hardware-main"], Yumrepo["dell-hardware-auto"]],
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

    # http://linux.dell.com/repo/hardware/
    yumrepo {"dell-hardware-main":
        descr => "Dell unofficial hardware repository - hardware independent repo",
        mirrorlist => "http://linux.dell.com/repo/hardware/mirrors.pl?osname=el\$releasever&basearch=\$basearch&repo_config=\$repo_config&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        includepkgs => "srvadmin-omilcore, srvadmin-deng, srvadmin-omauth, instsvc-drivers, srvadmin-omacore, srvadmin-odf, srvadmin-storage, srvadmin-ipmi, srvadmin-cm, srvadmin-hapi, srvadmin-isvc, srvadmin-omhip, srvadmin-syscheck",
        require => [Package["firmware-addon-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]],
    }

    yumrepo {"dell-hardware-auto":
        descr => "Dell unofficial hardware repository - hardware specific repo",
        mirrorlist => "http://linux.dell.com/repo/hardware/mirrors.pl?sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&osname=el\$releasever&basearch=\$basearch&repo_config=\$repo_config&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        includepkgs => "srvadmin-omilcore, srvadmin-deng, srvadmin-omauth, instsvc-drivers, srvadmin-omacore, srvadmin-odf, srvadmin-storage, srvadmin-ipmi, srvadmin-cm, srvadmin-hapi, srvadmin-isvc, srvadmin-omhip, srvadmin-syscheck",
        require => [Package["firmware-addon-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]],
    }

}

