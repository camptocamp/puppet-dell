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

  if $dell_repo {
    class { '::dell::hwtools::repo':
      before => Class['dell::hwtools::package'],
    }
  }

  include ::dell::hwtools::package

  if $::osfamily == 'RedHat' {
    file { '/etc/yum.repos.d/dell-software-repo.repo':
      ensure => absent,
    }
  }
}
