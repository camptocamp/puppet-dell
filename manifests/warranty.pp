#
# == Class: dell::warranty
#
# Install a script to check warranty of a product.
# Used by the fact in this module
#
# See http://gitorious.org/smarmy/check_dell_warranty
#
class dell::warranty {

  if (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

  vcsrepo { "${dell::customplugins}/dell_warranty":
    ensure   => present,
    provider => git,
    source   => 'https://git.gitorious.org/smarmy/check_dell_warranty.git',
    revision => $dell::check_warranty_revision,
  }

  file { "${dell::customplugins}/dell_warranty/check_dell_warranty.py":
    ensure  => present,
    mode    => '0755',
    require => Vcsrepo[ "${dell::customplugins}/dell_warranty" ],
  }

  file { '/usr/local/sbin/check_dell_warranty.py':
    ensure  => link,
    target  => "${dell::customplugins}/dell_warranty/check_dell_warranty.py",
    require => File["${dell::customplugins}/dell_warranty/check_dell_warranty.py"],
  }

}
