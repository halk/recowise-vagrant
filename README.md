[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/halk/recowise-vagrant/blob/master/LICENSE)

# Vagrant provisioning for RecoWise

This repository provides a [Vagrant](https://www.vagrantup.com/) environment to run and demo [RecoWise](https://github.com/halk/recowise) - an integration framework for recommenders.

This work is part of my Master of Science [project](https://github.com/halk/msc-project-report).

## Provisioning

Provisioning is done by [Puppet](https://puppetlabs.com/) and supports both [VMWare](http://www.vmware.com) and [VirtualBox](https://www.virtualbox.org). Since provisioning the Magento2 demo including sample data is unreliable and taking too long, a ready-to-go Vagrant box is provided on [Atlas](https://atlas.hashicorp.com/halk/boxes/recowise) for VirtualBox and VMWare. The box itself is derived from [PuppetLabs](https://puppetlabs.com/)' Ubuntu 14.04 [base box](https://atlas.hashicorp.com/puppetlabs/boxes/ubuntu-14.04-64-puppet).

The puppet recipes largely rely on PuppetForge. The recipes for [Magento2](https://github.com/magento/magento2), [Neo4j](http://neo4j.com) and [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh) and as well as the projects mentioned below are self-written.

## Included Projects

- [RecoWise](https://github.com/halk/recowise) - a multi-purpose recommendation framework
- [In Common](https://github.com/halk/in-common) - a data-agnostic, graph-based collaborative recommendation engine written in Go
- [Item Similarity](https://github.com/halk/item-similarity) - a content-based, schema-less recommendation service
- [Magento2 Demo for RecoWise](https://github.com/halk/recowise-magento2-demo) - a sample integration of RecoWise for Magento2

## Usage

### Prerequisites

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org) or [VMWare Fusion](http://www.vmware.com/products/fusion) or [VMWare Workstation](http://www.vmware.com/products/workstation)
- [Git](https://git-scm.com/)
- Shell (e.g. PowerShell for Windows)

### Installation

```bash
# change to a directory of your choice (e.g. $HOME/src)
$ git clone --recursive https://github.com/halk/recowise-vagrant.git
$ cd recowise-vagrant
$ vagrant up
```
