. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3

#preprocessing reconstruction quantification segmentation regularisation
## moved to bootstrapconda - to reduce installation time
#conda install -q -y -c ccpi -c conda-forge -c paskino ccpi-preprocessing ccpi-reconstruction ccpi-quantification ccpi-segmentation ccpi-regulariser ace numpy=1.15
conda install -q -y -c ccpi/label/dev -c conda-forge -c paskino ccpi-preprocessing ccpi-reconstruction ccpi-segmentation ccpi-regulariser ace python=3.6
#ccpi-quantification #bad build

#conda install -q -y -c ccpi -c conda-forge ccpi-preprocessing ccpi-reconstruction ccpi-quantification ccpi-segmentation ccpi-regulariser numpy=1.12
#fix preprocessing library 
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/envs/py3/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py
