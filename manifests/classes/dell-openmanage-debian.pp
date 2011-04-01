class dell::openmanage::debian {
  apt::key {"22D16719":
    ensure => present,
    source => "ftp://ftp.sara.nl/debian_sara.asc",
  }

  apt::sources_list {"dell":
    content => $lsbdistcodename ? {
      lenny   => "deb ftp://ftp.sara.nl/pub/sara-omsa dell6 sara\n",
      default =>"deb ftp://ftp.sara.nl/pub/sara-omsa dell sara\n"
    },
  }

  package {"dellomsa":
    ensure  => present,
    require => [Apt::Key["22D16719"],Exec["apt-get_update"]],
    before  => Service["dataeng"],
  }
}
