# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
echo Bootstrapping Conda
/vagrant/scripts/bootstrapconda.sh
echo Bootstrapping CCPi from src
/vagrant/scripts/bootstrapccpisrc.sh

#give vagrant ownership to INSTALLDIR
chown -R vagrant:vagrant $INSTALLDIR
echo "CCPi installed. Connect to VM using 'vagrant ssh' or use VirtualBox to see the VM desktop."
