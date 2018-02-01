## 2.MultiNode Template

This Vagrant template sets up 3 separate VMs for creating an Apache Cassandra cluster:

* cassandra[1-3] - base system (only Java pre-installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM, but with all 3 running it may be too much for your host.

## Instructions

### Setup

If Vagrant has been installed correctly, you can bring up the 3 VMs with the following:

```
$ vagrant up
```

Note: This will bring up each VM in series and then provision it. 

When the up command is done, you can check the status of the 4 VMs:

```
$ vagrant status
Current machine states:

cassandra1                     running (virtualbox)
cassandra2                     running (virtualbox)
cassandra3                     running (virtualbox)
```

The `vagrant ssh` command will let you login to one node at a time. You can also use a for loop to run a command on all 3 VMs, for example:

```
$ for i in {1..3}; do vagrant ssh cassandra$i -c 'uname -a'; done
Linux cassandra1 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Linux cassandra2 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Linux cassandra3 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
```

follow the instructions on [installing cassandra](http://cassandra.apache.org/doc/latest/getting_started/installing.html) in order to install cassandra on all three servers

once installed run `nodetool status` on all thee servers
```
$ vagrant ssh cassandra1

vagrant@cassandra1:~$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address    Load       Tokens       Owns (effective)  Host ID                               Rack
UN  127.0.0.1  299.71 KiB  256          100.0%            904cee0d-4de6-4ebc-956e-4d771aaf3de6  rack1
```


To destroy all 3 VMs:

```
$ vagrant destroy -f
```
