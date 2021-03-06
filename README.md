# CCPi Virtual Machine
This repository contains scripts to create virtual machine with installed CCPi software for tomographic imaging from scratch. VM includes virtual environment with Python 3.x and all CCPi repositories installed using `conda` tool at `/opt/ccpi` path.
Currently preprocessing, reconstruction, quantification, segmentation and regularisation are present.
- `/ccpi-vm-from-*` contains vagrant configuration to create VM from binaries/sources/cvmfs, see installation options
-	`/conf` 	contains configuration is replaced in VM
- `/notebooks` contains demo jupyter notebooks, available to view/edit after installation
-	`/scripts` contains bootstrap and installation scripts used by vagrant to configure VM. It can be used after installation to customize VM.
 
Requirement: 
- HW: 1 CPU, 2 GB RAM, 5-50GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (tested on Windows 7,Windows 10, Ubuntu 16.04)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.1.1. Some OS has their own distribution of vagrant and virtualbox: `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`.

## Brief installation from binaries

Type in your command line:

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
This option is for general user who wants use latest released CCPi libraries to process data. It use minimal Scientific Linux 7 with XFCE4 GUI VM template, CCPi is preinstalled in CVMFS repository which is mounted into read-only /cvmfs. Bootstrap is rapid (3 mins) and CCPi binaries are transparently downloaded to VM cache (cernvmfs) on demand, so first launch of ccpi libraries and tools may take significantly longer time depending on connection speed.

```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-cvmfs
vagrant up
```

### Installation from binaries
(15-20 mins)
This option is for general user who wants use latest released CCPi libraries and want to control the virtual python environment, in order to customize it. It uses minimal Scientific Linux 7 with XFCE4 GUI VM template, binaries of CCPi is installed using `conda` tool and ccpi channel.

```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-binaries
vagrant up
```

### Installation from sources
(40-120 mins)
This option is for developer user who wants to first download and build CCPi libraries from sources, e.g. in order to develop or add some functionality or test. This option uses same VM template, but installs the CCPi packages from sources. Modify the `scripts/bootstrapsrc.sh` in order to build or ommit particular packages.
```bash
git clone https://github.com/TomasKulhanek//CCPi-VirtualMachine.git
cd CCPi-VirtualMachine
cd ccpi-vm-from-sources
vagrant up
```


### Installation with empty environment
(5-10 mins)
This option is for developer user who wants just prepare initial environment,e.g. to develop and  build custom CCPi libraries from sources. This option uses same VM template, but does not install any CCPi packages. Modify the `scripts/bootstrapempty.sh` in order to build or ommit particular packages.
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

The VM contains apache web server and Python 3 virtual environment with selected Jupyter notebook available at `/jupyter` context path.
To access web UI of jupyter notebook, go http://localhost:[port]/jupyter/ (the [port] is 8080 and is forwarded to guest port 80, consult exact port in Vagrantfile). Demo notebooks are available after clicking `notebooks` folder or directly at http://localhost:[port]/jupyter/tree/notebooks/

The CCPi installation of Python 3.x and all CCPi dependent modules are present at `/opt/ccpi/` directory or at `/cvmfs/west-life.egi.eu/software/ccpi/latest`. Virtual environment with Python 3 is activated by default in BASH using `conda activate`. In order to exchange files between guest and host, the `/vagrant` is mapped to guest path of the `CCPi-VirtualMachine` directory. 
Follow https://cil.readthedocs.io and binary installation option for PATH `/opt/ccpi`.

- `vagrant halt` - shutdowns the VM.
- `vagrant up` - launched for the second and other time it will boot into existing VM in several seconds.
- `vagrant destroy` - will destroy VM with all the content, all files saved into guest `/vagrant` folder are preserved in host's current working directory from where `vagrant` was launched.

![Vagrant up screenshot](/vagrantupscreen.gif)
