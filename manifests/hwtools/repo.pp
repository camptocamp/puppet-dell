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
      ensure => file,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/dell/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios',
      mode   => '0644',
    }

    # http://linux.dell.com/wiki/index.php/Repository/software
    yumrepo {'dell-omsa-indep':
      descr      => 'Dell OMSA repository - Hardware independent',
      mirrorlist => "${dell::omsa_url_base}${dell::omsa_version}/mirrors.cgi?${dell::omsa_url_args_indep}",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
      require    => [
        File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
        File['/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios'],
        ],
    }

    # ensure file is managed in case we want to purge /etc/yum.repos.d/
    # http://projects.puppetlabs.com/issues/3152
    file { '/etc/yum.repos.d/dell-omsa-indep.repo':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Yumrepo['dell-omsa-indep'],
    }
  }
}
