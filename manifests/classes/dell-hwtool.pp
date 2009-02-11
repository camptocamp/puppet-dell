class dell::hwtools {

    # Dans ces paquets, on trouve de quoi flasher et extraires des infos des
    # bios & firmwares.
    package{["libsmbios", "smbios-utils", "firmware-tools"]:
        ensure => latest,
        require => Yumrepo["dell-omsa-indep"],
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

    # http://linux.dell.com/wiki/index.php/Repository/software
    yumrepo {"dell-omsa-indep":
        descr => "Dell OMSA repository - Hardware independent",
        mirrorlist => "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        includepkgs => "libsmbios, smbios-utils, firmware-tools, firmware-addon-dell",
        require => [File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]]
    }

    file { "/etc/yum.repos.d/dell-software-repo.repo":
        ensure => absent,
    }

}
