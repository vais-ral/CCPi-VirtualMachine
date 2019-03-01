#update kernel and kernel-headers
bash /vagrant/scripts/update_kernel.sh

# use ccpi from cvmfs installation
export INSTALLDIR=/cvmfs/west-life.egi.eu/software/ccpi/latest
bash /vagrant/scripts/installcvmfswestlife.sh
#echo Bootstrapping Conda
#bash /vagrant/scripts/installconda.sh
bash /vagrant/scripts/installcondasetrc.sh
#echo Boostrapping CCPI
#bash /vagrant/scripts/installccpi.sh
#echo Bootstrapping Jupyter NB
#bash /vagrant/scripts/installjupyter.sh
bash /vagrant/scripts/installjupyterservice.sh

sudo chown -R vagrant:vagrant /home/vagrant/.Conda

echo "CCPi installed. Connect to VM using 'vagrant ssh', use VirtualBox VM desktop. Jupyter available at http://localhost:8080/jupyter"
