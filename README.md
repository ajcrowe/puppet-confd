# Puppet Confd

[![Build Status](https://travis-ci.org/ajcrowe/puppet-confd.png?branch=master)](https://travis-ci.org/ajcrowe/puppet-confd)


1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with confd](#setup)
    * [What confd affects](#what-confd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with confd](#beginning-with-confd)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module allow you to manage your [confd](https://github.com/kelseyhightower/confd) templates and resources in Puppet. All configuration options are available and can be defined in Hiera

This module will install, configure and manage your resources and templates.

##Setup

Once you have this module installed you'll need a site module to store your templates and ssl certficates (if you're using them).

It should have the following structure:

To finish...