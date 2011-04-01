class dell::params {

  $omsa_version = $dell_omsa_version ? {
    ""      => "6.4",
    default => $dell_omsa_version,
  }

}
