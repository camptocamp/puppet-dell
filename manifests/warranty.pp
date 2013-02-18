#
# == Class: dell::warranty
#
# Install a script to check warranty of a product.
# Used by the fact in this module
#
# See http://gitorious.org/smarmy/check_dell_warranty
#
class dell::warranty {

  include dell::params

  vcsrepo { "$::dell::params::customplugins/dell_warranty":
    ensure   => present,
    provider => git,
    source   => "https://git.gitorious.org/smarmy/check_dell_warranty.git",
    revision => "$::dell::params::check_warranty_revision",
  }

  file { "$::dell::params::customplugins/dell_warranty/check_dell_warranty.py":
    ensure  => present,
    mode    => 0755,
    require => Vcsrepo[ "$::dell::params::customplugins/dell_warranty" ],
  }

  file { '/usr/local/sbin/check_dell_warranty.py':
    ensure  => link,
    target  => "$::dell::params::customplugins/dell_warranty/check_dell_warranty.py",
    require => File["$::dell::params::customplugins/dell_warranty/check_dell_warranty.py"],
  }

}
