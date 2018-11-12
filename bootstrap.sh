#sudo in case this script is executed after installation
INSTALLDIR=/opt/ccpi
sudo yum install -y wget bzip2
if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
fi
sudo mkdir -p /opt/ccpi
sudo chown vagrant:vagrant /opt/ccpi
./Miniconda3-latest-Linux-x86_64.sh -u -b -p $INSTALLDIR
PATH=$PATH:$INSTALLDIR/bin
conda create -y --name py3 python=3
conda activate py3
#preprocessing reconstruction quantification segmentation regularisation
conda install -y -c ccpi -c conda-forge ccpi-preprocessing ccpi-reconstruction ccpi-quantification ccpi-segmentation ccpi-regulariser numpy=1.12
#fix preprocessing library 
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py

if grep -Fxq "conda.sh" /home/vagrant/.bashrc
then
  echo conda already set
else
  echo . $INSTALLDIR/etc/profile.d/conda.sh >> /home/vagrant/.bashrc
  echo export PATH=\$PATH:$INSTALLDIR/bin >> /home/vagrant/.bashrc
fi

