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
yum install -y git cmake3 gcc gcc-c++ 
## /opt/... or /usr/local should be used to install software

##    HOME=/home/sirfuser
##    mkdir $HOME/devel
##    cd $HOME/devel

## what?? I'm cloning this git repo into VM - it's already available in /vagrant	

/vagrant/scripts/Install_prerequisites_with_yum.sh

##    git clone https://github.com/CCPPETMR/CCPPETMR_VM.git CCPPETMR
##    cd CCPPETMR_VM
##    bash $HOME/devel/CCPPETMR_VM/scripts/INSTALL_prerequisites_with_apt-get.sh
##    # install jupyter and firefox
## The idea is that jupyter might work on VM. But using firefox from VM isn't the proper way VM should be used. Firefox can be used from host - port 8080 can be redirected to guest thus browser rendering is using non-virtualized environment
 
##    apt-get install -y firefox
##    python -m pip install --upgrade pip
##    python -m pip install jupyter
##    python -m pip install spyder
## TODO bash $HOME/devel/CCPPETMR_VM/scripts/UPDATE.sh
##    chown -R sirfuser:users /home/sirfuser/