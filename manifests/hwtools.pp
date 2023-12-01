#
# == Class: dell::hwtools
#
# Install hardware tools
#
# $dell_repo: use the dell repo for yumrepo, or a already defined one.
#  The yumrepo should have the name 'dell-omsa-indep'
#
# @param dell_repo
#
class dell::hwtools (
  Boolean $dell_repo = true,
) {
  include dell
  include dell::params

  if $dell_repo {
    class { 'dell::hwtools::repo':
      before => Class['dell::hwtools::package'],
    }
  }
  include dell::hwtools::package
}
