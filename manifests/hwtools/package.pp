class dell::hwtools::package {
  case $::osfamily {
    'Debian': {
      package { $::dell::params::smbios_pkg:
        ensure => latest,
      }
    }

    'RedHat': {
      #package{['libsmbios', 'smbios-utils-bin']:
      #  ensure => latest,
      #}

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
        ensure  => latest,
	require => Yumrepo["dell-system-update_independent"],
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }
}
