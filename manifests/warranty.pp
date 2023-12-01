#
# == Class: dell::warranty
#
# Install Dell API key where the fact can access it
# Used by the fact in this module
#
# @param api_key
#
# @param file_mode
#
class dell::warranty (
  Optional[String] $api_key   = undef,
  String           $file_mode = '0644',
) {
  if $api_key {
    $sec_api_key = Sensitive($api_key)

    file { '/etc/dell_api_key':
      content => $sec_api_key,
      owner   => 'root',
      group   => 'root',
      mode    => $file_mode,
    }
  }
}
