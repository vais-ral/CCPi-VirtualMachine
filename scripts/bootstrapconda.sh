#added sudo to execute this script after installation
yum install -y wget bzip2
if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
  wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
fi
mkdir -p $INSTALLDIR
./Miniconda3-latest-Linux-x86_64.sh -u -b -p $INSTALLDIR
PATH=$PATH:$INSTALLDIR/bin
conda create -q -y --name py3 python=3.5
#chown -R vagrant:vagrant $INSTALLDIR
#conda activate py3
if grep -Fxq "conda.sh" /home/vagrant/.bashrc
then
  echo conda already set
else
  echo . $INSTALLDIR/etc/profile.d/conda.sh >> /home/vagrant/.bashrc
  #echo export PATH=\$PATH:$INSTALLDIR/bin >> /home/vagrant/.bashrc
  echo conda activate py3 >> /home/vagrant/.bashrc
  echo echo -e \"CCPi is installed into py3 environment.\\n'py3' is now activated.\\nTo deactivate, type:\\n  conda deactivate\" >> /home/vagrant/.bashrc
fi


