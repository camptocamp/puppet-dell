Dell Puppet module
==================

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/dell.svg)](https://forge.puppetlabs.com/camptocamp/dell)
[![Build Status](https://travis-ci.org/camptocamp/puppet-dell.png?branch=master)](https://travis-ci.org/camptocamp/puppet-dell)

Overview
--------

This module deploys various tools and configurations for Dell servers. It also provides custom facts related to Dell servers.

API
---

The warranty facts have been updated to use Dell's v4 API. You will need to obtain an API key from
[TechDirect](https://techdirect.dell.com/certification/AboutAPIs.aspx) and include it in a file
`/etc/dell_api_key`.
