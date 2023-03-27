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
# CIL_TAG - The version to build. Is specified will build and upload requested tag/commit.
# - if CIL_TAG is not defined, then version is determined from `git describe --tags`
#   note that it contains information about last tag and number of commits after it.
#   thus e.g. last tag is `0.10.4` and current commit is 3 after this tag, then version is `0.10.4_3` is used
# - if the version is release (no number after '_'), anaconda upload is production
# - if the version is not release (number of commits after '_') then anaconda upload is labeled as 'dev'
# CCPI_CONDA_TOKEN - token to upload binary builds to anaconda 
# - it detects the branch under which the CCPi is build, master is uploaded to anaconda channel, non-master branch isn't
# NO_GPU - if set to true, GPU driver information is not printed
# RECIPE_PATH - if set, uses this as the path to the conda recipe instead of Wrappers/Python/conda-recipe
echo CCPi build 
echo called with arguments: $@
echo CCPI_BUILD_ARGS: $CCPI_BUILD_ARGS

# If NO_GPU = true then don't print GPU driver info
if [[ -z ${NO_GPU} ]] || [ ${NO_GPU} = false ]; then
  nvidia-smi
fi

# set test Python and NumPy version
if [[ ! -n ${TEST_PY} ]] ; then
  export TEST_PY=(3.8 3.8 3.10 3.10)
fi
if [[ ! -n ${TEST_NP} ]] ; then
  export TEST_NP=(1.21 1.23 1.21 1.23)
fi

if [[ ! -n ${RECIPE_PATH} ]] ; then
  export RECIPE_PATH=Wrappers/Python/conda-recipe
fi

if [[ -n ${CIL_TAG} ]]
then
  echo Using defined version: ${CIL_TAG}
  git checkout -f ${CIL_TAG}
fi

# find previous tag and count number of commits since
export CIL_TAG_PREV=$(git describe --tags --abbrev=0 | tr -d '/s/v//g' )
ncommits=$(git rev-list v${CIL_TAG_PREV}..HEAD --count)

if [ ${ncommits} -gt '0' ] ; then
  #CIL_VERSION is not used here, but some of our build scripts use the environment variable `CIL_VERSION`
  export CIL_VERSION=${CIL_TAG_PREV}_${ncommits}
  echo Building dev version: ${CIL_VERSION}
else
  export CIL_VERSION=${CIL_TAG_PREV}
  echo Building release version: ${CIL_VERSION}
fi

# print the latest git log message
git log -n 1

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

conda install -y conda-build

#This may be removed in future
if [[ -n ${CCPI_PRE_BUILD} ]]; then
  eval conda build "${CCPI_PRE_BUILD}"
  export REG_FILES=`eval conda build ${CCPI_PRE_BUILD} --output`$'\n' 
else
  export REG_FILES=""
fi
# need to call first build

if [[ -d ${RECIPE_PATH} ]]; then

  if [[ ${ncommits} == "0" ]]; then
    # one release build and test all
    eval conda build ${RECIPE_PATH} "$CCPI_BUILD_ARGS" "$@"
  else
    # first build all
    eval conda build --no-test ${RECIPE_PATH} "$CCPI_BUILD_ARGS" "$@"
    
    #then build some with tests
    for i in ${!TEST_PY[@]};
    do
      py_ver=${TEST_PY[$i]}
      np_ver=${TEST_NP[$i]}

      eval conda build ${RECIPE_PATH} "$CCPI_BUILD_ARGS" "$@" --python=${py_ver} --numpy=${np_ver}
    done

  fi
  # call with --output generates the files being created
  #export REG_FILES=$REG_FILES`eval conda build Wrappers/Python/conda-recipe "$CCPI_BUILD_ARGS" --output`$'\n'
  #--output bug work around
  export REG_FILES=`ls /home/jenkins/conda-bld/linux-64/*${CIL_VERSION}*${ncommits}.tar.bz2`
fi

if [[ -d recipe ]]; then
  ##if >0 commit (some _ in version) then marking as dev build
  if [[ ${ncommits} == "0" ]]; then
    # one release build and test all
    eval conda build recipe "$CCPI_BUILD_ARGS" "$@"
  else
    # first build all
    eval conda build --no-test recipe "$CCPI_BUILD_ARGS" "$@"
    
    #then rebuild some with tests
    for i in ${!TEST_PY[@]};
    do
      py_ver=${TEST_PY[$i]}
      np_ver=${TEST_NP[$i]}

      eval conda build recipe "$CCPI_BUILD_ARGS" "$@" --python=${py_ver} --numpy=${np_ver}
    done
  fi
  # call with --output generates the files being created
  #--output bug work around
  #export REG_FILES=$REG_FILES`eval conda build recipe "$CCPI_BUILD_ARGS" --output`$'\n'
  export REG_FILES=`ls /home/jenkins/conda-bld/linux-64/*${CIL_VERSION}*${ncommits}.tar.bz2`
fi

if ls /home/jenkins/conda-bld/linux-64/*${CIL_TAG_PREV}*.tar.bz2 1> /dev/null 2>&1; then
  export REG_FILES=`ls /home/jenkins/conda-bld/linux-64/*${CIL_TAG_PREV}*.tar.bz2`
elif ls /home/jenkins/conda-bld/noarch/*${CIL_TAG_PREV}*.tar.bz2 1> /dev/null 2>&1; then
  export REG_FILES=`ls /home/jenkins/conda-bld/noarch/*${CIL_TAG_PREV}*.tar.bz2`
else
  REG_FILES=""
  echo files not found
fi
  
echo files created: $REG_FILES

if [[ -n ${CCPI_POST_BUILD} ]]; then
  eval conda build "${CCPI_POST_BUILD}"
  export REG_FILES=$REG_FILES`eval conda build "${CCPI_POST_BUILD}" --output`
fi

# upload to anaconda only if token is defined
if [[ -n ${CCPI_CONDA_TOKEN} ]]; then
  #always upload if on master/main or if specific version was requested
  if [[ ${GIT_BRANCH} == "refs/heads/master" ]] || [[ ${GIT_BRANCH} == "refs/heads/main" ]] || [[ -n ${CIL_TAG} ]] ; then
    conda install -y anaconda-client python=3.8 
    while read -r outfile; do
      ## fix #22 anaconda error empty filename
      #export total_uploads="${outfile} ${REG_FILES}"
      echo uploading file ${outfile}
      if [[ ! -z "${outfile}" ]]; then
      ##if number of commits since tag is 0, then mark as main, else dev
        if [[ ${ncommits} == "0" ]]; then
          anaconda -v -t ${CCPI_CONDA_TOKEN}  upload ${outfile} --force --label main
        else
          anaconda -v -t ${CCPI_CONDA_TOKEN}  upload ${outfile} --force --label dev
        fi
      fi  
    done <<< "$REG_FILES"
  else
    echo git branch is not master, will not upload to anaconda.
  fi
else
  echo CCPI_CONDA_TOKEN not defined, will not upload to anaconda.
fi 
