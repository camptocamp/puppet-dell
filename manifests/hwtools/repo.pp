# Set up repo
class dell::hwtools::repo {
  if $facts['os']['family'] == 'RedHat' {
    # http://linux.dell.com/repo/pgp_pubkeys/0x756ba70b1019ced6.asc
    # http://linux.dell.com/repo/pgp_pubkeys/0x1285491434D8786F.asc
    # http://linux.dell.com/repo/pgp_pubkeys/0xca77951d23b66a9d.asc
    $dell_keys = ['RPM-GPG-KEY-dell', '0x1285491434D8786F.asc', '0x756ba70b1019ced6.asc', '0xca77951d23b66a9d.asc']
    $key_paths = prefix($dell_keys, 'file:///etc/pki/rpm-gpg/')

    # function call with lambda:
    $dell_keys.each |String $dell_key| {
      file {"/etc/pki/rpm-gpg/${dell_key}":
        ensure => file,
        owner  => 'root',
        group  => 'root',
        source => "puppet:///modules/dell/etc/pki/rpm-gpg/${dell_key}",
        mode   => '0644',
      }
    }

    file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
      ensure => absent,
    }

    # http://linux.dell.com/repo/hardware/dsu/
    yumrepo {'dell-system-update_independent':
      descr    => 'Dell OMSA repository - OS independent',
      baseurl  => "${dell::omsa_url_base}${dell::omsa_version}/os_independent",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => join($key_paths, "\n       "),
      require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
    }

    # ensure file is managed in case we want to purge /etc/yum.repos.d/
    # http://projects.puppetlabs.com/issues/3152
    file { '/etc/yum.repos.d/dell-system-update_independent.repo':
      ensure  => file,
      mode    => '0644',
      owner   => 'root',
      require => Yumrepo['dell-system-update_independent'],
    }

    file { [
      '/etc/yum.repos.d/dell-software-repo.repo',
      '/etc/yum.repos.d/dell-omsa-indep.repo',
    ]:
      ensure  => absent,
    }
  }
}
