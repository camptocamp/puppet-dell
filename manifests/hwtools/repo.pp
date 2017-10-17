class dell::hwtools::repo {
  if $::osfamily == 'RedHat' {
    file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/dell/etc/pki/rpm-gpg/RPM-GPG-KEY-dell',
      mode   => '0644',
    }

    file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
      ensure => absent,
    }

    # http://linux.dell.com/repo/hardware/dsu/
    yumrepo {'dell-system-update_independent':
      descr      => 'Dell OMSA repository - OS independent',
      baseurl    => "${dell::omsa_url_base}${dell::omsa_version}/os_independent",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell",
      require    => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
    }

    file { [
      '/etc/yum.repos.d/dell-software-repo.repo',
      '/etc/yum.repos.d/dell-omsa-indep.repo',
    ]:
      ensure  => absent,
    }
  }
}
