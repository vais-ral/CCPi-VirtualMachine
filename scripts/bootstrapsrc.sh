# update kernel and kernel headers
bash /vagrant/scripts/update_kernel.sh
# installs ccpi from scratch
export INSTALLDIR=/opt/ccpi
# to prepare cvmfs installation uncomment
# export INSTALLDIR=/cvmfs/west-life.egi.eu/software/ccpi/18.12
export SOURCEDIR=/opt/ccpi-src
export CIL_VERSION=18.12

echo Bootstrapping Conda
bash /vagrant/scripts/installconda.sh
bash /vagrant/scripts/installcondasetrc.sh
echo Bootstrapping CCPi from src
bash /vagrant/scripts/installccpisrc.sh
#echo Bootstrapping Jupyter NB
#bash /vagrant/scripts/installjupyter.sh
#bash /vagrant/scripts/installjupyterservice.sh

#give vagrant ownership to INSTALLDIR
chown -R vagrant:vagrant $INSTALLDIR
cd $INSTALLDIR
find ./ -type d -exec chmod go+rx {} \;
find ./ -type f -exec chmod go+r {} \;

# to prepare cvmfs installation uncomment rest of the 
# cd ..
# tar -czf /vagrant/ccpi.tar.gz $CIL_VERSION
# ccpi.tar.gz should be transferred and untared into cvmfs repository.
# first installgsi.sh and then gsiscp 
#TODO fix jupyter env. Access Jupyter environment at http://localhost:8080/jupyter (replace default 8080 by the correct port forwarding, consult vagrant log for details)."

echo "CCPi installed. Connect to VM using 'vagrant ssh' or use VirtualBox to see the VM desktop."

