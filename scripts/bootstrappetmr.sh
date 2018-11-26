. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3

# install ccpetmr from scratch
## TODO it can be vagrant:vagrant
## SIRFUSERNAME=sirfuser
## SIRFPASS=virtual

##    adduser $SIRFUSERNAME
##    adduser $SIRFUSERNAME sudo
##    { echo $SIRFPASS; echo $SIRFPASS; } | passwd $SIRFUSERNAME 


	# remove serial port from grub configuration
## TODO: HACK for Ubuntu, not needed for SL7 can be ignored for sl7    
###	sed -i 's/ console=ttyS0//' /etc/default/grub.d/50-cloudimg-settings.cfg
##    update-grub
##	# update the apt-get database
##    apt-get update
##	# mark grup as hold as it requires user intervention on upgrade!
##	apt-mark hold grub-pc
##	# upgrade the list of packages
##	apt-get upgrade -y

## install GUI
##	#install upgrades
##	apt-get install -y wget git xorg xterm gdm menu gksu synaptic gnome-session gnome-panel metacity --no-install-recommends
##    apt-get install -y at-spi2-core gnome-terminal gnome-control-center nautilus dmz-cursor-theme network-manager network-manager-gnome
    
##	# start gnome display manager
##	service gdm start
## TODO HACK for Ubuntu, ignore for SL7    
##	# set the current locale, otherwise the gnome-terminal doesn't start
##	sudo locale-gen en_GB.UTF-8
##	sudo locale-gen en_US.UTF-8
##	sudo locale-gen de_DE.UTF-8
##	sudo locale-gen fr_FR.UTF-8
##	sudo locale-gen es_ES.UTF-8
##	sudo locale-gen it_IT.UTF-8
##	sudo locale-gen pt_PT.UTF-8
##	sudo locale-gen pt_BR.UTF-8
##	sudo locale-gen ja_JP.UTF-8
##	sudo locale-gen zh_CN.UTF-8
##	sudo update-locale LANG=en_GB.UTF-8
##	sudo localectl set-x11-keymap uk
##	sudo localectl status
	
	
##	# To hide vagrant from login screen:
##    #  1. Log-in as vagrant
##    #  2. In /var/lib/AccountsService/users/vagrant change 'SystemAccount=true'
##	sudo echo '[User]' > vagrant
##	sudo echo 'SystemAccount=true' >> vagrant
##	sudo cp -v vagrant /var/lib/AccountsService/users/vagrant

##	# To remove the Ubuntu user from VM:
##    sudo deluser --remove-home ubuntu
##    # Could add custom logos here: /etc/gdm3/greeter.dconf-defaults 

## cmake3 is part of SL7 EPEL
##	# download/install cmake
##    cd /opt
##    wget -c https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz
##    cd /usr/local
##    tar xzf /opt/cmake-3.7.2-Linux-x86_64.tar.gz --strip 1
sudo yum install -y git cmake3 gcc gcc-c++ 
## /opt/... or /usr/local should be used to install software

##    HOME=/home/sirfuser
##    mkdir $HOME/devel
##    cd $HOME/devel

## what?? I'm cloning this git repo into VM - it's already available in /vagrant	
# Script that install various packages needed for Gadgetron, SIRF etc
# on rhel-based system (CENTOS, Scientific Linux).
#
# Needs to be run with super-user permissions, e.g. via sudo

#if [ -z "SUDO" ]; then SUDO=sudo; fi

echo "Installing Gadgetron pre-requisites..."

sudo yum install -y hdf5-devel boost boost-devel gcc gcc-c++ make fftw-devel hdf5 hdf5-devel \
 lapack-devel libxml2-devel libxslt-devel armadillo-devel gtest-devel plplot-devel python-devel

# misssing h5utils, hdfview libace-dev g++ (c++?)
#libhdf5-serial-dev git-core cmake libboost-all-dev build-essential libfftw3-dev h5utils \
#      hdf5-tools hdfview python-dev liblapack-dev libxml2-dev \
#      libxslt-dev libarmadillo-dev libace-dev  \
#      g++ libgtest-dev libplplot-dev \
#      python-dev

echo "Installing SWIG..."

sudo yum install -y swig

# TODO replace with pip install
#echo "Installing python libraries etc"
# $SUDO apt-get install -y --no-install-recommends  python-scipy python-docopt  python-numpy python-h5py python-matplotlib python-libxml2 python-psutil python-tk python-nose
conda activate py3
conda install -y scipy docopt numpy h5py matplotlib libxml2 psutil tk nose 

#echo "installing glog"
# #$SUDO apt-get install -y libgoogle-glog-dev
sudo yum install -y glog-devel

#echo "installing pip for jupyter"
# $SUDO apt-get install -y python-pip python-qt4

cd $INSTALLDIR
## git clone https://github.com/CCPPETMR/CCPPETMR_VM.git CCPPETMR
## cd CCPPETMR_VM
##    bash $HOME/devel/CCPPETMR_VM/scripts/INSTALL_prerequisites_with_apt-get.sh
##    # install jupyter and firefox
## The idea is that jupyter might work on VM. But using firefox from VM isn't the proper way VM should be used. Firefox can be used from host - port 8080 can be redirected to guest thus browser rendering is using non-virtualized environment
 
##    apt-get install -y firefox
##    python -m pip install --upgrade pip
##    python -m pip install jupyter
##    python -m pip install spyder
git clone https://github.com/CCPPETMR/CCPPETMR_VM.git CCPPETMR
# in SL7, cmake3 is alias for cmake
sudo ln -s /usr/bin/cmake3 /usr/bin/cmake
$INSTALLDIR/CCPPETMR/scripts/UPDATE.sh
##    chown -R sirfuser:users /home/sirfuser/