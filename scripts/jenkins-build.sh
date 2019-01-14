#!/bin/bash
# CIL_VERSION is optional, CCPI_CONDA_TOKEN is mandatory
echo CCPI_CONDA_TOKEN: ${CCPI_CONDA_TOKEN}
echo CIL_VERSION: ${CIL_VERSION}
if [[ -n ${CCPI_CONDA_TOKEN} ]]
then
  echo Building CCPi and uploading to anaconda using CCPI_CONDA_TOKEN ${CCPI_CONDA_TOKEN} 
else
  echo CCPI_CONDA_TOKEN not defined
  exit 1
fi

if [[ -n ${CIL_VERSION} ]]
then
  echo Using defined version: $CIL_VERSION
else
  export CIL_VERSION=0.10.4
  echo Defining version: $CIL_VERSION
fi
# Script to builds source code in Jenkins environment
# module try-load conda

# install miniconda if the module is not present
if hash conda 2>/dev/null; then
  echo using conda
else
  if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
  fi
  ./Miniconda3-latest-Linux-x86_64.sh -u -b -p .
  PATH=$PATH:./bin
fi

# presume that git clone is done before this script is launched, if not, uncomment
# git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit
conda install -y conda-build 

export INSTALLDIR=`pwd`
export SOURCEDIR=`pwd`
# preprocesing from sources
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-PreProcessing
. CCPi-PreProcessing/build/jenkins-build.sh

# Regularisation
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit
. CCPi-Regularisation-Toolkit/build/jenkins-build.sh

# Reconstruction
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Reconstruction.git
. CCPi-Reconstruction/build/jenkins-build.sh

# Build Framework, Plugins, and Astra
cd $SOURCEDIR
git clone https://github.com/TomasKulhanek/CCPi-Framework.git
. CCPi-Framework/build/jenkins-build.sh

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-FrameworkPlugins.git
. CCPi-FrameworkPlugins/build/jenkins-build.sh

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Astra.git
. CCPi-Astra/build/jenkins-build.sh
