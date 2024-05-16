#
# == Class: dell::params
#
# Parameters
#
class dell::params {
  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['release']['major'] {
        /^[3|4|5]$/: {
          # versions < 6 are unsupported in DSU (and more generally)
          fail("Unsupported RHEL version: ${facts['os']['release']['major']}")
        }

        default: {
          $omsa_url_base = 'http://linux.dell.com/repo/hardware/'
          $omsa_url_args_indep = 'osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
          $omsa_url_args_dependent = 'osname=el$releasever&basearch=$basearch&native=1'
          $omsa_version = $facts['dmi']['product']['name'] ? {
            # TODO : Different OMSA versions for various hardware possibilities
            default    => 'DSU_17.07.00', # latest DSU version at time of writing
          }
        } #default

      }
    } # RedHat

    'Debian': {
      $omsa_url_base = $facts['os']['distro']['codename'] ? {
        'wheezy' => 'http://linux.dell.com/repo/community/debian/',
        default  => 'http://linux.dell.com/repo/community/deb/',
      }

      $smbios_pkg = $facts['os']['distro']['codename'] ? {
        /lenny|squeeze/ => 'libsmbios-bin',
        default         => 'smbios-utils',
      }

      # lint:ignore:empty_string_assignment
      $omsa_url_args_dependent = ''
      # lint:endignore
      $omsa_version = $facts['dmi']['product']['name'] ? {
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

    default:  { fail("Unsupported OS family: ${facts['os']['family']}") }
  }

  $customplugins = '/usr/local/src'

  $manage_debian_apt = true

  $check_warranty_revision = '42d157c57b1247e651021098b278adf14e468805'

}
