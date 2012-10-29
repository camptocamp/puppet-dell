class dell::openmanage::debian {
  apt::key {"22D16719":
    ensure  => present,
    content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

mQGiBEXMKUERBAC1vCnhoGvg8+CIseA7SHMIfVCpLYtg5YLvFQhVIYLRrcUquEwO
cnEtLhbOS30pIJtuQAKV4FB4qTXj6JAmeAP04Y63IIxi2ANdPHQ2NFnV5n4Heda0
DkcRMInApJhQlWZ47MnLhvpBrL976VXo+LAKRyVfgPOWkR/1f2J2V+HouwCgujdS
3ArveRHTnCvUbJ3nP8HSh1MD/3+GEjo6lAUnDIzqkXdQ/qYfe2Lc1TGDrY7p0W1e
856nsGVABtp/m99IMXOhMIwWEJDffFGW+jMNCA/7YdsSMZtrSTnA1p4muFXIyS2J
0nQIqlrvgxXAu2Ed1dRF52X28aU14BDPwJc1DtQc7etcUCcmaTdXwaTpGFkWC2h8
w7eqBACRKEPAhAgYmN/E7L+Q81qa1+IkJ+Rf6utb40lY9FzFVJ8EEs08RK41Pd5H
d5N/jXHpnS/9HNjZIRgI3QzOPdUH6My3QMa0qvfgvt2qbCk/aQWDA617JvssXqRg
JaOXIhWmAJw32EhhI86ZwxNUJucAFX/BOC2kkHQriBPvrA5KCLQ/QmFzIHZhbiBk
ZXIgVmxpZXMgKFNBUkEgbG9jYWwgZGViaWFuIHJlcG9zaXRvcnkpIDxiYXN2QHNh
cmEubmw+iF4EExECAB4FAkXMKUECGwMGCwkIBwMCAxUCAwMWAgECHgECF4AACgkQ
YYcs2SLRZxk/jgCdGT5zQLxGFRnGArPiajBb1cy/uucAn0cI+iJFH2wOn88F2s/A
o+6u0DDiuQINBEXMKU0QCAD4IB7T5x4AvjiHbRwx28dZI0IWaA8cMqI9boSvbsFK
UgQpZ3pcK10aUIeOj1s86J7Tam43etvvxEPlrEZD5e366dV6RoZgisVrZPppHB8j
V5KxvXsLAr2r5u0erZPF3QgBvXzKzEjo7fw85MsRdXHRHkgTGHJ/heW/oIQ4kXTr
9RqrlPVKqhqunbbO8eBlU5HjAwhSvayf4GCIDjBXMLcsOpYvfPwApfSFgsytP0/9
U+iG8foO3NQzCtvz8+sN5BNTygqKjFEgeiX9YeB/gLhlrn2j/TiAXJ8efojPxeB1
LvyUvZ4IxZXZy3SdM8tk3MC5IUQy7Qaxo3ppflpt0ukXAAMFB/9uEMRoWepRi9jL
SBt150VB4FT18oxMFgF54diUPnJ4hwM+JqoNyHhymIKyLiBMIS8b5W7BsP81DfoP
OdVEvc0LOHvyVnkdZ5921zukYP636/f6BMYiJR2cmi701jzR6Wgpfonj3+Zh+FwQ
maJ2YG3g0ONjMmMo+2ZerWHMoMIWsuOtg7Ngs3cfNHJez68LYYnhfm2ntgdSVoQx
qxniF4izEVq4zrgfLtmdao6Z8Yz7vRTg6S5Qb+Dw1Eev7Yr/ksu3tdX5liHbf4Et
3roB6pV+3j8LsDdcdgQpO4oec4jymNNNxK2r6Bc9ahXBere/HIBri6XNklOsno61
Fe9CK7rViEkEGBECAAkFAkXMKU0CGwwACgkQYYcs2SLRZxkfhACgkY453IigmYZl
49cchbZz+Yt0Zb4AniDRZFJCrbTGXlUVnNK4OeXmK8ee
=Ije3
-----END PGP PUBLIC KEY BLOCK-----',
  }

  $omsa  => "deb ftp://ftp.sara.nl/pub/sara-omsa dell sara\n"
  $omsa6 => "deb ftp://ftp.sara.nl/pub/sara-omsa dell6 sara\n"

  case $lsbdistid {
    Ubuntu: {
      $content = $omsa6
    }
    Debian: {
      $content = $lsbdistcodename ? {
        /lenny|squeeze/ => $omsa6
        default         => $omsa
      }
    }
  }

  apt::sources_list {"dell":
    content => $content
  }

  package {"dellomsa":
    ensure  => present,
    require => [Apt::Key["22D16719"],Exec["apt-get_update"]],
    before  => Service["dataeng"],
  }
}
