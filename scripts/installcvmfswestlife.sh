#!/usr/bin/env bash
# configure cvmfs 
if [ ! -d "/cvmfs" ]; then
  yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
  yum install -y cvmfs cvmfs-config-default
  cvmfs_config setup
  echo "CVMFS_REPOSITORIES=west-life.egi.eu,wenmr.egi.eu
  #change it to local http proxy instance - squid, or similar
  CVMFS_HTTP_PROXY=DIRECT
  " >/etc/cvmfs/default.local
  
  service autofs restart
  cvmfs_config probe
fi
