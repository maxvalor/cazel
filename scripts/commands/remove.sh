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

function removeDependsAndBuilds()
{
  if [ $# != 1 ]; then
    return 9
  fi

  logInfoMsg "command: cazel remove."

  local target_path=$1
  local json_all
  json_all=`loadDependsFile $target_path/$const_config_filename`
  if [ $? -ne 0 ]; then
    return 1
  fi

  local depends_path
  depends_path=`getJsonConfigValue "$json_all" "path"`
  if [ $? -ne 0 ]; then
    return 1
  fi
  if [ -d $target_path/$depends_path ]; then
    rm -rf $target_path/$depends_path
  fi

  if [ -d $target_path/$const_build_pathname ]; then
    rm -rf $target_path/$const_build_pathname
  fi

  return $?
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target to remove
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelRemove()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target=$1
  local ws=`pwd`
  local target_path
  target_path=`searchForProject $ws $target`

  case $? in
    0)
      removeDependsAndBuilds $target_path
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

  return $?
}
