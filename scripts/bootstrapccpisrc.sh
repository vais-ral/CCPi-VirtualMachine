. $INSTALLDIR/etc/profile.d/conda.sh

export SOURCEDIR=~/GitHub/
mkdir -p ${SOURCEDIR}

conda activate py3
# Preprocessing prerequisites - svn git python numpy, matlplotlib scipy tifffile
#yum install -y svn
conda install -q -y -c conda-forge numpy matplotlib scipy tifffile conda-build
# preprocesing from sources
#svn co https://ccpforge.cse.rl.ac.uk/svn/tomo_bhc/branches/release01 CCPi-Preprocessing
# apply fix for python 3, matplotlib
#sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/CCPi-Preprocessing/src/carouselUtils.py
sudo yum install -y git cmake3 gcc gcc-c++ 
sudo ln -s /usr/bin/cmake3 /usr/bin/cmake

#cd $INSTALLDIR
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-PreProcessing
cd CCPi-PreProcessing
# apply fix for python 3, matplotlib
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/CCPi-Preprocessing/src/carouselUtils.py
export CIL_VERSION=18.12
conda build Wrappers/Python/conda-recipe --python=3.5 --numpy=1.12


# cd $INSTALLDIR
cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit
cd CCPi-Regularisation-Toolkit
export CIL_VERSION=18.12
conda build Wrappers/Python/conda-recipe --python=3.5 --numpy=1.12
#--numpy 1.12 --python 3.5

conda install -y -c $INSTALLDIR/conda-bld/ ccpi-preprocessing=${CIL_VERSION}

# # regularization prerequisites - c/c++ cmake3 cython
# yum install -y git cmake3 gcc gcc-c++
# conda install -q -y cython
# #regularisation from sources
# cd $INSTALLDIR
# git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit.git  CCPi-Regularisation-Toolkit-src
# #cd CCPi-Regularisation-Toolkit
# mkdir CCPi-Regularisation-Toolkit-tmp-build
# cd CCPi-Regularisation-Toolkit-tmp-build
# cmake3 ../CCPi-Regularisation-Toolkit-src -DCONDA_BUILD=OFF -DBUILD_MATLAB_WRAPPER=OFF -DBUILD_PYTHON_WRAPPER=ON -DBUILD_CUDA=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALLDIR/CCPi-Regularisation-Toolkit -DPYTHON_EXECUTABLE=$INSTALLDIR/bin/python -DPYTHON_INCLUDE_DIR=$INSTALLDIR/include/python3.7m/ -DPYTHON_LIBRARY=$INSTALLDIR/lib/libpython3.7m.so
# make install
# conda install -q -y conda-build
# cd $INSTALLDIR/CCPi-Regularisation-Toolkit-src
# conda build Wrappers/Python/conda-recipe -c ccpi -c conda-forge
# #conda install fails with --use-local, need to use -c https://github.com/conda/conda/issues/7024
# conda install -y -c $INSTALLDIR/conda-bld/ ccpi-regulariser 
# #TODO delete src and tmp-build directory? Do conda build?

# #Reconstruction
# #yum install -y git
# #conda install -q -y conda-build boost
# conda install -q -y boost
# cd $INSTALLDIR

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Reconstruction.git
cd CCPi-Reconstruction
# export CIL_VERSION=0.10.0
conda build recipes/library -c conda-forge -c ccpi
# ## TODO 
conda install -y -c $INSTALLDIR/conda-bld/ cil_reconstruction=${CIL_VERSION}

conda build Wrappers/python/conda-recipe -c conda-forge -c ccpi --python=3.5 --numpy=1.12
conda install -y -c $INSTALLDIR/conda-bld/ ccpi-reconstruction=${CIL_VERSION}

# #conda build Wrappers/python/conda-recipe -c ccpi -c conda-forge --python 3.5 --numpy 1.12
# #conda install -c $INSTALLDIR/envs/py3/conda-bld/ ccpi-reconstruction 

# Build Framework, Plugins, and Astra

cd $SOURCEDIR
git clone https://github.com/vais-ral/CCPi-Framework.git
git clone https://github.com/vais-ral/CCPi-FrameworkPlugins.git
git clone https://github.com/vais-ral/CCPi-Astra.git
cd CCPi-Framework
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.5 --numpy=1.12
cd ../CCPi-FrameworkPlugins
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.5 --numpy=1.12
cd ../CCPi-Astra
conda build Wrappers/Python/conda-recipe -c conda-forge -c ccpi --python=3.5 --numpy=1.12
conda install -c ${INSTALLDIR}/conda-bld/ ccpi-framework=${CIL_VERSION}
conda install -c ${INSTALLDIR}/conda-bld/ ccpi-plugins=${CIL_VERSION}
conda install -c ${INSTALLDIR}/conda-bld/ ccpi-astra=${CIL_VERSION}
