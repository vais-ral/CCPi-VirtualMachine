# tomographic-imaging-vm
VM with CCPi software for tomographic imaging

## Brief installation instruction from source codes 
Requirement: [VirtualBox](https://www.virtualbox.org/wiki/Downloads) tested version 5.2.8, [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.1.1. Some OS has their own distribution of vagrant and virtualbox - so use `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`

Minimal: 1 CPU, 2 GB RAM, 50GB disk space.

OS: Any which supported by VirtualBox or Vagrant (Windows 7,windows 10, Ubuntu 16.04 tested)

```bash
git clone https://github.com/TomasKulhanek/tomographic-imaging-vm

cd tomographic-imaging-vm

vagrant up
```
By default it downloads minimal Scientific Linux 7 with GUI environment (XFCE) from app.vagrantup.com. 

Open VirtualBox desktop and work with VM. In order to exchange files between guest and host, the `/vagrant` is mapped to guest path of the `tomographic-imaging-vm` directory.
