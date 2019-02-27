sudo yum install -y git cmake3 gcc gcc-c++ 
sudo ln -s /usr/bin/cmake3 /usr/bin/cmake

export LOCALPKGDIR=${INSTALLDIR}/envs/py3/conda-bld
sudo mkdir -p ${SOURCEDIR}
sudo chown -R vagrant:vagrant ${SOURCEDIR}

. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3
conda update -n base -c defaults conda
# Preprocessing prerequisites
#yum install -y svn
conda install -q -y -c conda-forge numpy=1.15 matplotlib scipy tifffile conda-build

# preprocesing from sources
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-PreProcessing
cd CCPi-PreProcessing
# apply fix for python 3, matplotlib
#sed -i -e 's/axisbg/facecolor/g' $SOURCEDIR/CCPi-Preprocessing/src/carouselUtils.py
conda build Wrappers/Python/conda-recipe --python=3.6 --numpy=1.15

# Regularisation
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit
cd CCPi-Regularisation-Toolkit
conda build Wrappers/Python/conda-recipe --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} ccpi-preprocessing=${CIL_VERSION}

# Reconstruction
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Reconstruction.git
cd CCPi-Reconstruction
# build CIL library
conda build recipes/library -c conda-forge -c ccpi --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} cil_reconstruction=${CIL_VERSION}

# build ccpi-reconstruction package 
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} ccpi-reconstruction=${CIL_VERSION}

# Build Framework, Plugins, and Astra
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Framework.git
# original doesn't accept CIL_VERSION
#git clone https://github.com/vais-ral/CCPi-Framework.git
cd CCPi-Framework
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} ccpi-framework=${CIL_VERSION}

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-FrameworkPlugins.git
cd CCPi-FrameworkPlugins
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} ccpi-plugins=${CIL_VERSION}

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Astra.git
cd CCPi-Astra
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi -c astra-toolbox --python=3.6 --numpy=1.15
conda install -q -y -c ${LOCALPKGDIR} -c astra-toolbox ccpi-astra=${CIL_VERSION}

sudo chown -R vagrant:vagrant ${SOURCEDIR}
