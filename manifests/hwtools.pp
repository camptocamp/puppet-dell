#
# == Class: dell::hwtools
#
# Install hardware tools
#
# $dell_repo: use the dell repo for yumrepo, or a already defined one.
#  The yumrepo should have the name 'dell-omsa-indep'
#
class dell::hwtools(
  $dell_repo = true,
) {
  include ::dell

  validate_bool( $dell_repo)

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
      package{['libsmbios', 'smbios-utils-bin', 'firmware-tools']:
        ensure => latest,
      }

      $module_path = get_module_path($module_name)
      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
        ensure  => file,
        content => file("${module_path}/files/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"),
        mode    => '0644',
      }

      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
        ensure  => file,
        content => file("${module_path}/files/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"),
        mode    => '0644',
      }

      if $dell_repo {
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
      }

      # ensure file is managed in case we want to purge /etc/yum.repos.d/
      # http://projects.puppetlabs.com/issues/3152
      file { '/etc/yum.repos.d/dell-omsa-indep.repo':
        ensure  => file,
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
