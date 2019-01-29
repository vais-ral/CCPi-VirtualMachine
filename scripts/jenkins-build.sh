#!/usr/bin/env bash
#
# Copyright 2019 Tomas Kulhanek, see /LICENSE
#
# Universal script to build CCPi module libraries based on conda recipe in relative path at Wrappers/Python/conda-recipe
# variants are supported (combination of python version and dependent libraries).
# Typical usage:
#   cd CCPi-[ccpi-module]
#   export CCPI_BUILD_ARGS=[ccpi_build_args]
#   bash <(curl -L https://raw.githubusercontent.com/vais-ral/CCPi-VirtualMachine/master/scripts/jenkins-build.sh)
#
#   where [ccpi_build_args] are optional arguments passed to conda build e.g.: "-c ccpi -c conda-forge"
# These environment variables can be specified:
# CCPI_PRE_BUILD - if defined, then "conda build $PREBUILD" is performed before conda build, 
#                  binaries will be uploaded to anaconda channel together with main build
# CCPI_POST_BUILD - if defined, then "conda build $CCPI_POST_BUILD" is performed after conda build, 
#                  binaries will be uploaded to anaconda channel together with main build
# CCPI_BUILD_ARGS - passed to conda build as `conda build Wrappers/Python/conda-recipe "$CCPI_BUILD_ARGS"`
#   e.g. CCPI_BUILD_ARGS="-c ccpi -c conda-forge";
# CIL_VERSION - version of this build, it will be used to label it within multiple places during build
# - if CIL_VERSION is not expliticly defined, then version is determined from `git describe --tags`
#   note that it contains information about last tag and number of commits after it.
#   thus e.g. last tag is `0.10.4` and current commit is 3 after this tag, then version is `0.10.4_3`
# - if the version is release (no number after '_'), anaconda upload is production
# - if the version is not release (number of commits after '_') then anaconda upload is labeled as 'dev'
# - some commit can be explicitly tagged including '_' char and something after, then it is considered as 'dev' version
# CCPI_CONDA_TOKEN - token to upload binary builds to anaconda 
# - it detects the branch under which the CCPi is build, master is uploaded to anaconda channel, non-master branch isn't
echo CCPi build 
echo called with arguments: $@
echo CCPI_BUILD_ARGS: $CCPI_BUILD_ARGS

if [[ -n ${CIL_VERSION} ]]
then
  echo Using defined version: $CIL_VERSION
else
  # define CIL_VERSION from last git tag, remove first char ('v') and leave rest
  export CIL_VERSION=`git describe --tags | tail -c +2`  
  # dash means that it's some commit after tag release -thus will be treated as dev
  if [[ ${CIL_VERSION} == *"-"* ]]; then
    # detected dash means that it is dev version, 
    # get first and second part between first dash and ignore all after other dash (usually sha)
    # and as dash is prohibited for conda build, replace with underscore
    export CIL_VERSION=`echo ${CIL_VERSION} | cut -d "-" -f -2 | tr - _`    
    echo Building dev version: ${CIL_VERSION}
  else
    echo Building release version: $CIL_VERSION
  fi
fi

# Script to builds source code in Jenkins environment
# module try-load conda

# install miniconda if the module is not present
if hash conda 2>/dev/null; then
  echo using installed conda
else
  if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
    wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
  fi
  ./Miniconda3-latest-Linux-x86_64.sh -u -b -p .
  PATH=$PATH:./bin
fi

GIT_BRANCH=`git rev-parse --symbolic-full-name HEAD`
echo on branch ${GIT_BRANCH}
cat .git/HEAD

# presume that git clone is done before this script is launched, if not, uncomment
#git clone https://github.com/vais-ral/CCPi-Regularisation-Toolkit
conda install -y conda-build
#cd CCPi-Regularisation-Toolkit # already there by jenkins

if [[ -n ${CCPI_PRE_BUILD} ]]; then
  conda build "${CCPI_PRE_BUILD}"
  export REG_FILES=`conda build "${CCPI_PRE_BUILD} --output`$'\n' 
fi
# need to call first build
conda build Wrappers/Python/conda-recipe "$CCPI_BUILD_ARGS" "$@"
# then need to call the same with --output 
#- otherwise no build is done :-(, just fake file names are generated
export REG_FILES=$REG_FILES`conda build Wrappers/Python/conda-recipe --output`$'\n'
# REG_FILES variable should contain output files
echo files created: $REG_FILES

if [[ -n ${CCPI_POST_BUILD} ]]; then
  conda build "${CCPI_POST_BUILD}"
  export REG_FILES=$REG_FILES`conda build "${CCPI_POST_BUILD} --output`
fi

# upload to anaconda only if token is defined
if [[ -n ${CCPI_CONDA_TOKEN} ]]; then
  if [[ ${GIT_BRANCH} == "refs/heads/master" ]]; then
    conda install anaconda-client
    while read -r outfile; do
      #if >0 commit (some _ in version) then marking as dev build
      if [[ $CIL_VERSION == *"_"* ]]; then
        # upload with dev label
        anaconda -v -t ${CCPI_CONDA_TOKEN}  upload $outfile --force --label dev
      else
        anaconda -v -t ${CCPI_CONDA_TOKEN}  upload $outfile --force
      fi
    done <<< "$REG_FILES"
  else
    echo git branch is not master, will not upload to anaconda.
  fi
else
  echo CCPI_CONDA_TOKEN not defined, will not upload to anaconda.
fi 