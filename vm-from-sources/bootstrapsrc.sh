#sudo in case this script is executed after installation
INSTALLDIR=/opt/ccpi
yum install -y wget bzip2
if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
  wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
fi
sudo mkdir -p /opt/ccpi
sudo chown vagrant:vagrant /opt/ccpi
./Miniconda3-latest-Linux-x86_64.sh -u -b -p $INSTALLDIR
PATH=$PATH:$INSTALLDIR/bin
conda create -q -y --name py3 python=3
# set bash environment
if grep -Fxq "conda.sh" /home/vagrant/.bashrc
then
  echo conda already set
else
  echo . $INSTALLDIR/etc/profile.d/conda.sh >> /home/vagrant/.bashrc
  # echo export PATH=\$PATH:$INSTALLDIR/bin >> /home/vagrant/.bashrc  
  echo conda activate py3 >> /home/vagrant/.bashrc
  echo echo -e \"CCPi is installed into py3 environment.\\n'py3' is now activated.\\nTo deactivate, type:\\n  conda deactivate\" >> /home/vagrant/.bashrc
fi

conda activate py3
# Preprocessing prerequisites - svn git python numpy, matlplotlib scipy tifffile
yum install -y svn git
conda install -q -y numpy matplotlib scipy
conda install -q -y -c conda-forge tifffile
# preprocesing from sources
cd $INSTALLDIR
svn co https://ccpforge.cse.rl.ac.uk/svn/tomo_bhc/branches/release01 CCPi-Preprocessing
# apply fix for python 3, matplotlib
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/CCPi-Preprocessing/src/carouselUtils.py

# regularization prerequisites - c/c++ cmake3 cython
yum install -y cmake3 gcc gcc-c++
conda install -q -y cython
#regularisation from sources
cd $INSTALLDIR
git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit.git  CCPi-Regularisation-Toolkit-src
#cd CCPi-Regularisation-Toolkit
mkdir CCPi-Regularisation-Toolkit-tmp-build
cd CCPi-Regularisation-Toolkit-tmp-build
cmake3 ../CCPi-Regularisation-Toolkit-src -DCONDA_BUILD=OFF -DBUILD_MATLAB_WRAPPER=OFF -DBUILD_PYTHON_WRAPPER=ON -DBUILD_CUDA=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALLDIR/CCPi-Regularisation-Toolkit -DPYTHON_EXECUTABLE=$INSTALLDIR/bin/python -DPYTHON_INCLUDE_DIR=$INSTALLDIR/include/python3.7m/ -DPYTHON_LIBRARY=$INSTALLDIR/lib/libpython3.7m.so
make install

#Reconstruction
conda install -q -y conda-build boost
cd $INSTALLDIR
git clone https://github.com/vais-ral/CCPi-Reconstruction.git
cd CCPi-Reconstruction
conda build conda-recipe -c ccpi -c conda-forge --python 3.5 --numpy 1.12

echo "CCPi installed. Connect to VM using 'vagrant ssh' or use VirtualBox to see the VM desktop."
