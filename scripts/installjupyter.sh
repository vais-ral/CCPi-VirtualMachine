echo installing Jupyter into SL7
## set DIR and VERSION e.g. to point to another directory

DIR=$INSTALLDIR

# sudo in case this script is executed after installation
# sudo yum install -y wget bzip2
# 
mkdir -p $DIR
cd $DIR
. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3

#echo installing jupyter, octave, r notebook packages
conda install -q -y -c conda-forge jupyter scipy numpy h5py matplotlib rdkit scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow scikit-image pandas-datareader jupyterlab bqplot mpld3 ipython-sql octave octave_kernel ghostscript texinfo graphicsmagick
conda install -q -y -c r r r-irkernel

#conda config --add channels ccpi conda-forge paskino 
# installing all -as ccpi request some lower versions of libraries
#conda install -q -y -c conda-forge jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 scipy docopt numpy=1.12 h5py matplotlib libxml2 psutil tk nose
#conda install -q -y -c conda-forge jupyter pymc3 r-irkernel r tornado scipy docopt numpy h5py matplotlib libxml2 psutil tk nose rdkit scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 pivottablejs jupyterlab bqplot mpld3 ipython-sql octave octave_kernel ghostscript texinfo graphicsmagick
#conda install -q -y -c conda-forge octave octave_kernel ghostscript texinfo graphicsmagick

## moved to bootstrapconda - to reduce installation time
#conda install -q -y jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 
#echo installing rdkit
# installing all
# conda install -q -y -c rdkit -c conda-forge rdkit scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 pivottablejs jupyterlab bqplot mpld3 ipython-sql

## # machine learning course
#conda install -y scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow 
## 
## # data science handbook
#conda install -y scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 
## 
## # jupyter tips and tricks
#conda install -y pivottablejs jupyterlab
#conda install -y -c conda-forge bqplot mpld3 ipython-sql
## 
## # jupyter nglview and ssbio - pip is used - conda has some issues???
#pip install --upgrade pip
#pip install nglview ssbio
#conda install -q -y nodejs
#jupyter-nbextension enable nglview --py --sys-prefix
## 
## #sos polyglot notebook, to support multiple engines (Python+Octave) in single notebook
pip install sos
pip install sos-notebook
## python -m sos_notebook.install
jupyter labextension install jupyterlab-sos
## 
## # jupyter prov-o support 
#pip install prov
## 


## octave
#sudo yum install -y octave

