#
# == Class: dell::warranty
#
# Install a script to check warranty of a product.
# Used by the fact in this module
#
# See http://gitorious.org/smarmy/check_dell_warranty
#
class dell::warranty (
  $ensure = present,
  $git_remote = 'https://git.gitorious.org/smarmy/check_dell_warranty.git',
) {

  validate_re($ensure, '^(present|absent)$',
  'allowed values are present and absent')

  if $ensure == present and (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

  vcsrepo { "${dell::customplugins}/dell_warranty":
    ensure   => $ensure,
    provider => git,
    source   => $git_remote,
    revision => $dell::check_warranty_revision,
  }

  file { "${dell::customplugins}/dell_warranty/check_dell_warranty.py":
    ensure  => $ensure,
    mode    => '0755',
    require => Vcsrepo[ "${dell::customplugins}/dell_warranty" ],
  }

  $ensure_link = $ensure ? {
    'present' => link,
    default => absent,
  }

  file { '/usr/local/sbin/check_dell_warranty.py':
    ensure  => $ensure_link,
    target  => "${dell::customplugins}/dell_warranty/check_dell_warranty.py",
    require => File[
      "${dell::customplugins}/dell_warranty/check_dell_warranty.py"
    ],
  }

}
