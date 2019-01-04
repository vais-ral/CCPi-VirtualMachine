## set SELINUX to disabled
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sudo setenforce 0
## copy jupyter conf with no passwd
# copy all system config to /
sudo cp -R /vagrant/conf/* /
# escape slashes in installdirectory
export INSTALLDIRESC=$(echo $INSTALLDIR | sed 's_/_\\/_g')
# replace installdir variable value inside systemd service definition
sudo sed -i -e "s/INSTALLDIR=.*$/INSTALLDIR=${INSTALLDIRESC}/g" /etc/systemd/system/ccpi-jupyter.service 
#sudo sed -i -e "s/\(INSTALLDIR\s*=\s*\).*$/\1${INSTALLDIRESC}/g" /etc/systemd/system/ccpi-jupyter.service 

sudo chown -R vagrant:vagrant /home/vagrant/.jupyter
sudo chmod ugo-x /etc/systemd/system/ccpi-jupyter.service

## install httpd and enable port 80 in firewall
sudo yum install -y httpd firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --reload 
sudo systemctl enable httpd
sudo systemctl start httpd

## start jupyter job on port 8901 configure apache to forward to /jupyter 
sudo systemctl enable ccpi-jupyter
sudo systemctl start ccpi-jupyter 
