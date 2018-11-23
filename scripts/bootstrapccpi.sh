. $INSTALLDIR/etc/profile.d/conda.sh
conda activate py3

#preprocessing reconstruction quantification segmentation regularisation
conda install -q -y -c ccpi -c conda-forge ccpi-preprocessing ccpi-reconstruction ccpi-quantification ccpi-segmentation ccpi-regulariser numpy=1.12
#fix preprocessing library 
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py
sed -i -e 's/axisbg/facecolor/g' $INSTALLDIR/envs/py3/lib/python3.5/site-packages/ccpi/preprocessing/beamhardening/carouselUtils.py
