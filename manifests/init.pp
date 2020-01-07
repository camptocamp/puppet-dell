# Base class
class dell (
  String               $omsa_url_base           = $dell::params::omsa_url_base,
  String               $omsa_url_args_dependent = $dell::params::omsa_url_args_dependent,
  String               $omsa_version            = $dell::params::omsa_version,
  Stdlib::Absolutepath $customplugins           = $dell::params::customplugins,
  String               $check_warranty_revision = $dell::params::check_warranty_revision,
  Boolean              $manage_debian_apt       = $dell::params::manage_debian_apt,
  Optional[String]     $client_id               = undef,
  Optional[String]     $client_secret           = undef,
) inherits ::dell::params {
  class { '::dell::warranty':
    client_id     => $client_id,
    client_secret => $client_secret,
  }
}
