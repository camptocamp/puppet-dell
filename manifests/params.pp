#
# == Class: dell::params
#
# Parameters
#
class dell::params {

  case $::osfamily {

    'RedHat': {
      case $::operatingsystemmajrelease {
        /^[5|6]$/: {
          $omsa_url_base = 'http://linux.dell.com/repo/hardware/'
          $omsa_url_args_indep = 'osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
          $omsa_url_args_specific = 'osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver'
          $omsa_version = $::productname ? {
            'PowerEdge 1750'    => 'OMSA_6.1',
            'PowerEdge 1850'    => 'OMSA_5.5',
            'PowerEdge 1950'    => 'OMSA_6.1',
            'PowerEdge 2950'    => 'OMSA_6.4',
            'PowerEdge R210 II' => 'OMSA_6.4',
            'PowerEdge R310'    => 'OMSA_6.4',
            'PowerEdge R410'    => 'OMSA_6.4',
            'PowerEdge R510'    => 'OMSA_6.4',
            'PowerEdge R610'    => 'OMSA_6.4',
            'PowerEdge T320'    => '',
            'PowerEdge R620'    => 'OMSA_7.2',
            default             => 'latest',
          }
        }

        default: {
          $omsa_url_base = 'http://linux.dell.com/repo/hardware/'
          $omsa_url_args_indep = 'osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
          $omsa_url_args_specific = 'osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver'
          $omsa_version = $::productname ? {
            default    => 'Linux_Repository_15.04.00',
          }
        } #default

      }
    } # RedHat

    'Debian': {
      $omsa_url_base = $::lsbdistcodename ? {
        'wheezy' => 'http://linux.dell.com/repo/community/debian/',
        default  => 'http://linux.dell.com/repo/community/deb/',
      }

      $smbios_pkg = $::lsbdistcodename ? {
        /lenny|squeeze/ => 'libsmbios-bin',
        default         => 'smbios-utils',
      }

      # lint:ignore:empty_string_assignment
      $omsa_url_args_indep = ''
      $omsa_url_args_specific = ''
      # lint:endignore
      $omsa_version = $::productname ? {
        'PowerEdge 1750'    => 'OMSA_6.1',
        'PowerEdge 1850'    => 'OMSA_5.5',
        'PowerEdge 1950'    => 'OMSA_6.1',
        'PowerEdge 2950'    => 'OMSA_6.4',
        'PowerEdge R210 II' => 'OMSA_6.4',
        'PowerEdge R310'    => 'OMSA_6.4',
        'PowerEdge R410'    => 'OMSA_6.4',
        'PowerEdge R510'    => 'OMSA_6.4',
        'PowerEdge R610'    => 'OMSA_6.4',
        'PowerEdge T320'    => '',
        'PowerEdge R620'    => 'OMSA_7.2',
        default             => 'latest',
      }

    } # Debian

    default:  { fail("Unsupported OS family: ${::osfamily}") }
  }

  $customplugins = '/usr/local/src'

  $check_warranty_revision = '42d157c57b1247e651021098b278adf14e468805'

}
