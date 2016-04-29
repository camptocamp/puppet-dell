#
# == Class: dell::hwtools
#
# Install hardware tools
#
# $dell_repo: use the dell repo for yumrepo, or a already defined one.
#  The yumrepo should have the name 'dell-system-update_independent'
#
class dell::hwtools(
  $dell_repo = true,
) {

  if (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

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
      # removing packages is always producting a line like
      # (/Stage[main]/Dell::Hwtools/Package[smbios-utils-python]/ensure) created
      # into the log. This is a known bug, see
      # https://projects.puppetlabs.com/issues/12722

      # When upgrading from OMSA to DSU on RHEL there are conflicting packages
      # preventing the proper upgrade. To fix it we need to 
      # 'yum erase smbios-utils-python python-smbios'
      package { [ 
        'smbios-utils-python',
        'python-smbios',
      ]:
        ensure => purged,
        before => Package['dell-system-update'],
      }

      package{['dell-system-update']:
        ensure => latest,
	require  => Yumrepo["dell-system-update_independent"],
      }

      $module_path = get_module_path($module_name)
      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
        ensure  => file,
        content => file("${module_path}/files/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"),
        mode    => '0644',
      }

      if $dell_repo {
        # http://linux.dell.com/repo/hardware/dsu/
        yumrepo {'dell-system-update_independent':
          descr      => 'Dell System Update repository - OS independent',
          baseurl    => "${dell::omsa_url_base}${dell::omsa_version}/os_independent/",
          enabled    => 1,
          gpgcheck   => 1,
          gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell",
          require    => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
        }
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
        ensure => absent,
      }

      # old RPM keys are no longer needed
      file {'/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios':
        ensure  => absent,
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }

}
