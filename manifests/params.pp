#
# == Class: dell::params
#
# Parameters
# TODO: use parameterized classes
#
class dell::params {

  $omsa_url_base = $dell_omsa_url_base ? {
    ''      => 'http://linux.dell.com/repo/hardware/',
    default => $dell_omsa_url_base,
  }

  $omsa_url_args_indep = $dell_omsa_url_args_indep ? {
    ''      => 'osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver',
    default => $dell_omsa_url_args_indep,
  }

  $omsa_url_args_specific = $dell_omsa_url_args_specific ? {
    ''      => 'osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver',
    default => $dell_omsa_url_args_specific,
  }

  $omsa_version = $dell_omsa_version ? {
    ''      => 'latest',
    default => "OMSA_$dell_omsa_version",
  }

  $customplugins = $dell_customplugins ? {
         '' => '/usr/local/src',
    default => $dell_customplugins,
  }

  $check_warranty_revision = $dell_check_warranty_revision ? {
    ''      => '42d157c57b1247e651021098b278adf14e468805',
    default => $dell_check_warranty_revision,
  }

}
