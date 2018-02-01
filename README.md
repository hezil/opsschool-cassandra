# Vagrant Cassandra

This project contains templates for learning how to install and configure [Apache Cassandra](https://cassandra.apache.org/) on a local dev machine. It uses [Vagrant](http://www.vagrantup.com/) to configure and run virtual machines (VMs) running in [VirtualBox](https://www.virtualbox.org/). Vagrant enables quickly building environments in a way that is repeatable and isolated from your host system. This makes it perfect for experimenting with different configurations of Cassandra and DSE.

## Related Projects

Here are a few related projects I learned from while assembling my Vagrant setup:

* [bcantoni/vagrant-cassandra](https://github.com/bcantoni/vagrant-cassandra) - runs old bassandra versions
* [calebgroom/vagrant-cassandra](https://github.com/calebgroom/vagrant-cassandra) - uses Chef to quickly create a 3-node cluster
* [dholbrook/vagrant-cassandra](https://github.com/dholbrook/vagrant-cassandra) - another Chef
* [oeelvik/vagrant-puppet-hadoop-datastax](https://github.com/oeelvik/vagrant-puppet-hadoop-datastax) - using Puppet for provisioning
* [cjohannsen81/dse-vagrant](https://github.com/cjohannsen81/dse-vagrant) - similar to my approach, just using script provisioning

You may also find [bcantoni/vagrant-deb-proxy](https://github.com/bcantoni/vagrant-deb-proxy) helpful for speeding up Ubuntu package installs. See Package Caching below for details.

## Installation

Note: These scripts were created on a Mac OS X 10.9/10.10/10.11 host with Vagrant v1.6/1.7 and VirtualBox v4.3/5.0. Everything should work for Linux or Windows hosts as well, but I have not tested those platforms. Shell scripts which are meant to run on the host (like up-parallel.sh or down.sh) would need to have Windows equivalents created.


1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant](https://www.vagrantup.com/downloads.html)
1. Check that both are installed and reachable from a command line:

        $ vagrant --version
        Vagrant 1.9.2
        $ VBoxManage --version
        5.0.0r101573

1. Clone this repository

        $ git clone https://github.com/ops-school/opsschool-cassandra.git
        $ cd vagrant-cassandra

1. Try each of the templates listed below, for example:

        $ cd 1.Base
        $ vagrant up
        $ vagrant ssh

## Package Caching

These Vagrant files are configured to use a Debian/Ubuntu APT cache if configured. This can make the provisioning step faster and less susceptible to Ubuntu repository connection speeds.

To enable package caching, set the `DEB_CACHE_HOST` environment variable before creating the Vagrant VMs, for example:

    $ export DEB_CACHE_HOST="http://10.211.54.100:8000"
    $ vagrant up

## Using Vagrant

The [Vagrant documentation](https://docs.vagrantup.com/v2/) is very good and I recommend going through the Getting Started section.

These are the most common commands you'll need with this project:

* `vagrant up` - Create and configure VM
* `vagrant ssh` - SSH into the VM
* `vagrant halt` - Halt the VM (power off)
* `vagrant suspend` - Suspend the VM (save state)
* `vagrant provision` - Run (or re-run) the provisioner script
* `vagrant destroy` - Destroy the VM

## Templates

These are the starting templates which go through increasing levels of complexity for a Cassandra installation. Each of these is located in its own subdirectory with its own `Vagrantfile` (the definition file used by Vagrant) and a README with instructions and more details.

### [1. Base](1.Base)

This is a base template with only Java pre-installed. It's a good getting started point to explore installing Cassandra and DataStax packages.

### [2. MultiNode](2.MultiNode)

This template creates 4 VMs: one for OpsCenter and 3 for Cassandra nodes. 

### [3. MultiDC](3.MultiDC)

This template builds and configures a multi-datacenter cluster (one OpsCenter VM and 6 Cassandra nodes in 2 logical datacenters).


## Notes

* Most templates are currently based off the `ubuntu/trusty64` box which is running 64-bit Ubuntu 14.04 LTS. You can change the `vm.box` value if you want to try different guest operating systems.

