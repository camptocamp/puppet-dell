## 2016-09-15 - Release 0.5.1

- Use smbios-utils instead of libsmbios-bin for wheezy

## 2016-08-23 - Release 0.5.0

- Fix US-ASCII encoding issue due to french accents in comments (GH #56)
- Fix wheeze typo to wheezy (GH #64)
- Update skeleton with modulesync
- Require dell in dell::openmanage
- Require ::dell in dell::hwtools
- Fix apt module deprecated parameters
- Fix ordering of sources.list/packages
- Do not attempt to start dataeng in the tests
- Use libsmbios-bin instead of smbios-utils for squeeze and wheezy
- Remove support for Ubuntu 12.04
- Install epel repository for acceptance tests (GH #65)
- Add OSMA_7.2 for Debian (fix #61)
- Fix ordering of dell::hwtools (GH #36)
- Set owner and group of files
- Allow acceptance tests failures

## 2016-06-20 - Release 0.4.1

- Update skeleton with modulesync

## 2016-02-18 - Release 0.4.0

- Use full apt fingerprints (issue #55)
- Add acceptance tests
- Add RedHat 7 support
- Add Debian 8 support
- Remove Ubuntu 10.04 support
- Cleanup metadata.json
- Add unit tests
- Don't use lsb facts for RedHat
- Include apt class in dell::openmanage::debian
- Use forge for fixtures

## 2015-09-01 - Release 0.3.1

- Update API key

## 2015-08-31 - Release 0.3.0

- Fix is_virtual confinement on facts
- Add support for wheezy and jessie in openmanage
- Add $git_remote parameter to dell::warranty
- Use rspec-puppet-facts in specs

## 2015-08-21 - Release 0.2.13

Use docker for acceptance tests

## 2015-07-07 - Release 0.2.12

Add new repository from Dell, needed for RHEL7.

## 2015-07-01 - Release 0.2.11

Use long fingerprint instead of short fingerprint

## 2015-06-26 - Release 0.2.10

Fix strict_variables activation with rspec-puppet 2.2

## 2015-05-28 - Release 0.2.9

Add beaker_spec_helper to Gemfile

## 2015-05-26 - Release 0.2.8

Use random application order in nodeset

## 2015-05-26 - Release 0.2.7

add utopic & vivid nodesets

## 2015-05-25 - Release 0.2.6

Don't allow failure on Puppet 4

## 2015-05-13 - Release 0.2.5

Add puppet-lint-file_source_rights-check gem

## 2015-05-12 - Release 0.2.4

Don't pin beaker

## 2015-04-27 - Release 0.2.3

Add nodeset ubuntu-12.04-x86_64-openstack

## 2015-04-15 - Release 0.2.2

- Use file() function instead of fileserver (way faster)

## 2015-04-03 - Release 0.2.1

- Confine rspec pinning to ruby 1.8

## 2015-03-24 - Release 0.2.0

- Add dell_repo param to dell::hwtools and dell::openmanage::redhat
- Lint
- Future parser fixes

## 2015-01-08 - Release 0.1.17

- Fix unquoted strings in cases

## 2015-01-05 - Release 0.1.16

Fix License

## 2014-12-18 - Release 0.1.15

Various improvements in unit tests

## 2014-12-18 - Release 0.1.13

  Modulesync

## 2014-12-18 - Release 0.1.12

  Modulesync

## 2014-12-18 - Release 0.1.11

  Modulesync

## 2014-12-08 - Release 0.1.1

Lint module

## 2014-12-08 - Release 0.1.0

Initial release on forge
