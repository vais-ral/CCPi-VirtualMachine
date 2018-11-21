# Script that install various packages needed for Gadgetron, SIRF etc
# on rhel-based system (CENTOS, Scientific Linux).
#
# Needs to be run with super-user permissions, e.g. via sudo

#if [ -z "SUDO" ]; then SUDO=sudo; fi

echo "Installing Gadgetron pre-requisites..."

yum install -y hdf5-devel boost boost-devel gcc gcc-c++ make fftw-devel hdf5 hdf5-devel \
 lapack-devel libxml2-devel libxslt-devel armadillo-devel gtest-devel plplot-devel python-devel

# misssing h5utils, hdfview libace-dev g++ (c++?)
#libhdf5-serial-dev git-core cmake libboost-all-dev build-essential libfftw3-dev h5utils \
#      hdf5-tools hdfview python-dev liblapack-dev libxml2-dev \
#      libxslt-dev libarmadillo-dev libace-dev  \
#      g++ libgtest-dev libplplot-dev \
#      python-dev

echo "Installing SWIG..."

yum install -y swig

# TODO replace with pip install
#echo "Installing python libraries etc"
# $SUDO apt-get install -y --no-install-recommends  python-scipy python-docopt  python-numpy python-h5py python-matplotlib python-libxml2 python-psutil python-tk python-nose
conda install -y scipy docopt numpy h5py matplotlib libxml2 psutil tk nose 

#echo "installing glog"
# #$SUDO apt-get install -y libgoogle-glog-dev
yum install -y glog-devel

#echo "installing pip for jupyter"
# $SUDO apt-get install -y python-pip python-qt4
