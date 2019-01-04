#!/usr/bin/env bash
#checks and install dependencies
export X509_USER_CERT=/home/vagrant/.ssh/tk.crt
export X509_USER_KEY=/home/vagrant/.ssh/tk.key

if [ ! -f ${X509_USER_CERT} ]; then
  echo generating cert files
  P12FILE=`ls /vagrant/*.p12`
  openssl pkcs12 -in ${P12FILE} -out ${X509_USER_CERT} -clcerts -nokeys
  openssl pkcs12 -in ${P12FILE} -out ${X509_USER_KEY} -nocerts -nodes
  chmod 400 ${X509_USER_CERT} ${X509_USER_KEY}
else
  echo Using existing cert and key.
fi

echo installing gsi client
if ! [ -x "$(command -v gsissh)" ]; then
  sudo yum install -y gsi-openssh-clients
fi

echo installing grid certificates
if ! [ -e /etc/grid-security/certificates/98ef0ee5.0 ]; then
  sudo mkdir -p /etc/grid-security/certificates
  sudo curl https://cert.ca.ngs.ac.uk/98ef0ee5.0 -o /etc/grid-security/certificates/98ef0ee5.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/98ef0ee5.signing_policy -o /etc/grid-security/certificates/98ef0ee5.signing_policy
  sudo curl https://cert.ca.ngs.ac.uk/7ed47087.0 -o /etc/grid-security/certificates/7ed47087.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/7ed47087.signing_policy -o /etc/grid-security/certificates/7ed47087.signing_policy
  sudo curl https://cert.ca.ngs.ac.uk/ffc3d59b.0 -o /etc/grid-security/certificates/ffc3d59b.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/ffc3d59b.signing_policy -o /etc/grid-security/certificates/ffc3d59b.signing_policy
  sudo curl https://cert.ca.ngs.ac.uk/530f7122.0 -o /etc/grid-security/certificates/530f7122.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/530f7122.signing_policy -o /etc/grid-security/certificates/530f7122.signing_policy
  sudo curl https://cert.ca.ngs.ac.uk/1b6f5ede.0 -o /etc/grid-security/certificates/1b6f5ede.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/1b6f5ede.signing_policy -o /etc/grid-security/certificates/1b6f5ede.signing_policy
  sudo curl https://cert.ca.ngs.ac.uk/877af676.0 -o /etc/grid-security/certificates/877af676.0
  sudo curl http://cert.ca.ngs.ac.uk/signing_policy/877af676.signing_policy -o /etc/grid-security/certificates/877af676.signing_policy
fi

echo Register your certificate ${X509_USER_CERT} with your cvmfs administrator
echo Connect to cvmfs upload using gsi ssh, certificate and private key, e.g.: 
echo
echo gsissh -p 1975 cvmfs-upload01.gridpp.rl.ac.uk
echo gsiscp -P 1975 [local-file] cvmfs-upload01.gridpp.rl.ac.uk:cvmfs_repo/software/ccpi/[version] 
echo gsiscp -r -P 1975 [local-directory] cvmfs-upload01.gridpp.rl.ac.uk:cvmfs_repo/software/ccpi/[version] 
