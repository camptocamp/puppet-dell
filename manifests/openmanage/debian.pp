#
# == Class: dell::openmanage::debian
#
# Install openmanage tools on Debian
#
class dell::openmanage::debian {

  include ::apt

  if (!defined(Class['dell'])) {
    fail 'You need to declare class dell'
  }

  # key of:
  # http://linux.dell.com/repo/community/deb/OMSA_7.0/ (same for 7.1)
  # necessary for 6.5
  $key_omsa7 = $dell::omsa_version ? {
    'OMSA_6.5' => 'present',
    'OMSA_7.0' => 'present',
    'OMSA_7.1' => 'present',
    'OMSA_7.2' => 'present',
    'latest'   => 'present',
    ''         => 'present',
    default    => 'absent',
  }

  # key of:
  # http://linux.dell.com/repo/community/deb/OMSA_6.5/
  $key_omsa6 = $dell::omsa_version ? {
    'OMSA_6.5' => 'present',
    default    => 'absent',
  }

  apt::key {'4A801EC6AFCAF6474226759861872CD922D16719':
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

  apt::key {'87C508DB69454A0101A9B852E74433E25E3D7775':
    ensure  => $key_omsa6,
    content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mQGiBELSl68RBACDhWn3X8Ls6mvdpgmPaDqSMVH2GjfWp7Zwto21cFCa8uBDvCSv
bzta922bBDYny1rJNBWOlniI4VaMLPkvUzznYm2rf/f+fuTC6FTQd4yi7VP8X8vp
V7BKlQDMln3CuZcI1ajFMS1pp1551IRkcskZ6sGgWv5BHjyNWxbp481+2wCglK21
+zR5H34O2kShFGLJxBWp8x0D/2rFQk8JIAIyY7ikkBDtPBGfJHGOwych4fVJJnVq
Fz9JqHAYZ3P+WO3sMG5nHkhx8IekOGk+TGbdfYwuGBCuFDkY8UY9fyC+NIGBHF3z
mKpWpBu5mwATLeZhYbEhnItxZ7yq8w59LHCeZBbwwfG/6KKaxhgCoK1toSi+1lHL
ItRQA/43mWKyVW6fZkmDZcOfRRIOjfKCbk8g+3P2msPkBtsZtbA7ANMk7MgPFBur
JHcCjUekOfR4TN/xQ0sl85kec8hIW3ygCyvc3bO8IsdOMOJO40MoYfNI9nFuWqg2
rL63TrnyMw4/uzV5bNwAZUopXftD+dPuQ6+8Y/l6b7X6po6V5LRfbGlic21iaW9z
IChUaGlzIGtleSBpcyB1c2VkIHRvIHNpZ24gYWxsIGxpYnNtYmlvcyB0YXJiYWxs
cykgPGxpYnNtYmlvcy1kZXZlbEBsaXN0cy51cy5kZWxsLmNvbT6IRgQTEQIABgUC
QtKbrAAKCRAhq+73kvD8Cee1AJ9OWTcp1m9PDpWWbYVchN9HapkdQACeIXp03IdH
MyyNjUAmCkIKNQd4hmWIRgQTEQIABgUCQtKb8QAKCRDKd5UdI7ZqnSX6AJ44cDQr
niqdq8YP2z4/7Rw81+TB6wCcC+FktNeZA3jyqqrD//pL7s0Yh3yISQQQEQIACQUC
Rk56GgIHAAAKCRBydbwZ0AUP5XnUAJ9KgT0Habbqyu/5s2Go7IOvDq97PACfbeP8
NILIPiNW6wNfclnfqHRmXt6IWwQTEQIAGwUCQtKXrwYLCQgHAwIDFQIDAxYCAQIe
AQIXgAAKCRDnRDPiXj13dU3RAJ9CgkwbJ/SUDoHZT6RP55iFuszt6wCfYVTyntyO
/1NGnKxo33m2WXq+WRmIWwQTEQIAGwUCQtKXrwYLCQgHAwIDFQIDAxYCAQIeAQIX
gAAKCRDnRDPiXj13dU3RAJ9SG7Rmvp55cLNSQf3Lwd50JCfTrACeK9KRrobo5ouU
byv9nmK9LF3mRpe5AQ0EQtKXsBAEAKQL5zlThVPRuBs6yQ4TYPIx7cY+Fnw/xp0F
/ltLgWuldmejeMbgkMrUS9d6JzNVfuSBtZCNZz+rYKOm0wTBgqef/1xe1jJv7ML4
7eh2gXvSiwTctvfwOMuL6rFisruq/hCQdFofLK4oovfn5B06Q8b66CDytwRRfzQO
7Ohe6EAbAAMFBACd5c0GvGe6o2/iNbs9fNNXSc0SK7Yrax1thgLRNMZPPis+csmd
McgmygbICaiFUI0lgUtq5hGVnahd9fCsYME0uH5cPRfAPWQgukLKyKu3qjCQJ8Cn
D2uwIMvPfiwk4qKWt/fNwYaMx+xs6PKbb7pj9euvC+K4aXVmc3h1YtzKnYhGBBgR
AgAGBQJC0pewAAoJEOdEM+JePXd1yeoAn3DKaapBZNXQ/iPKwaaC9jkfzAANAJ0X
QanLpjDk1ri9fzZiUU+cSuIl3A==
=uvK/
-----END PGP PUBLIC KEY BLOCK-----',
  }

  apt::key {'42550ABD1E80D7C1BC0BAD851285491434D8786F':
    ensure  => $key_omsa7,
    content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

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
SNnmxzdpR6pYJGbEDdFyZFe5xHRWSlrC3WTbzg==
=WBHf
-----END PGP PUBLIC KEY BLOCK-----',
  }

  $omsa_pkg_name = $::lsbdistcodename ? {
    'lenny'   => 'dellomsa',
    'squeeze' => [ 'srvadmin-base', 'srvadmin-storageservices' ],
    default   => [
      'srvadmin-base',
      'srvadmin-storageservices',
      'srvadmin-omcommon' ],
  }

  case $::lsbdistcodename {
    'lenny': {
      apt::source{'dell':
        location => 'ftp://ftp.sara.nl/pub/sara-omsa',
        release  => 'dell6',
        repos    => 'sara',
        include  => {
          src       => false,
        },
      }
    }
    'squeeze': {
      apt::source{'dell':
        location => "${dell::omsa_url_base}${dell::omsa_version}",
        release  => '/',
        repos    => '',
        include  => {
          src       => false,
        },
      }
    }
    'wheezy': {
      apt::source{'dell':
        location => 'http://linux.dell.com/repo/community/debian',
        release  => 'wheezy',
        repos    => 'openmanage',
        include  => {
          src       => false,
        },
      }
    }
    'jessie': {
      apt::source{'dell':
        location => 'http://linux.dell.com/repo/community/debian',
        release  => 'wheezy',
        repos    => 'openmanage',
        include  => {
          src       => false,
        },
      }
    }
    'xenial': {
      fail('Ubuntu 16.04 is not supported by Dell')
    }
    default: {
      apt::source{'dell':
        location => 'http://linux.dell.com/repo/community/debian',
        release  => $::lsbdistcodename,
        repos    => 'openmanage',
        include  => {
          src       => false,
        },
      }
    }
  }

  package { $omsa_pkg_name:
    ensure  => present,
    require => Class['apt::update'],
    before  => Service['dataeng'],
  }

  Apt::Key['42550ABD1E80D7C1BC0BAD851285491434D8786F'] -> Apt::Source['dell']

}
