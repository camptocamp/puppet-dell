class dell (
  $omsa_url_base = $dell::params::omsa_url_base,
  $omsa_url_args_indep = $dell::params::omsa_url_args_indep,
  $omsa_url_args_specific = $dell::params::omsa_url_args_specific,
  $omsa_version = $dell::params::omsa_version,
  $customplugins = $dell::params::customplugins,
  $check_warranty_revision = $dell::params::check_warranty_revision,
) inherits ::dell::params {

  validate_string($omsa_url_base)
  validate_string($omsa_url_args_indep)
  validate_string($omsa_url_args_specific)

  validate_string($omsa_version)

  validate_string($customplugins)
  validate_absolute_path($customplugins)

  validate_string($check_warranty_revision)
}
