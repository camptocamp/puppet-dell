#
# == Class: dell::warranty
#
# Install Dell API data where the fact can access it
# Used by the fact in this module
#
class dell::warranty (
  Optional[String] $api_key       = undef,
  Optional[String] $client_id     = undef,
  Optional[String] $client_secret = undef,
  String           $file_mode     = '0600',
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
  if $client_id {
    $sec_client_id = Sensitive($client_id)

    file { '/etc/dell_client_id':
      content => $sec_client_id,
      owner   => 'root',
      group   => 'root',
      mode    => $file_mode,
    }
  }
  if $client_secret {
    $sec_client_secret = Sensitive($client_secret)

    file { '/etc/dell_client_secret':
      content => $sec_client_secret,
      owner   => 'root',
      group   => 'root',
      mode    => $file_mode,
    }
  }
}
