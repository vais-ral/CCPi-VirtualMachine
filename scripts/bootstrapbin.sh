# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
echo Bootstrapping Conda
bash /vagrant/scripts/bootstrapconda.sh
echo Bootstrapping Jupyter NB
bash /vagrant/scripts/bootstrapjupyter.sh
echo Boostrapping CCPI
bash /vagrant/scripts/bootstrapccpi.sh

sudo chown -R vagrant:vagrant /home/vagrant/.Conda
sudo chown -R vagrant:vagrant $INSTALLDIR

echo "CCPi installed. Connect to VM using 'vagrant ssh', use VirtualBox VM desktop. Jupyter available at http://localhost:8080/jupyter"

