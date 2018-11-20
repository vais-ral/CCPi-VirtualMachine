# installs ccpi from scratch
#added sudo to execute this script after installation
INSTALLDIR=/opt/ccpi
sudo yum install -y wget bzip2
if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
  wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
fi
sudo mkdir -p /opt/ccpi
sudo chown vagrant:vagrant /opt/ccpi
./Miniconda3-latest-Linux-x86_64.sh -u -b -p $INSTALLDIR
PATH=$PATH:$INSTALLDIR/bin
conda create -q -y --name py3 python=3
conda activate py3
#preprocessing reconstruction quantification segmentation regularisation
conda install -q -y -c ccpi -c conda-forge ccpi-preprocessing ccpi-reconstruction ccpi-quantification ccpi-segmentation ccpi-regulariser numpy=1.12
#fix preprocessing library 
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py

if grep -Fxq "conda.sh" /home/vagrant/.bashrc
then
  echo conda already set
else
  echo . $INSTALLDIR/etc/profile.d/conda.sh >> /home/vagrant/.bashrc
  #echo export PATH=\$PATH:$INSTALLDIR/bin >> /home/vagrant/.bashrc
  echo conda activate py3 >> /home/vagrant/.bashrc
  echo echo -e \"CCPi is installed into py3 environment.\\n'py3' is now activated.\\nTo deactivate, type:\\n  conda deactivate\" >> /home/vagrant/.bashrc
fi

# install ccpetmr from scratch
## what?? it can be vagrant:vagrant
## SIRFUSERNAME=sirfuser
## SIRFPASS=virtual

##    adduser $SIRFUSERNAME
##    adduser $SIRFUSERNAME sudo
##    { echo $SIRFPASS; echo $SIRFPASS; } | passwd $SIRFUSERNAME 


	# remove serial port from grub configuration
## HACK for Ubuntu, can be ignored for sl7    
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
## HACK for Ubuntu, ignore for SL7    
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
/vagrant/Install_prerequisites_with_yum.sh

##    git clone https://github.com/CCPPETMR/CCPPETMR_VM.git CCPPETMR
##    cd CCPPETMR_VM
##    bash $HOME/devel/CCPPETMR_VM/scripts/INSTALL_prerequisites_with_apt-get.sh
##    # install jupyter and firefox
## The idea is that jupyter might work on VM. But using firefox from VM isn't the proper way VM should be used. Firefox can be used from host - port 8080 can be redirected to guest thus browser rendering is using non-virtualized environment
 
##    apt-get install -y firefox
##    python -m pip install --upgrade pip
##    python -m pip install jupyter
##    python -m pip install spyder
##    bash $HOME/devel/CCPPETMR_VM/scripts/UPDATE.sh
##    chown -R sirfuser:users /home/sirfuser/

## Jupyter in SL7
## set DIR and VERSION e.g. to point to another directory
DIR=$INSTALLDIR
VERSION=jupyter

#sudo in case this script is executed after installation
#sudo yum install -y wget bzip2

mkdir -p $DIR
cd $DIR

conda install -y jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 
conda install -y -c rdkit rdkit

# set SELINUX to disabled
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
setenforce 0
## copy jupyter conf with no passwd
mkdir /home/vagrant/.jupyter
cp /vagrant/jupyter_notebook_config.py /home/vagrant/.jupyter
## start jupyter job on port 8901, and context /jupyter will be redirected in apache (port 80) 
yum install -y httpd
systemctl enable httpd
systemctl start httpd

/vagrant/startstopJupyter.sh add vagrant 8901 /jupyter /vagrant/jupyter.log
## # machine learning course
## conda install -y scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow 
## 
## # data science handbook
## conda install -y scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 
## 
## # jupyter tips and tricks
## conda install -y pivottablejs jupyterlab
## conda install -y -c conda-forge bqplot mpld3 ipython-sql
## 
## # jupyter nglview and ssbio - pip is used - conda has some issues???
## pip install nglview ssbio
## jupyter-nbextension enable nglview --py --sys-prefix
## 
## #sos polyglot notebook
## pip install sos
## pip install sos-notebook
## python -m sos_notebook.install
## jupyter labextension install jupyterlab-sos
## 
## # jupyter prov-o support 
## pip install prov
## 
## #link to jupyter installation
## ln -s $DIR/$VERSION /opt/jupyter
## #install dependencies of ssbio
## #dssp
## yum install -y dssp
## ln -s /usr/bin/mkdssp /usr/bin/dssp
## #yum install msms
## #ln -s /usr/local/lib/msms/msms.x86_64Linux2.2.6.1 /usr/local/bin/msms
## #ln -s /usr/local/lib/msms/pdb_to_xyzr* /usr/local/bin/
## #stride
## #mkdir -p /usr/local/lib/stride
## #freesasa
## #
## 
## #autosklearn
## #swig 3 from sources
## wget http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz
## tar -xzf swig-3.0.12.tar.gz
## cd swig-3.0.12
## ./configure
## make
## make install
## cd ..
## 
## #auto-sklearn
## curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip install
## pip install auto-sklearn

echo "CCPi installed. Connect to VM using 'vagrant ssh' or use VirtualBox to see the VM desktop. Jupyter nb available. Guest port 80 redirected to 8080. Open your browser at http://localhost:8080/jupyter"

