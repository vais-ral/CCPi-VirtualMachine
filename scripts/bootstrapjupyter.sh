echo installing Jupyter into SL7
## set DIR and VERSION e.g. to point to another directory

DIR=$INSTALLDIR
VERSION=jupyter

# sudo in case this script is executed after installation
# sudo yum install -y wget bzip2
# 
mkdir -p $DIR
cd $DIR
. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3

#echo installing jupyter packages
#conda config --add channels ccpi conda-forge paskino 
# installing all -as ccpi request some lower versions of libraries
#conda install -q -y -c conda-forge jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 scipy docopt numpy=1.12 h5py matplotlib libxml2 psutil tk nose
conda install -q -y -c conda-forge jupyter pymc3 r-irkernel r tornado scipy docopt numpy=1.12 h5py matplotlib libxml2 psutil tk nose

## moved to bootstrapconda - to reduce installation time
#conda install -q -y jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 
#echo installing rdkit
# installing all
conda install -q -y -c rdkit -c conda-forge rdkit scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 pivottablejs jupyterlab bqplot mpld3 ipython-sql

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
pip install nglview ssbio
jupyter-nbextension enable nglview --py --sys-prefix
## 
## #sos polyglot notebook
pip install sos
pip install sos-notebook
## python -m sos_notebook.install
jupyter labextension install jupyterlab-sos
## 
## # jupyter prov-o support 
pip install prov
## 
## #link to jupyter installation
## ln -s $DIR/$VERSION /opt/jupyter
## #install dependencies of ssbio
## #dssp
## yum install -y dssp
## ln -s /usr/bin/mkdssp /usr/bin/dssp
## #yum install msms
## #ln -s /usr/local/lib/msms/msms.x86_64Linux2.2.6.1 /usr/local/bin/msms
## #ln -s /usr/local/lib/msms/pdb_to_xyzr* /usr/local/bin/
## #stride
## #mkdir -p /usr/local/lib/stride
## #freesasa
## #
## 
## #autosklearn
## #swig 3 from sources
wget http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz
tar -xzf swig-3.0.12.tar.gz
cd swig-3.0.12
./configure
make
sudo make install
cd ..
## 
## #auto-sklearn
curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip install
pip install auto-sklearn

## octave
#sudo yum install -y octave
conda install -q -y -c conda-forge octave octave_kernel ghostscript texinfo

## set SELINUX to disabled
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sudo setenforce 0
## copy jupyter conf with no passwd
# copy all system config to /
sudo cp -R /vagrant/conf/* / 
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
