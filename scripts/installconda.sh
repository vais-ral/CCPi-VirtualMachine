#added sudo to execute this script after installation
yum install -y wget bzip2
if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
  wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
fi
mkdir -p $INSTALLDIR
./Miniconda3-latest-Linux-x86_64.sh -u -b -p $INSTALLDIR
PATH=$PATH:$INSTALLDIR/bin
conda create -q -y --name py3 python=3.6
conda update -n base -c defaults conda
#conda update -y -n root conda
#chown -R vagrant:vagrant $INSTALLDIR
conda activate py3
#conda update -n base -c defaults conda
# rest file moved to bootstrapcondasetrc.sh