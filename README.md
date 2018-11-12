# tomographic-imaging-vm
Virtual machine with installed CCPi software for tomographic imaging. VM includes separate environment with Python 3.5 and all CCPi repositories installed using `conda` tool at `/opt/ccpi` path.

## Brief installation instruction from source codes 
Requirement: [VirtualBox](https://www.virtualbox.org/wiki/Downloads) tested version 5.2.8, [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.1.1. Some OS has their own distribution of vagrant and virtualbox - so use `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`

Minimal: 1 CPU, 2 GB RAM, 5-50GB disk space.

OS: Any which supported by VirtualBox or Vagrant (Windows 7,windows 10, Ubuntu 16.04 tested)

Then type in your command line:

```bash
git clone https://github.com/TomasKulhanek/tomographic-imaging-vm
cd tomographic-imaging-vm
vagrant up
```
- `git clone` - clones this repository into your preferred location 
- `cd tomographic-imaging-vm` - changes dir to the repository directory
- `vagrant up` - for the first time it downloads and boots minimal Scientific Linux 7 with GUI environment (XFCE) (600 MB) from app.vagrantup.com and installs CCPi from conda. First boot provisions the system and takes 17 and more minutes. It configures the ssh on guest and host to accept password-less login. It creates default shared folder `tomographic-imaging-vm` which is shared in quest as `\vagrant`. 

## After installation
Open VirtualBox desktop and work with VM. In order to exchange files between guest and host, the `/vagrant` is mapped to guest path of the `tomographic-imaging-vm` directory.
- `vagrant ssh` - connects to the VM - only console access via ssh.
- `vagrant halt` - shutdowns the VM.
- `vagrant up` - launched for the second and other time it will boot into existing VM in several seconds.

![Vagrant up screenshot](/vagrantupscreen.gif)
