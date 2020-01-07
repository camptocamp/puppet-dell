Dell Puppet module
==================

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/dell.svg)](https://forge.puppetlabs.com/camptocamp/dell)
[![Build Status](https://travis-ci.org/camptocamp/puppet-dell.png?branch=master)](https://travis-ci.org/camptocamp/puppet-dell)

Overview
--------

This module deploys various tools and configurations for Dell servers. It also provides custom facts related to Dell servers.

API
---

The warranty facts have been updated to use Dell's v5 API. You will need to obtain a client ID and secret from
[TechDirect](https://techdirect.dell.com/certification/AboutAPIs.aspx) and pass it in via the
`client_id` and `client_secret` parameters.
Failure to specify the key will not prevent you from using the module but will return bogus warranty facts. Example:

```puppet
class { 'dell':
  client_id     => 'your_id_goes_here',
  client_secret => 'your_secret_goes_here',
}
```
