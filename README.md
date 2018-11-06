# tomographic-imaging-vm
VM with CCPi software for tomographic imaging

## Brief installation instruction from source codes 
Requirement: VirtualBox (tested on 5.2.8), Vagrant (tested on 2.1.1)
Minimal: 1 CPU, 2 GB RAM, 50GB disk space.
OS: Any which supported by VirtualBox or Vagrant (Windows 7,windows 10, Ubuntu 16.04 tested)

```bash
git clone https://github.com/TomasKulhanek/tomographic-imaging-vm

cd tomographic-imaging-vm

vagrant up
```

Open VirtualBox desktop and work with VM. 
In order to exchange files between guest and host, the `/vagrant` is mapped to guest path of the `tomographic-imaging-vm` directory.
