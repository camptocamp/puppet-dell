#
# == Class: dell::hwtools
#
# Install hardware tools
#
class dell::hwtools {

  if (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

  include ::dell::params

  # Dans ces paquets, on trouve de quoi flasher et extraires des infos des
  # bios & firmwares.

  case $::osfamily {
    'Debian': {
      package { $::dell::params::smbios_pkg:
        ensure => latest,
      }
    }

    'RedHat': {
      package{['libsmbios', 'smbios-utils', 'firmware-tools']:
        ensure => latest,
      }

      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
        ensure => present,
        source => 'puppet:///modules/dell/etc/pki/rpm-gpg/RPM-GPG-KEY-dell',
        mode   => '0644',
      }

      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
        ensure => present,
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
        ]
      }

      # ensure file is managed in case we want to purge /etc/yum.repos.d/
      # http://projects.puppetlabs.com/issues/3152
      file { '/etc/yum.repos.d/dell-omsa-indep.repo':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        require => Yumrepo['dell-omsa-indep'],
      }

      file { '/etc/yum.repos.d/dell-software-repo.repo':
        ensure => absent,
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }

}
