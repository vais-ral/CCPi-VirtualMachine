# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
export SOURCEDIR=/opt/ccpi-src
export CIL_VERSION=18.12

echo Bootstrapping Conda
bash /vagrant/scripts/bootstrapconda.sh
echo Bootstrapping CCPi from src
bash /vagrant/scripts/bootstrapccpisrc.sh

#give vagrant ownership to INSTALLDIR
chown -R vagrant:vagrant $INSTALLDIR
echo "CCPi installed. Connect to VM using 'vagrant ssh' or use VirtualBox to see the VM desktop."
