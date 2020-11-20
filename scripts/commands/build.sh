#!/bin/bash
#-----------------------------------------------------------------------------#
#                             includes                                        #
#-----------------------------------------------------------------------------#
source ${CAZEL_LIBS_PATH}/common/project.sh
source ${CAZEL_LIBS_PATH}/common/util.sh
source ${CAZEL_LIBS_PATH}/common/logger.sh

#-----------------------------------------------------------------------------#
#                             local varibles                                  #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

function buildTarget()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target_path=$1
  local workspace=`pwd`
  local json_all
  json_all=`loadDependsFile $target_path/$const_config_filename`
  if [ $? -ne 0 ]; then
    return 1
  fi

  if [ ! -d $target_path/$const_build_pathname ]; then
    mkdir -p $target_path/$const_build_pathname
  fi
  cd $target_path/$const_build_pathname
  local cmake_config
  cmake_config=`getJsonConfigValue "$json_all" "cmake"`
  if [ $? -ne 0 ]; then
    cmake_config=""
  fi
  cmake $cmake_config ..

  local make_config
  make_config=`getJsonConfigValue "$json_all" "make"`
  if [ $? -ne 0 ]; then
    make_config=""
  fi
  make $make_config
  cd $workspace

  return 0
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target to build
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelBuild()
{
  if [ $# != 1 ]; then
    return 9
  fi

  logInfoMsg "command: cazel build."

  local target=$1
  local ws=`pwd`
  local target_path
  target_path=`searchForProject $ws $target`

  case $? in
    0)
      buildTarget $target_path
      ;;
    1)
      echo "Target:"$1" not found. Please check your projects again."
      ;;
    2)
      echo "More than one target path is found:"
      for found_target in $target_path
      do
        echo " - $found_target"
      done
      ;;
    *)
      echo "unkown error."
      ;;
  esac
  return 0
}
