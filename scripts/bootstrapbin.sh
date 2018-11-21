# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
/vagrant/scripts/bootstrapconda.sh
# /vagrant/scripts/bootstrapccpi.sh
# /vagrant/scripts/bootstrappetmr.sh
/vagrant/scripts/bootstrapjupyter.sh

echo "CCPi installed. Connect to VM using 'vagrant ssh', use VirtualBox VM desktop. Jupyter available at http://localhost:8080/jupyter"

