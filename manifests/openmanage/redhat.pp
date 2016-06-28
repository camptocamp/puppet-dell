#
# == Class: dell::openmanage::redhat
#
# Install openmanage tools on RedHat
#
# $dell_repo: use the dell repo for yumrepo, or a already defined one.
#  The yumrepo should have the name 'dell-system-update_dependent'
#
class dell::openmanage::redhat(
  $dell_repo = true,
) {

  if (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

  validate_bool( $dell_repo)

  # On RHEL7 there is an issue with the conflict of packages
  #   libcmpiCppImpl0 vs. tog-pegasus-libs
  # According to https://access.redhat.com/solutions/262203 and
  #   https://bugzilla.redhat.com/show_bug.cgi?id=1068799 the libraries
  #   are conflicting by design and the solution is to choose the right
  #   one. For us it means 'yum erase tog-pegasus-libs'
  #   before installing om5.

  if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
    package { 'tog-pegasus-libs':
      ensure => purged,
      before => Package['srvadmin-base', 'srvadmin-storageservices'],
    }
  }
  package { ['srvadmin-base', 'srvadmin-storageservices']:
    ensure  => present,
    require => Yumrepo['dell-system-update_dependent'],
    before  => Service['dataeng'],
  }

  # This repo hosts openmanage but is dependent from a plugin that is
  # going to analyse the harware and will fail if the system is not supported
  #
  if $dell_repo {
    # http://linux.dell.com/repo/hardware/dsu/
    yumrepo {'dell-system-update_dependent':
      descr      => 'Dell System Update repository - OS dependent',
      mirrorlist => "${dell::omsa_url_base}${dell::omsa_version}/mirrors.cgi?${dell::omsa_url_args_dependent}",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell',
      require    => [
        File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
        ],
    }
  }

  # ensure file is managed in case we want to purge /etc/yum.repos.d/
  # http://projects.puppetlabs.com/issues/3152
  file { '/etc/yum.repos.d/dell-system-update_dependent.repo':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    require => Yumrepo['dell-system-update_dependent'],
  }

  # clean up legacy repo files.
  file { [
    '/etc/yum.repos.d/dell-hardware-auto.repo',
    '/etc/yum.repos.d/dell-hardware-main.repo',
    '/etc/yum.repos.d/dell-omsa-specific.repo',
  ]:
    ensure => absent,
  }

  # Patch for RHEL6.4, waiting for new OMSA release
  # See http://lists.us.dell.com/pipermail/linux-poweredge/2013-March/047794.html
  # This file is a kind a merge between /etc/init.d/ipmi (provided by OpenIPMI)
  # and /etc/init.d/dsm_sa_ipmi (provided by OMSA 7.2)
  case $::operatingsystemrelease {

    '6.4': {
      $module_path = get_module_path($module_name)
      file { '/etc/init.d/dsm_sa_ipmi':
        ensure  => file,
        content => file("${module_path}/files/etc/init.d/dsm_sa_ipmi.${::osfamily}.${::lsbdistrelease}"),
        mode    => '0755',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'initrc_exec_t',
        before  => [ Service['dataeng'] ],
      }
    }

    default: {}

  }

}
