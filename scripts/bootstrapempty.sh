#update kernel and kernel-headers
bash /vagrant/scripts/update-kernel.sh
# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
echo Bootstrapping Conda
bash /vagrant/scripts/installconda.sh
bash /vagrant/scripts/installcondasetrc.sh

#echo Boostrapping CCPI
#bash /vagrant/scripts/installccpi.sh

#echo Bootstrapping Jupyter NB
#bash /vagrant/scripts/installjupyter.sh
#bash /vagrant/scripts/installjupyterservice.sh
#TODO fix jupyter env. Access Jupyter environment at http://localhost:8080/jupyter (replace default 8080 by the correct port forwarding, consult vagrant log for details)."


sudo chown -R vagrant:vagrant /home/vagrant/.Conda
sudo chown -R vagrant:vagrant $INSTALLDIR

echo "CCPi VM installed. Connect to VM using 'vagrant ssh' or use VirtualBox VM desktop. 
