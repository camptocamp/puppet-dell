class dell::hwtools {

    package{["libsmbios", "smbios-utils", "firmware-tools", "firmware-addon-dell"]:
        ensure => present,
        require => Yumrepo["dell-software-repo"],
    }

    package{["srvadmin-omilcore", "srvadmin-deng", "srvadmin-omauth", "instsvc-drivers", "srvadmin-omacore", "srvadmin-odf", "srvadmin-storage", "srvadmin-ipmi", "srvadmin-cm", "srvadmin-hapi", "srvadmin-isvc", "srvadmin-omhip"]:
        ensure => present,
        require => [Yumrepo["dell-hardware-main"], Yumrepo["dell-hardware-auto"]],
        #onlyif => "/usr/sbin/getSystemId > /dev/null",
    }

    # Dans ce repo, on trouve entre autre de quoi flasher bios&firmware ainsi
    # que le plugin yum qui donne accès à openmanage
    # http://linux.dell.com/wiki/index.php/Repository/software
    yumrepo {"dell-software-repo":
        descr => "Unsupported Dell Software",
        mirrorlist => "http://linux.dell.com/repo/software/mirrors.pl?osname=el\$releasever&basearch=\$basearch",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => ["file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell", "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"],
        includepkgs => "libsmbios, smbios-utils, firmware-tools, firmware-addon-dell",
        require => [File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]]
    }

    # Ces 2 repos hébergent openmanage, mais dépendent d'un plugin yum qui
    # va le analyser hardware et échoue si le système n'est pas supporté.
    # http://linux.dell.com/repo/hardware/
    yumrepo {"dell-hardware-main":
        descr => "Dell unofficial hardware repository - hardware independent repo",
        mirrorlist => "http://linux.dell.com/repo/hardware/mirrors.pl?osname=el\$releasever&basearch=\$basearch&repo_config=\$repo_config&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => ["file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell", "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"],
        includepkgs => "srvadmin-omilcore, srvadmin-deng, srvadmin-omauth, instsvc-drivers, srvadmin-omacore, srvadmin-odf, srvadmin-storage, srvadmin-ipmi, srvadmin-cm, srvadmin-hapi, srvadmin-isvc, srvadmin-omhip",
        require => Package["firmware-addon-dell"],
    }

    yumrepo {"dell-hardware-auto":
        descr => "Dell unofficial hardware repository - hardware specific repo",
        mirrorlist => "http://linux.dell.com/repo/hardware/mirrors.pl?sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&osname=el\$releasever&basearch=\$basearch&repo_config=\$repo_config&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => ["file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell", "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"],
        includepkgs => "srvadmin-omilcore, srvadmin-deng, srvadmin-omauth, instsvc-drivers, srvadmin-omacore, srvadmin-odf, srvadmin-storage, srvadmin-ipmi, srvadmin-cm, srvadmin-hapi, srvadmin-isvc, srvadmin-omhip",
        require => Package["firmware-addon-dell"],
    }

    file {"/etc/pki/rpm-gpg/RPM-GPG-KEY-dell":
        ensure => present,
        source => "puppet:///dell/etc/pki/rpm-gpg/RPM-GPG-KEY-dell",
        mode => 644,
    }

    file {"/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios":
        ensure => present,
        source => "puppet:///dell/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        mode => 644,
    }
}
