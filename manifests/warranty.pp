#
# == Class: dell::warranty
#
# Install Dell API key where the fact can access it
# Used by the fact in this module
#
class dell::warranty (
  $api_key,
) {
  file { '/etc/dell_api_key':
    content => $api_key,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
