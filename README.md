# CCPi Virtual Machine
This repository contains scripts to create virtual machine with installed CCPi software for tomographic imaging from scratch. VM includes virtual environment with Python 3.x and all CCPi repositories installed using `conda` tool at `/opt/ccpi` path.
Currently preprocessing, reconstruction, quantification, segmentation and regularisation are present.

## Brief installation from binaries
 
Requirement: 
- HW: 1 CPU, 2 GB RAM, 5-50GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (tested on Windows 7,Windows 10, Ubuntu 16.04)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.1.1. Some OS has their own distribution of vagrant and virtualbox: `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`.

Then type in your command line:

```bash
git clone https://github.com/vais-ral/CCPi-VirtualMachine.git
cd CCPi-VirtualMachine/ccpi-vm-from-binaries
vagrant up
```
- `git clone` - clones this repository into your preferred location 
- `cd CCPi-VirtualMachine/ccpi-vm-from-binaries` - changes dir to the repository directory where vagrant configuration is present
- `vagrant up` - for the first time it downloads and boots minimal Scientific Linux 7 with GUI environment (XFCE) (600 MB) from app.vagrantup.com and installs CCPi from conda. First boot provisions the system and takes around 15 minutes (depending on connection and HW it may take longer). It configures the ssh on guest and host to accept password-less login for vagrant user. It creates default shared folder in guest VM `\vagrant` which is shared to host's `CCPI-VirtualMachine`. 

## Other installation options

### Installation from CVMFS
(3mins)
This option use minimal Scientific Linux 7 with XFCE4 GUI VM template, CCPi is preinstalled in CVMFS repository which is mounted into /cvmfs. Bootstrap is rapid (3 mins) and CCPi binaries are transparently downloaded to VM cache (cernvmfs) on demand, so first launch of ccpi libraries and tools may take significantly longer time depending on connection speed.

```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-cvmfs
vagrant up
```

### Installation from binaries
(15-20 mins)
Default option, it uses minimal Scientific Linux 7 with XFCE4 GUI VM template, binaries of CCPi is installed using `conda` tool and ccpi channel.

```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-binaries
vagrant up
```

### Installation from sources
(40-120 mins)
This option will use same VM template, but installs the CCPi packages from sources. Modify the `scripts/bootstrapsrc.sh` in order to build or ommit particular packages.
```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-sources
vagrant up
```

## After installation
To access terminal of virtual machine, type:
- `vagrant ssh` - connects to the VM - only console access via ssh.

To access desktop, open VirtualBox and click the running virtual machine to show accees it's desktop.

To access web UI of jupyter notebook, go http://localhost:8080 (the port 8080 is by default forwarded to guest port 80, consult exact port in Vagrantfile).

The CCPi installation of Python 3.x and all CCPi dependent modules are present at `/opt/ccpi/` directory, PATH environment is set for BASH. In order to exchange files between guest and host, the `/vagrant` is mapped to guest path of the `CCPi-VirtualMachine` directory. 
Follow https://cil.readthedocs.io and binary installation option for PATH `/opt/ccpi`.

- `vagrant halt` - shutdowns the VM.
- `vagrant up` - launched for the second and other time it will boot into existing VM in several seconds.

![Vagrant up screenshot](/vagrantupscreen.gif)
