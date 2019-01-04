if grep -Fxq "conda.sh" /home/vagrant/.bashrc
then
  echo conda already set
else
  echo . $INSTALLDIR/etc/profile.d/conda.sh >> /home/vagrant/.bashrc
  #echo export PATH=\$PATH:$INSTALLDIR/bin >> /home/vagrant/.bashrc
  echo conda activate py3 >> /home/vagrant/.bashrc
  echo echo -e \"CCPi is installed into py3 environment.\\n'py3' is now activated.\\nTo deactivate, type:\\n  conda deactivate\" >> /home/vagrant/.bashrc
fi