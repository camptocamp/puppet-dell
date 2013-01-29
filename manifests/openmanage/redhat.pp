#
# == Class: dell::openmanage::redhat
#
# Install openmanage tools on RedHat
#
class dell::openmanage::redhat {

  include dell::params

  # this package contains the yum plugin which find the best yum repository
  # depending on the hardware.
  package{'firmware-addon-dell':
    ensure => latest,
  }

  package { ['srvadmin-base', 'srvadmin-storageservices']:
    ensure  => present,
    require => Yumrepo['dell-omsa-specific'],
    before  => Service['dataeng'],
  }

  # Ce repo héberge openmanage, mais dépendent d'un plugin yum qui
  # va analyser le hardware et échoue si le système n'est pas supporté.
  #
  # http://linux.dell.com/repo/hardware/latest
  yumrepo {'dell-omsa-specific':
    descr      => 'Dell OMSA repository - Hardware specific',
    mirrorlist => "${::dell::params::omsa_url_base}${::dell::params::omsa_version}/mirrors.cgi?${::dell::params::omsa_url_args_specific}",
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
  file { '/etc/yum.repos.d/dell-omsa-specific.repo':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    require => Yumrepo['dell-omsa-specific'],
  }

  # clean up legacy repo files.
  file { [
    '/etc/yum.repos.d/dell-hardware-auto.repo',
    '/etc/yum.repos.d/dell-hardware-main.repo',
  ]:
    ensure => absent,
  }

}
