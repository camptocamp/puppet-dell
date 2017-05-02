class dell::hwtools::package {
  case $::osfamily {
    'Debian': {
      package { $::dell::params::smbios_pkg:
        ensure => latest,
      }
    }

    'RedHat': {
      package{['libsmbios', 'smbios-utils-bin']:
        ensure => latest,
      }
    }

    default: {
      fail "Unsupported OS family ${::osfamily}"
    }
  }
}
